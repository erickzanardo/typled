import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typled/typled.dart';
import 'package:typled_editor/extensions/extensions.dart';
import 'package:typled_editor/grid/commands.dart';
import 'package:typled_editor/grid/cubit/grid_cubit.dart';
import 'package:typled_editor/map/map.dart';
import 'package:typled_editor/prompt/command_prompt.dart';
import 'package:typled_editor/widgets/help_dialog.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';

class TypledGridView extends StatefulWidget {
  const TypledGridView({super.key, required this.basePath, required this.file});

  final String basePath;
  final String file;

  @override
  State<TypledGridView> createState() => _TypledGridState();
}

class _TypledGridState extends State<TypledGridView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GridCubit>(
      create: (context) {
        final cubit = GridCubit();
        cubit.load(widget.basePath, widget.file);
        return cubit;
      },
      child: BlocBuilder<GridCubit, GridState>(
        builder: (context, state) {
          final grid = state.grid;

          if (grid == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final totalWidth = grid.gridWidth * grid.cellWidth;
                    final totalHeight = grid.gridHeight * grid.cellHeight;

                    final scale = math.min(
                      constraints.maxWidth / totalWidth,
                      constraints.maxHeight / totalHeight,
                    );

                    return Stack(
                      children: [
                        for (final cell in grid.cells.entries)
                          _MapView(
                            basePath: widget.basePath,
                            file: widget.file,
                            cell: cell,
                            scale: scale,
                            grid: grid,
                          ),
                      ],
                    );
                  },
                ),
              ),
              CommandPrompt(
                commands: GridCommand.commands,
                onSubmitCommand: (command, args) {
                  command.execute((
                    context.read<GridCubit>(),
                    context.read<WorkspaceCubit>(),
                  ), args);
                },
                onShowHelp: (context) {
                  HelpDialog.show(context, commands: GridCommand.commands);
                },
                basePath: widget.basePath.homeReplaced,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  final String basePath;
  final String file;
  final MapEntry<(int, int), String> cell;
  final double scale;
  final TypledGrid grid;

  const _MapView({
    required this.basePath,
    required this.file,
    required this.cell,
    required this.scale,
    required this.grid,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GridCubit>();
    final state = cubit.state;

    return Positioned(
      left: (cell.key.$1 * grid.cellWidth).toDouble() * scale,
      top: (cell.key.$2 * grid.cellHeight).toDouble() * scale,
      width: grid.cellWidth.toDouble() * scale,
      height: grid.cellHeight.toDouble() * scale,
      child: Stack(
        children: [
          TypledMapView(
            key: ValueKey(cell.value),
            showInfo: false,
            basePath: basePath,
            file: cell.value,
            relativeGridPosition: (
              cell.key.$1 * grid.cellWidth,
              cell.key.$2 * grid.cellHeight,
            ),
            parentGridEnabled: cubit.stream.map((state) => state.gridEnabled),
          ),
          if (state.gridEnabled) ...[
            Positioned(
              top: 0,
              left: 0,
              width: grid.cellWidth.toDouble() * scale,
              height: grid.cellHeight.toDouble() * scale,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 4,
              child: Text(
                '${cell.key.$1}, ${cell.key.$2}: ${cell.value}',
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
