import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:path/path.dart' as path;
import 'package:typled/typled.dart';

class TypledGame extends FlameGame {
  TypledGame({required String basePath, required String filePath})
      : _basePath = basePath,
        _filePath = filePath;

  final String _basePath;
  final String _filePath;

  late final File _file;
  FireAtlas? _currentAtlas;
  Typled? _currentTypled;

  late final StreamSubscription<FileSystemEvent> _subscription;
  StreamSubscription<FileSystemEvent>? _atlasSubscription;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    assets.prefix = '';

    _file = File(path.join(_basePath, _filePath));

    camera.viewfinder.anchor = Anchor.center;

    _subscription = _file.watch().listen((event) {
      _build();
    });

    await _build();
  }

  @override
  void onRemove() {
    super.onRemove();

    _subscription.cancel();
    _atlasSubscription?.cancel();
  }

  Future<void> _build() async {
    try {
      final fileContent = await _file.readAsString();
      final currentTypled = Typled.parse(fileContent);

      for (final child in world.children) {
        child.removeFromParent();
      }

      final atlasPath = path.join(_basePath, currentTypled.atlas);
      final atlasFile = File(atlasPath);
      final atlasBytes = await atlasFile.readAsBytes();
      final currentAtlas = FireAtlas.deserializeBytes(atlasBytes);
      await currentAtlas.loadImage(images: Images());

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
            final sprite = currentAtlas.getSprite(spriteId);
            world.add(
              SpriteComponent(
                position: position,
                size: sprite.srcSize,
                sprite: sprite,
              ),
            );
          }
        }
      }

      _currentAtlas = currentAtlas;
      _currentTypled = currentTypled;

      _setCamera();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    _setCamera();
  }

  void _setCamera() {
    final currentAtlas = _currentAtlas;
    final currentTypled = _currentTypled;
    if (currentTypled == null || currentAtlas == null) {
      return;
    }

    // Set the zoom based on the size of the map and the canvas
    final xScale = size.x / (currentTypled.width * currentAtlas.tileWidth);
    final yScale = size.y / (currentTypled.height * currentAtlas.tileHeight);

    final scale = math.min(xScale, yScale);

    camera.viewfinder.zoom = scale;
    camera.viewfinder.position = Vector2(
      currentTypled.width * currentAtlas.tileWidth / 2,
      currentTypled.height * currentAtlas.tileHeight / 2,
    );
  }
}
