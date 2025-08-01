class TypledGrid {
  TypledGrid({
    required this.gridWidth,
    required this.gridHeight,
    required this.cellWidth,
    required this.cellHeight,
    required this.cells,
  });

  final int gridWidth;
  final int gridHeight;

  final int cellWidth;
  final int cellHeight;

  final Map<(int, int), String> cells;

  factory TypledGrid.parse(
    String content, {
    String lineTerminator = '\n',
  }) {
    final lines = content.split(lineTerminator);

    late final int gridWidth;
    late final int gridHeight;
    late final int cellWidth;
    late final int cellHeight;
    final cells = <(int, int), String>{};

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) {
        continue;
      }

      if (i == 0) {
        final parts = line.split(',');
        gridWidth = int.parse(parts[0]);
        gridHeight = int.parse(parts[1]);
      } else if (i == 1) {
        final parts = line.split(',');
        cellWidth = int.parse(parts[0]);
        cellHeight = int.parse(parts[1]);
      } else {
        final parts = line.split(':');
        final coords = parts[0].split(',');
        final path = parts[1].trim();
        final x = int.parse(coords[0]);
        final y = int.parse(coords[1]);
        cells[(x, y)] = path;
      }
    }

    return TypledGrid(
      gridWidth: gridWidth,
      gridHeight: gridHeight,
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      cells: cells,
    );
  }
}
