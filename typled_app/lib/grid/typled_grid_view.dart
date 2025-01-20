import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:typled/typled.dart';
import 'package:path/path.dart' as path;
import 'package:typled_editor/map/map.dart';

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
        body: FutureBuilder(
          future: _typledGrid,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final typledGrid = snapshot.data as TypledGrid;

              return LayoutBuilder(builder: (context, constraints) {
                final totalWidth = typledGrid.gridWidth * typledGrid.cellWidth;
                final totalHeight =
                    typledGrid.gridHeight * typledGrid.cellHeight;

                final scale = math.min(
                  constraints.maxWidth / totalWidth,
                  constraints.maxHeight / totalHeight,
                );

                return Stack(
                  children: [
                    for (final cell in typledGrid.cells.entries)
                      Positioned(
                        left: (cell.key.$1 * typledGrid.cellWidth).toDouble() *
                            scale,
                        top: (cell.key.$2 * typledGrid.cellHeight).toDouble() *
                            scale,
                        width: typledGrid.cellWidth.toDouble() * scale,
                        height: typledGrid.cellHeight.toDouble() * scale,
                        child: TypledMapView(
                          showInfo: false,
                          basePath: widget.basePath,
                          file: cell.value,
                        ),
                      )
                  ],
                );
              });
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
