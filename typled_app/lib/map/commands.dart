import 'dart:io';

import 'package:flame/game.dart';
import 'package:typled_editor/map/cubit/map_cubit.dart';
import 'package:typled_editor/map/typled_game.dart';

abstract class Command {
  const Command({
    required this.command,
    required this.description,
    required this.usage,
  });

  static final List<Command> commands = [
    const ZoomCommand(),
    const ResetCameraCommand(),
    const PanCameraCommand(),
    const MoveCommand(),
    const PaletteCommand(),
    const ExitCommand(),
  ];

  final String command;
  final String description;
  final String usage;

  void execute(TypledGame game, MapCubit cubit, List<String> args);
}

class ZoomCommand extends Command {
  const ZoomCommand()
      : super(
          command: 'zoom',
          description: 'Zooms the camera to the specified level.',
          usage: 'zoom <level>',
        );

  @override
  void execute(TypledGame game, MapCubit cubit, List<String> args) {
    if (args.isEmpty) {
      return;
    }

    final zoom = double.tryParse(args.first);

    if (zoom != null) {
      game.customCamera = true;
      game.camera.viewfinder.zoom = zoom;
    }
  }
}

class ResetCameraCommand extends Command {
  const ResetCameraCommand()
      : super(
          command: 'reset_camera',
          description: 'Resets the camera to the default position.',
          usage: 'reset_camera',
        );

  @override
  void execute(TypledGame game, MapCubit cubit, List<String> args) {
    game.customCamera = false;
    game.setCamera();
  }
}

class PanCameraCommand extends Command {
  const PanCameraCommand()
      : super(
          command: 'pan',
          description: 'Pans the camera with the specified values.',
          usage: 'pan <x> <y>',
        );

  @override
  void execute(TypledGame game, MapCubit cubit, List<String> args) {
    final atlas = game.loadedAtlas;
    if (args.length != 2 || atlas == null) {
      return;
    }

    final x = double.tryParse(args[0]);
    final y = double.tryParse(args[1]);

    if (x != null && y != null) {
      game.customCamera = true;
      game.camera.viewfinder.position += Vector2(
        x * atlas.tileWidth,
        y * atlas.tileHeight,
      );
    }
  }
}

class MoveCommand extends Command {
  const MoveCommand()
      : super(
          command: 'move',
          description: 'Moves the camera to the specified position.',
          usage: 'move <x> <y>',
        );

  @override
  void execute(TypledGame game, MapCubit cubit, List<String> args) {
    final atlas = game.loadedAtlas;
    if (args.length != 2 || atlas == null) {
      return;
    }

    final x = double.tryParse(args[0]);
    final y = double.tryParse(args[1]);

    if (x != null && y != null) {
      game.customCamera = true;
      game.camera.viewfinder.position = Vector2(
        x * atlas.tileWidth,
        y * atlas.tileHeight,
      );
    }
  }
}

class PaletteCommand extends Command {
  const PaletteCommand()
      : super(
          command: 'palette',
          description: 'Toggles the palette.',
          usage: 'palette',
        );

  @override
  void execute(TypledGame game, MapCubit cubit, List<String> args) {
    cubit.togglePalette();
  }
}

class ExitCommand extends Command {
  const ExitCommand()
      : super(
          command: 'q',
          description: 'Exits the editor.',
          usage: 'q',
        );

  @override
  void execute(TypledGame game, MapCubit cubit, List<String> args) {
    exit(0);
  }
}
