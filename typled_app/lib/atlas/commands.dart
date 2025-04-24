import 'package:typled_editor/atlas/cubit/atlas_cubit.dart';
import 'package:typled_editor/prompt/prompt_command.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';

abstract class AtlasCommand extends Command<(AtlasCubit, WorkspaceCubit)> {
  const AtlasCommand({
    required super.command,
    required super.description,
    required super.usage,
  });

  static List<AtlasCommand> commands = [];
}
