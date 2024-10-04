import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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
    return Column(
      children: [
        Expanded(
          child: GameWidget(game: _game),
        ),
        Row(
          children: [
            Expanded(
              child: ColoredBox(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    widget.file,
                    style: smallFontStyle,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
