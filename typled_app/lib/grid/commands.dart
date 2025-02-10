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
          usage: 'open',
        );

  @override
  void execute((GridCubit, WorkspaceCubit) subject, List<String> args) {
    final x = double.tryParse(args[0]);
    final y = double.tryParse(args[1]);

    if (x != null && y != null) {
      subject.$2.openMap(x, y);
    }
  }
}