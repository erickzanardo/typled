import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/extensions/extensions.dart';
import 'package:typled_editor/map/cubit/map_cubit.dart';
import 'package:typled_editor/map/typled_game.dart';
import 'package:typled_editor/widgets/help_dialog.dart';

class TypledMapView extends StatefulWidget {
  const TypledMapView(
      {required this.basePath,
      required this.file,
      this.showInfo = true,
      super.key});

  final String basePath;
  final String file;
  final bool showInfo;

  @override
  State<TypledMapView> createState() => _TypledMapViewState();
}

class _TypledMapViewState extends State<TypledMapView> {
  late final TypledGame _game;

  @override
  void initState() {
    super.initState();

    _game = TypledGame(
      basePath: widget.basePath,
      filePath: widget.file,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showInfo) {
      return GameWidget(game: _game);
    }
    final smallFontStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 12,
        );
    const padding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
    return BlocProvider(
      create: (context) => MapCubit(),
      child: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GameWidget(
                        game: _game,
                        autofocus: false,
                      ),
                    ),
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
              Focus(
                autofocus: true,
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent) {
                    if (state.commandMode) {
                      if (event.logicalKey == LogicalKeyboardKey.enter) {
                        final result =
                            context.read<MapCubit>().submitCommand(_game);
                        if (result == SubmitCommandResult.notFound) {
                          NesScaffoldMessenger.of(context).showSnackBar(
                            alignment: Alignment.topRight,
                            const NesSnackbar(
                              type: NesSnackbarType.error,
                              text: 'Unknown command',
                            ),
                          );
                        } else if (result == SubmitCommandResult.help) {
                          HelpDialog.show(context);
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowUp) {
                        context.read<MapCubit>().searchHistoryUp();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowDown) {
                        context.read<MapCubit>().searchHistoryDown();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.backspace) {
                        context.read<MapCubit>().commandBackspace();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.escape) {
                        context.read<MapCubit>().exitCommandMode();
                      } else if (event.logicalKey == LogicalKeyboardKey.colon) {
                        // ignore
                      } else {
                        context
                            .read<MapCubit>()
                            .typeCommand(event.character ?? '');
                      }
                    } else if (event.logicalKey == LogicalKeyboardKey.colon &&
                        !state.commandMode) {
                      context.read<MapCubit>().enterCommandMode();
                    }
                  }
                  return KeyEventResult.handled;
                },
                child: state.commandMode
                    ? ColoredBox(
                        color: Colors.blue[900]!,
                        child: Padding(
                          padding: padding,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              ':${state.command}',
                              style: smallFontStyle,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: ColoredBox(
                              color: Colors.blue,
                              child: Padding(
                                padding: padding,
                                child: Text(
                                  widget.basePath.homeReplaced,
                                  style: smallFontStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ColoredBox(
                              color: Colors.green,
                              child: Padding(
                                padding: padding,
                                child: Text(
                                  widget.file,
                                  style: smallFontStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
