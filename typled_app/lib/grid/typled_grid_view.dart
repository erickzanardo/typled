import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled/typled.dart';
import 'package:path/path.dart' as path;
import 'package:typled_editor/extensions/extensions.dart';
import 'package:typled_editor/grid/commands.dart';
import 'package:typled_editor/grid/cubit/grid_cubit.dart';
import 'package:typled_editor/map/map.dart';
import 'package:typled_editor/prompt/command_prompt.dart';
import 'package:typled_editor/widgets/help_dialog.dart';

class TypledGridView extends StatefulWidget {
  const TypledGridView({
    required this.basePath,
    required this.file,
    super.key,
  });

  final String basePath;
  final String file;

  @override
  State<TypledGridView> createState() => _TypledGridState();
}

class _TypledGridState extends State<TypledGridView> {
  late Future<TypledGrid> _typledGrid;

  @override
  void initState() {
    super.initState();

    _typledGrid = _loadTypledGrid();

    File(path.join(widget.basePath, widget.file)).watch().listen((event) {
      setState(() {
        _typledGrid = _loadTypledGrid();
      });
    });
  }

  Future<TypledGrid> _loadTypledGrid() async {
    final file = File(path.join(widget.basePath, widget.file));
    final fileContent = await file.readAsString();
    return TypledGrid.parse(fileContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NesScaffold(
        body: BlocProvider<GridCubit>(
          create: (context) => GridCubit(),
          child: BlocBuilder<GridCubit, GridState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: _typledGrid,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final typledGrid = snapshot.data as TypledGrid;

                          return LayoutBuilder(builder: (context, constraints) {
                            final totalWidth =
                                typledGrid.gridWidth * typledGrid.cellWidth;
                            final totalHeight =
                                typledGrid.gridHeight * typledGrid.cellHeight;

                            final scale = math.min(
                              constraints.maxWidth / totalWidth,
                              constraints.maxHeight / totalHeight,
                            );

                            final state = context.watch<GridCubit>().state;

                            return Stack(
                              children: [
                                for (final cell in typledGrid.cells.entries)
                                  Builder(builder: (context) {
                                    final view = TypledMapView(
                                      showInfo: false,
                                      basePath: widget.basePath,
                                      file: cell.value,
                                    );

                                    return Positioned(
                                      left: (cell.key.$1 * typledGrid.cellWidth)
                                              .toDouble() *
                                          scale,
                                      top: (cell.key.$2 * typledGrid.cellHeight)
                                              .toDouble() *
                                          scale,
                                      width: typledGrid.cellWidth.toDouble() *
                                          scale,
                                      height: typledGrid.cellHeight.toDouble() *
                                          scale,
                                      child: state.gridEnabled
                                          ? Stack(
                                              children: [
                                                view,
                                                Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  width: typledGrid.cellWidth
                                                          .toDouble() *
                                                      scale,
                                                  height: typledGrid.cellHeight
                                                          .toDouble() *
                                                      scale,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 4,
                                                  left: 4,
                                                  child: Text(
                                                    '${cell.key.$1}, ${cell.key.$2}: ${cell.value}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : view,
                                    );
                                  })
                              ],
                            );
                          });
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  CommandPrompt(
                    commands: GridCommand.commands,
                    onSubmitCommand: (command, args) {
                      command.execute(context.read<GridCubit>(), args);
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
        ),
      ),
    );
  }
}
