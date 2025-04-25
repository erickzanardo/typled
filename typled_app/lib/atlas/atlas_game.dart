import 'dart:async';
import 'dart:io';

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

    world.add(
      atlasImage = SpriteComponent(
        sprite: Sprite(atlasProvider.image),
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
}
