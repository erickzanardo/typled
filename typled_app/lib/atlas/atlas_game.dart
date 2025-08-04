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

  late final File atlasFile;

  late TypledAtlasProvider atlasProvider;
  late TypledAtlas loadedAtlas;

  late SpriteComponent atlasImage;

  late RectangleComponent recticle;

  final cubit = AtlasCubit();

  late final StreamSubscription<FileSystemEvent> _fileWatcher;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    atlasFile = File(path.join(basePath, file));

    await loadAtlas();

    build();

    _fileWatcher = atlasFile.watch().listen((event) async {
      if (event.type == FileSystemEvent.modify) {
        await loadAtlas();
        build();
      }
    });

    add(
      FlameBlocListener<AtlasCubit, AtlasState>(
        listenWhen: (previous, current) =>
            previous.hitboxeMode != current.hitboxeMode,
        bloc: cubit,
        onNewState: (state) {
          build();
        },
      ),
    );
  }

  Future<void> loadAtlas() async {
    atlasProvider = (await AtlasProvider.load(
      file: atlasFile,
      basePath: basePath,
    )) as TypledAtlasProvider;

    final rawAtlas = await atlasFile.readAsString();
    loadedAtlas = TypledAtlas.parse(rawAtlas);
  }

  void build() {
    for (final child in world.children) {
      child.removeFromParent();
    }

    if (cubit.state.hitboxeMode) {
      world.add(
        FlameBlocListener<AtlasCubit, AtlasState>(
          listenWhen: (previous, current) =>
              previous.selectedSelectionId != current.selectedSelectionId,
          bloc: cubit,
          onNewState: (state) {
            build();
          },
        ),
      );

      final spriteData = loadedAtlas.sprites[cubit.state.selectedSelectionId];
      if (spriteData != null) {
        final spriteSize = Vector2(
          (spriteData.$3 ?? 1) * loadedAtlas.tileSize.toDouble(),
          (spriteData.$4 ?? 1) * loadedAtlas.tileSize.toDouble(),
        );
        world.add(
          SpriteComponent(
            sprite: Sprite(
              atlasProvider.image,
              srcPosition: Vector2(
                (spriteData.$1 * loadedAtlas.tileSize).toDouble(),
                (spriteData.$2 * loadedAtlas.tileSize).toDouble(),
              ),
              srcSize: spriteSize,
            ),
          ),
        );

        camera = CameraComponent.withFixedResolution(
          width: spriteSize.x,
          height: spriteSize.y,
        );

        camera.viewfinder.anchor = Anchor.topLeft;
      }

      world.add(
        recticle = RectangleComponent(
          priority: 10,
        ),
      );
      final state = cubit.state;
      if (state.customSelection.$1 != -1) {
        setReticleFromSpriteData(state.customSelection);
      } else if (state.selectedSelectionId != '') {
        final hitboxData = loadedAtlas.hitboxes?[state.selectedSelectionId];
        if (hitboxData != null) {
          setReticleFromSpriteData(hitboxData);
        }
      } else {
        recticle.paint = Paint();
      }

      cubit.setSelections(
        (loadedAtlas.hitboxes ?? {})
            .entries
            .map(
              (e) => e.key,
            )
            .toList(),
      );
    } else {
      camera = CameraComponent.withFixedResolution(
        width: atlasProvider.image.width.toDouble(),
        height: atlasProvider.image.height.toDouble(),
      );

      camera.viewfinder.anchor = Anchor.topLeft;

      world.add(
        FlameBlocListener<AtlasCubit, AtlasState>(
          bloc: cubit,
          onNewState: (state) {
            if (state.customSelection.$1 != -1) {
              setReticleFromSpriteData(state.customSelection);
            } else if (state.selectedSelectionId != '') {
              final spriteData = loadedAtlas.sprites[state.selectedSelectionId];
              if (spriteData != null) {
                setReticleFromSpriteData(spriteData);
              }
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

      cubit.setSelections(
        loadedAtlas.sprites.entries
            .map(
              (e) => e.key,
            )
            .toList(),
      );
    }
  }

  void setReticleFromSpriteData((int, int, int?, int?) spriteData) {
    final modifier = cubit.state.hitboxeMode ? 1 : loadedAtlas.tileSize;
    recticle
      ..size = Vector2(
        ((spriteData.$3 ?? 1) * modifier).toDouble(),
        ((spriteData.$4 ?? 1) * modifier).toDouble(),
      )
      ..position = Vector2(
        (spriteData.$1 * modifier).toDouble(),
        (spriteData.$2 * modifier).toDouble(),
      );

    recticle.paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = cubit.state.hitboxeMode ? 0 : 1;
  }

  @override
  void onRemove() {
    super.onRemove();

    _fileWatcher.cancel();
  }
}
