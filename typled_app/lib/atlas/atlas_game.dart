import 'dart:async';
import 'dart:io';

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:typled/typled.dart';
import 'package:typled_editor/atlas/cubit/atlas_cubit.dart';
import 'package:typled_editor/atlas_provider.dart';

class AtlasGame extends FlameGame {
  AtlasGame({
    required this.basePath,
    required this.file,
  });

  final String basePath;
  final String file;

  late TypledAtlasProvider atlasProvider;
  late TypledAtlas loadedAtlas;

  late SpriteComponent atlasImage;

  late RectangleComponent recticle;

  final cubit = AtlasCubit();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final atlasFile = File(path.join(basePath, file));
    atlasProvider = (await AtlasProvider.load(
      file: atlasFile,
      basePath: basePath,
    )) as TypledAtlasProvider;

    final rawAtlas = await atlasFile.readAsString();
    loadedAtlas = TypledAtlas.parse(rawAtlas);

    camera = CameraComponent.withFixedResolution(
      width: atlasProvider.image.width.toDouble(),
      height: atlasProvider.image.height.toDouble(),
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    add(
      FlameBlocListener<AtlasCubit, AtlasState>(
        bloc: cubit,
        onNewState: (state) {
          if (state.selectedSpriteId != '') {
            final spriteData = loadedAtlas.sprites[state.selectedSpriteId];
            if (spriteData != null) {
              setReticleFromSpriteData(spriteData);
            }
          } else if (state.customSelection.$1 != -1) {
            setReticleFromSpriteData(state.customSelection);
          } else {
            recticle.paint = Paint();
          }
        },
      ),
    );

    world.add(
      atlasImage = SpriteComponent(
        sprite: Sprite(atlasProvider.image),
      ),
    );

    world.add(
      recticle = RectangleComponent(
        priority: 10,
      ),
    );

    cubit.setSprites(
      loadedAtlas.sprites.entries
          .map(
            (e) => e.key,
          )
          .toList(),
    );
  }

  void setReticleFromSpriteData((int, int, int?, int?) spriteData) {
    recticle
      ..size = Vector2(
        ((spriteData.$3 ?? 1) * loadedAtlas.tileSize).toDouble(),
        ((spriteData.$4 ?? 1) * loadedAtlas.tileSize).toDouble(),
      )
      ..position = Vector2(
        (spriteData.$1 * loadedAtlas.tileSize).toDouble(),
        (spriteData.$2 * loadedAtlas.tileSize).toDouble(),
      );

    recticle.paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
  }
}
