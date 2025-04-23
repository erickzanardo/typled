import 'package:typled_editor/grid/cubit/grid_cubit.dart';
import 'package:typled_editor/prompt/prompt_command.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';

abstract class GridCommand extends Command<(GridCubit, WorkspaceCubit)> {
  const GridCommand({
    required super.command,
    required super.description,
    required super.usage,
  });

  static List<GridCommand> commands = [
    const TileGridCommand(),
    const OpenMapCommand(),
  ];
}

class TileGridCommand extends GridCommand {
  const TileGridCommand()
    : super(
        command: 'grid',
        description: 'Toggles the tile grid.',
        usage: 'grid',
      );

  @override
  void execute((GridCubit, WorkspaceCubit) subject, List<String> args) {
    subject.$1.toggleGrid();
  }
}

class OpenMapCommand extends GridCommand {
  const OpenMapCommand()
    : super(
        command: 'open',
        description: 'Opens the map.',
        usage: 'open cellX cellY',
      );

  @override
  void execute((GridCubit, WorkspaceCubit) subject, List<String> args) {
    final x = int.tryParse(args[0]);
    final y = int.tryParse(args[1]);

    if (x != null && y != null) {
      final filePath = subject.$1.cellPath(x, y);
      if (filePath != null) {
        subject.$2.openFile(
          FileEntry(
            file: filePath,
            basePath: subject.$2.state.currentFile!.basePath,
          ),
        );
      }
    }
  }
}
