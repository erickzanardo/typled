import 'package:flame/game.dart';
import 'package:typled_editor/atlas_provider.dart';
import 'package:typled_editor/map/cubit/map_cubit.dart';
import 'package:typled_editor/map/typled_game.dart';
import 'package:typled_editor/prompt/prompt_command.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';

abstract class MapCommand
    extends Command<(MapCubit, TypledGame, WorkspaceCubit)> {
  const MapCommand({
    required super.command,
    required super.description,
    required super.usage,
  });

  static const List<MapCommand> commands = [
    ZoomCommand(),
    ResetCameraCommand(),
    PanCameraCommand(),
    MoveCommand(),
    PaletteCommand(),
    TileGridCommand(),
    AtlasCommand(),
  ];
}

class ZoomCommand extends MapCommand {
  const ZoomCommand()
      : super(
          command: 'zoom',
          description: 'Zooms the camera to the specified level.',
          usage: 'zoom <level>',
        );

  @override
  void execute(
      (MapCubit cubit, TypledGame game, WorkspaceCubit workspaceCubit) subject,
      List<String> args) {
    if (args.isEmpty) {
      return;
    }

    final zoom = double.tryParse(args.first);

    if (zoom != null) {
      subject.$2.customCamera = true;
      subject.$2.camera.viewfinder.zoom = zoom;
    }
  }
}

class ResetCameraCommand extends MapCommand {
  const ResetCameraCommand()
      : super(
          command: 'reset_camera',
          description: 'Resets the camera to the default position.',
          usage: 'reset_camera',
        );

  @override
  void execute(
      (MapCubit cubit, TypledGame game, WorkspaceCubit workspaceCubit) subject,
      List<String> args) {
    subject.$2.customCamera = false;
    subject.$2.setCamera();
  }
}

class PanCameraCommand extends MapCommand {
  const PanCameraCommand()
      : super(
          command: 'pan',
          description: 'Pans the camera with the specified values.',
          usage: 'pan <x> <y>',
        );

  @override
  void execute(
      (MapCubit cubit, TypledGame game, WorkspaceCubit workspaceCubit) subject,
      List<String> args) {
    final atlas = subject.$2.loadedAtlas;
    if (args.length != 2 || atlas == null) {
      return;
    }

    final x = double.tryParse(args[0]);
    final y = double.tryParse(args[1]);

    if (x != null && y != null) {
      subject.$2.customCamera = true;
      subject.$2.camera.viewfinder.position += Vector2(
        x * atlas.tileWidth,
        y * atlas.tileHeight,
      );
    }
  }
}

class MoveCommand extends MapCommand {
  const MoveCommand()
      : super(
          command: 'move',
          description: 'Moves the camera to the specified position.',
          usage: 'move <x> <y>',
        );

  @override
  void execute(
      (MapCubit cubit, TypledGame game, WorkspaceCubit workspaceCubit) subject,
      List<String> args) {
    final atlas = subject.$2.loadedAtlas;
    if (args.length != 2 || atlas == null) {
      return;
    }

    final x = double.tryParse(args[0]);
    final y = double.tryParse(args[1]);

    if (x != null && y != null) {
      subject.$2.customCamera = true;
      subject.$2.camera.viewfinder.position = Vector2(
        x * atlas.tileWidth,
        y * atlas.tileHeight,
      );
    }
  }
}

class PaletteCommand extends MapCommand {
  const PaletteCommand()
      : super(
          command: 'palette',
          description: 'Toggles the palette.',
          usage: 'palette',
        );

  @override
  void execute(
      (MapCubit cubit, TypledGame game, WorkspaceCubit workspaceCubit) subject,
      List<String> args) {
    subject.$1.togglePalette();
  }
}

class TileGridCommand extends MapCommand {
  const TileGridCommand()
      : super(
          command: 'grid',
          description: 'Toggles the tile grid.',
          usage: 'grid',
        );

  @override
  void execute(
      (MapCubit cubit, TypledGame game, WorkspaceCubit workspaceCubit) subject,
      List<String> args) {
    subject.$2.tileGrid.value = !subject.$2.tileGrid.value;
  }
}

class AtlasCommand extends MapCommand {
  const AtlasCommand()
      : super(
          command: 'atlas',
          description:
              'Opens the atlas file of this map (only works for typled atlas).',
          usage: 'atlas',
        );

  @override
  void execute(
      (MapCubit, TypledGame, WorkspaceCubit) subject, List<String> args) {
    final atlas = subject.$2.loadedAtlas;
    if (atlas == null) {
      return;
    }

    final map = subject.$2.loadedTypled;

    if (map == null) {
      return;
    }

    if (atlas is! TypledAtlasProvider) {
      return;
    }

    final path = map.atlas;
    subject.$3.openFile(
      FileEntry(
        file: path,
        basePath: subject.$2.basePath,
      ),
    );
  }
}
