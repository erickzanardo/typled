import 'package:typled_editor/grid/cubit/grid_cubit.dart';
import 'package:typled_editor/prompt/prompt_command.dart';

abstract class GridCommand extends Command<GridCubit> {
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
  void execute(GridCubit subject, List<String> args) {
    subject.toggleGrid();
  }
}
