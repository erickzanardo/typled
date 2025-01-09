import 'package:typled/typled.dart';
import 'package:test/test.dart';

void main() {
  group('TypledGrid', () {
    test('parses a raw strung', () {
      const rawContent = '''
1,1
20,12
0, 0: areas/cave/levels/1/1.typled
''';

      final grid = TypledGrid.parse(rawContent);
      expect(grid.gridWidth, 1);
      expect(grid.gridHeight, 1);
      expect(grid.cellWidth, 20);
      expect(grid.cellHeight, 12);

      // Assert cells
      expect(grid.cells[(0, 0)], 'areas/cave/levels/1/1.typled');
    });
  });
}
