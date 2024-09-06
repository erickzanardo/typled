// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:nes_ui/nes_ui.dart';
import 'package:typled/typled.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.length != 2) {
    print('Usage: main.dart <basePath> <file>');
    return;
  }

  final basePath = args[0];
  final file = args[1];

  runApp(
    MaterialApp(
      theme: flutterNesTheme(brightness: Brightness.dark),
      home: TypledApp(
        basePath: basePath,
        file: file,
      ),
    ),
  );
}

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
  }

  Future<void> _build() async {
    try {
      final fileContent = await _file.readAsString();
      final currentTypled = Typled.parse(fileContent);

      for (final child in world.children) {
        child.removeFromParent();
      }

      final currentAtlas = await FireAtlas.loadAsset(
        path.join(_basePath, currentTypled.atlas),
        assets: assets,
      );

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

class TypledApp extends StatefulWidget {
  const TypledApp({required this.basePath, required this.file, super.key});

  final String basePath;
  final String file;

  @override
  State<TypledApp> createState() => _TypledAppState();
}

class _TypledAppState extends State<TypledApp> {
  late final TypledGame _game;

  @override
  void initState() {
    super.initState();

    _game = TypledGame(
      basePath: widget.basePath,
      filePath: widget.file,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Typled',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'File: ${widget.file}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Base Path: ${widget.basePath}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: GameWidget(game: _game),
          ),
        ],
      ),
    );
  }
}
