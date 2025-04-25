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
