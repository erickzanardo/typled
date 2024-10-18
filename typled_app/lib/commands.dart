import 'package:flame/game.dart';
import 'package:typled_editor/typled_game.dart';

abstract class Command {
  const Command({
    required this.command,
  });

  static final List<Command> commands = [
    const ZoomCommand(),
    const ResetCameraCommand(),
    const PanCameraCommand(),
    const MoveCommand(),
  ];

  final String command;

  void execute(TypledGame game, List<String> args);
}

class ZoomCommand extends Command {
  const ZoomCommand() : super(command: 'zoom');

  @override
  void execute(TypledGame game, List<String> args) {
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
  const ResetCameraCommand() : super(command: 'reset_camera');

  @override
  void execute(TypledGame game, List<String> args) {
    game.customCamera = false;
    game.setCamera();
  }
}

class PanCameraCommand extends Command {
  const PanCameraCommand() : super(command: 'pan');

  @override
  void execute(TypledGame game, List<String> args) {
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
  const MoveCommand() : super(command: 'move');

  @override
  void execute(TypledGame game, List<String> args) {
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
      print(game.camera.viewfinder.position);
    }
  }
}
