import 'dart:io';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_fire_atlas/flame_fire_atlas.dart';
import 'package:typled/typled.dart';

import 'package:path/path.dart' as path;

abstract class AtlasProvider {
  static Future<AtlasProvider> load({
    required File file,
    required String basePath,
  }) async {
    if (file.path.endsWith('typled_atlas')) {
      final atlasContent = await file.readAsString();
      final atlas = TypledAtlas.parse(atlasContent);
      final image = await Images(
        prefix: '',
      ).load(path.join(basePath, atlas.imagePath));
      return TypledAtlasProvider(image, atlas);
    } else {
      final atlasBytes = await file.readAsBytes();
      final currentAtlas = FireAtlas.deserializeBytes(atlasBytes);
      await currentAtlas.loadImage(images: Images());

      return FireAtlasProvider(currentAtlas);
    }
  }

  double get tileWidth;
  double get tileHeight;
  Sprite getSprite(String spriteId);
}

class FireAtlasProvider extends AtlasProvider {
  final FireAtlas _atlas;

  FireAtlasProvider(this._atlas);

  @override
  double get tileWidth => _atlas.tileWidth;

  @override
  double get tileHeight => _atlas.tileHeight;

  @override
  Sprite getSprite(String spriteId) {
    return _atlas.getSprite(spriteId);
  }
}

class TypledAtlasProvider extends AtlasProvider {
  TypledAtlasProvider(this.image, this.atlas);

  final Image image;
  final TypledAtlas atlas;

  @override
  Sprite getSprite(String spriteId) {
    final selection = atlas.sprites[spriteId];

    if (selection == null) {
      throw Exception('Sprite ID not found for palette ID: $spriteId');
    }

    final w =
        selection.$3 == null ? atlas.tileSize : selection.$3! * atlas.tileSize;

    final h =
        selection.$4 == null ? atlas.tileSize : selection.$4! * atlas.tileSize;

    final srcPosition = Vector2(
      selection.$1.toDouble() * atlas.tileSize,
      selection.$2.toDouble() * atlas.tileSize,
    );

    final srcSize = Vector2(w.toDouble(), h.toDouble());

    return Sprite(image, srcPosition: srcPosition, srcSize: srcSize);
  }

  @override
  double get tileHeight => atlas.tileSize.toDouble();

  @override
  double get tileWidth => atlas.tileSize.toDouble();
}
