import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/extensions/extensions.dart';
import 'package:typled_editor/map/commands.dart';
import 'package:typled_editor/map/cubit/map_cubit.dart';
import 'package:typled_editor/map/typled_game.dart';
import 'package:typled_editor/prompt/command_prompt.dart';
import 'package:typled_editor/widgets/help_dialog.dart';
import 'package:typled_editor/workspace/cubit/workspace_cubit.dart';

class TypledMapView extends StatefulWidget {
  const TypledMapView({
    required this.basePath,
    required this.file,
    this.showInfo = true,
    this.relativeGridPosition,
    this.parentGridEnabled,
    super.key,
  });

  final String basePath;
  final String file;
  final bool showInfo;
  final (int, int)? relativeGridPosition;
  final Stream<bool>? parentGridEnabled;

  @override
  State<TypledMapView> createState() => _TypledMapViewState();
}

class _TypledMapViewState extends State<TypledMapView> {
  late final TypledGame _game;
  StreamSubscription<bool>? _parentGridSubscription;

  @override
  void initState() {
    super.initState();

    _game = TypledGame(
      basePath: widget.basePath,
      filePath: widget.file,
      relativeGridPosition: widget.relativeGridPosition,
    );

    _parentGridSubscription = widget.parentGridEnabled?.listen((enabled) {
      if (_game.tileGrid.value != enabled) {
        _game.tileGrid.value = enabled;
      }
    });
  }

  @override
  void dispose() {
    _parentGridSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showInfo) {
      return GameWidget(game: _game, autofocus: false);
    }
    return BlocProvider(
      create: (context) => MapCubit(),
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: GameWidget(game: _game, autofocus: false)),
                    if (state.showPalette && _game.loadedTypled != null)
                      SizedBox(
                        width: 240,
                        height: double.infinity,
                        child: NesSingleChildScrollView(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Wrap(
                              children: [
                                for (var item
                                    in _game.loadedTypled!.palette.entries)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: NesContainer(
                                      width: 80,
                                      height: 80,
                                      padding: const EdgeInsets.all(8),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: item.value == 'EMPTY'
                                                ? const Text('EMPTY')
                                                : SpriteWidget(
                                                    sprite: _game.loadedAtlas!
                                                        .getSprite(
                                                      item.value,
                                                    ),
                                                  ),
                                          ),
                                          Text(item.key),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              CommandPrompt(
                commands: MapCommand.commands,
                onSubmitCommand: (command, args) {
                  final mapCubit = context.read<MapCubit>();
                  final workspaceCubit = context.read<WorkspaceCubit>();
                  command.execute((mapCubit, _game, workspaceCubit), args);
                },
                onShowHelp: (context) {
                  HelpDialog.show(context, commands: MapCommand.commands);
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
