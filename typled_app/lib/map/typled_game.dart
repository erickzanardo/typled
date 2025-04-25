import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:path/path.dart' as path;
import 'package:typled/typled.dart';
import 'package:typled_editor/atlas_provider.dart';
import 'package:typled_editor/extensions/color.dart';
import 'package:typled_editor/map/components/components.dart';

class TypledGame extends FlameGame {
  TypledGame({
    required String basePath,
    required String filePath,
    (int, int)? relativeGridPosition,
  })  : _basePath = basePath,
        _filePath = filePath,
        _relativeGridPosition = relativeGridPosition;

  final String _basePath;
  final String _filePath;
  final (int, int)? _relativeGridPosition;

  late final File _file;
  AtlasProvider? loadedAtlas;
  Typled? loadedTypled;

  late final StreamSubscription<FileSystemEvent> _subscription;
  StreamSubscription<FileSystemEvent>? _atlasSubscription;

  bool customCamera = false;
  final tileGrid = ValueNotifier(false);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    assets.prefix = '';

    _file = File(path.join(_basePath, _filePath));

    camera.viewfinder.anchor = Anchor.topLeft;

    _subscription = _file.watch().listen((event) {
      _build();
    });

    tileGrid.addListener(_onTileGridChanged);
  }

  @override
  void onAttach() {
    super.onAttach();

    _build();
  }

  @override
  void onRemove() {
    super.onRemove();

    _subscription.cancel();
    _atlasSubscription?.cancel();
    tileGrid.removeListener(_onTileGridChanged);
  }

  void _onTileGridChanged() {
    _build();
  }

  Future<void> _build() async {
    final errors = <String>{};
    try {
      final fileContent = await _file.readAsString();
      final currentTypled = Typled.parse(fileContent);

      for (final child in world.children) {
        child.removeFromParent();
      }

      final atlasPath = path.join(_basePath, currentTypled.atlas);
      final atlasFile = File(atlasPath);
      final currentAtlas = await AtlasProvider.load(
        file: atlasFile,
        basePath: _basePath,
      );

      if (currentTypled.backgroundColor != null) {
        try {
          final mapBackgroundColor = currentTypled.backgroundColor!.toColor();
          world.add(
            RectangleComponent(
              size: Vector2(
                currentTypled.width.toDouble() * currentAtlas.tileWidth,
                currentTypled.height.toDouble() * currentAtlas.tileHeight,
              ),
              paint: Paint()..color = mapBackgroundColor,
            ),
          );
        } catch (e) {
          errors.add(e.toString());
        }
      }

      _atlasSubscription ??= atlasFile.watch().listen((event) {
        _build();
      });

      for (final layer in currentTypled.layers) {
        for (var y = 0; y < layer.length; y++) {
          final row = layer[y];
          for (var x = 0; x < row.length; x++) {
            final position = Vector2(
              x.toDouble() * currentAtlas.tileWidth,
              y.toDouble() * currentAtlas.tileHeight,
            );

            final entry = row[x];
            final spriteId = currentTypled.palette[entry];
            if (spriteId == null) {
              throw Exception('Sprite ID not found for palette ID: ${row[x]}');
            }
            if (spriteId == 'EMPTY') {
              continue;
            }
            try {
              final sprite = currentAtlas.getSprite(spriteId);
              world.add(
                SpriteComponent(
                  position: position,
                  size: sprite.srcSize,
                  sprite: sprite,
                ),
              );
            } catch (e) {
              errors.add(e.toString());
            }
          }
        }
      }

      // Thid is triggering twice
      if (tileGrid.value) {
        final color =
            _relativeGridPosition == null ? Colors.white : Colors.grey;
        for (var y = 0; y < currentTypled.height; y++) {
          for (var x = 0; x < currentTypled.width; x++) {
            final labelX = x + (_relativeGridPosition?.$1 ?? 0);
            final labelY = y + (_relativeGridPosition?.$2 ?? 0);
            world.add(
              RectangleComponent(
                priority: 100,
                size: Vector2(
                  currentAtlas.tileWidth.toDouble(),
                  currentAtlas.tileHeight.toDouble(),
                ),
                position: Vector2(
                  x.toDouble() * currentAtlas.tileWidth,
                  y.toDouble() * currentAtlas.tileHeight,
                ),
                paint: Paint()
                  ..color = color
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 0,
                children: [
                  GameText(
                    position: Vector2.all(2),
                    text: '$labelX-$labelY',
                    color: color,
                    fontSize: 2,
                  ),
                ],
              ),
            );
          }
        }
      }

      loadedAtlas = currentAtlas;
      loadedTypled = currentTypled;

      setCamera();
    } catch (e) {
      errors.add(e.toString());
    }

    for (final error in errors) {
      NesScaffoldMessenger.of(buildContext!).showSnackBar(
        NesSnackbar(type: NesSnackbarType.error, text: error),
        alignment: Alignment.topRight,
      );
    }
  }

  Vector2? _lastSize;
  @override
  void onGameResize(Vector2 size) {
    if (_lastSize == size) {
      return;
    }

    _lastSize = size.clone();
    super.onGameResize(size);

    setCamera();
  }

  void setCamera() {
    if (customCamera) {
      return;
    }

    final currentAtlas = loadedAtlas;
    final currentTypled = loadedTypled;
    if (currentTypled == null || currentAtlas == null) {
      return;
    }

    // Set the zoom based on the size of the map and the canvas
    final xScale = size.x / (currentTypled.width * currentAtlas.tileWidth);
    final yScale = size.y / (currentTypled.height * currentAtlas.tileHeight);

    final scale = math.min(xScale, yScale);

    camera.viewfinder.zoom = scale;
    camera.viewfinder.position = Vector2.zero();
  }
}
