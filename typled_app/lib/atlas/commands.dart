import 'package:typled_editor/atlas/cubit/atlas_cubit.dart';
import 'package:typled_editor/prompt/prompt_command.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';

abstract class AtlasCommand extends Command<(AtlasCubit, WorkspaceCubit)> {
  const AtlasCommand({
    required super.command,
    required super.description,
    required super.usage,
  });

  static List<AtlasCommand> commands = [
    const SelectSpriteCommand(),
    const CustomSelectionCommand(),
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
  execute((AtlasCubit, WorkspaceCubit) context, List<String> args) {
    final cubit = context.$1;

    final spriteId = args.first.trim();
    if (spriteId.isEmpty) {
      cubit.clearSelectedSpriteId();
      return;
    }

    cubit.setSelectedSpriteId(spriteId);
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
  execute((AtlasCubit, WorkspaceCubit) context, List<String> args) {
    final cubit = context.$1;

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
