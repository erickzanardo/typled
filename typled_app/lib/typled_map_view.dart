import 'dart:math' as math;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled_editor/commands.dart';
import 'package:typled_editor/typled_game.dart';

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
  String _command = '';
  bool _commandMode = false;
  List<String> _commandHistory = [];
  int _commandHistoryIndex = 0;

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
    return Column(
      children: [
        Expanded(
          child: GameWidget(
            game: _game,
            autofocus: false,
          ),
        ),
        Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (_commandMode) {
                if (event.logicalKey == LogicalKeyboardKey.enter) {
                  final parts = _command.split(' ');

                  if (parts.isNotEmpty) {
                    final command = parts.first;
                    final args = parts.sublist(1);

                    final foundCommands = Command.commands.where(
                      (element) => element.command == command,
                    );

                    if (foundCommands.isEmpty) {
                      NesScaffoldMessenger.of(context).showSnackBar(
                        alignment: Alignment.topRight,
                        const NesSnackbar(
                          type: NesSnackbarType.error,
                          text: 'Unknown command',
                        ),
                      );
                    } else {
                      _commandHistory.add(_command);
                      final foundCommand = foundCommands.first;
                      foundCommand.execute(_game, args);
                    }
                  }

                  setState(() {
                    _commandMode = false;
                    _commandHistoryIndex = _commandHistory.length;
                    _command = '';
                  });
                } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  if (_commandHistoryIndex > 0) {
                    setState(() {
                      _commandHistoryIndex--;
                      _command = _commandHistory[_commandHistoryIndex];
                    });
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  if (_commandHistoryIndex < _commandHistory.length - 1) {
                    setState(() {
                      _commandHistoryIndex++;
                      _command = _commandHistory[_commandHistoryIndex];
                    });
                  }
                } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
                  setState(() {
                    _command = _command.substring(
                      0,
                      math.max(0, _command.length - 1),
                    );
                  });
                } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                  setState(() {
                    _command = '';
                    _commandMode = false;
                  });
                } else if (event.logicalKey == LogicalKeyboardKey.colon) {
                  // ignore
                } else {
                  setState(() {
                    _command += event.character ?? '';
                  });
                }
              } else if (event.logicalKey == LogicalKeyboardKey.colon &&
                  !_commandMode) {
                setState(() {
                  _commandMode = true;
                });
              }
            }
            return KeyEventResult.handled;
          },
          child: _commandMode
              ? ColoredBox(
                  color: Colors.blue[900]!,
                  child: Padding(
                    padding: padding,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        ':$_command',
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
                            widget.basePath,
                            style: smallFontStyle,
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
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ],
    );
  }
}
