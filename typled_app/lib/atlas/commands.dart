import 'package:typled_editor/atlas/atlas_game.dart';
import 'package:typled_editor/atlas/cubit/atlas_cubit.dart';
import 'package:typled_editor/prompt/prompt_command.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';

abstract class AtlasCommand
    extends Command<(AtlasGame, AtlasCubit, WorkspaceCubit)> {
  const AtlasCommand({
    required super.command,
    required super.description,
    required super.usage,
  });

  static List<AtlasCommand> commands = [
    const SelectSpriteCommand(),
    const CustomSelectionCommand(),
    const HitboxMode(),
    const SpritesMode(),
  ];
}

class SelectSpriteCommand extends AtlasCommand {
  const SelectSpriteCommand()
      : super(
          command: 'select',
          description: 'Select a sprite',
          usage: 'select <spriteId>',
        );

  @override
  execute((AtlasGame, AtlasCubit, WorkspaceCubit) context, List<String> args) {
    final cubit = context.$2;

    final spriteId = args.first.trim();
    if (spriteId.isEmpty) {
      cubit.clearSelectedSelectionId();
      return;
    }

    cubit.setSelectedSelectionId(spriteId);
  }
}

class CustomSelectionCommand extends AtlasCommand {
  const CustomSelectionCommand()
      : super(
          command: 'custom',
          description: 'Set a custom selection',
          usage: 'custom <x> <y> [<width> <height>]',
        );

  @override
  execute((AtlasGame, AtlasCubit, WorkspaceCubit) context, List<String> args) {
    final cubit = context.$2;

    if (args.length < 2) {
      cubit.clearCustomSelection();
      return;
    }

    final x = int.tryParse(args[0]);
    final y = int.tryParse(args[1]);
    final width = args.length > 2 ? int.tryParse(args[2]) : null;
    final height = args.length > 3 ? int.tryParse(args[3]) : null;

    if (x == null || y == null) {
      cubit.clearCustomSelection();
      return;
    }

    cubit.setCustomSelection(x, y, width, height);
  }
}

class HitboxMode extends AtlasCommand {
  const HitboxMode()
      : super(
          command: 'hitbox',
          description: 'Set the editor in the hitbox mode',
          usage: 'hitbox',
        );

  @override
  execute((AtlasGame, AtlasCubit, WorkspaceCubit) context, List<String> args) {
    final cubit = context.$2;

    cubit.setHitboxMode();
  }
}

class SpritesMode extends AtlasCommand {
  const SpritesMode()
      : super(
          command: 'sprites',
          description: 'Set the editor in the sprites mode',
          usage: 'sprites',
        );

  @override
  execute((AtlasGame, AtlasCubit, WorkspaceCubit) context, List<String> args) {
    final cubit = context.$2;

    cubit.setSpritesMode();
  }
}
