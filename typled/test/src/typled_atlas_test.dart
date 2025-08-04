import 'package:test/test.dart';
import 'package:typled/typled.dart';

void main() {
  group('TypledAtlas', () {
    test('parses a raw string', () {
      const rawContent = '''
[atlas]
imagePath = assets/atlas.png
tileSize = 16

[sprites]
player = 0,0
sprite2 = 0,0,1
sprite3 = 0,0,1,2
''';

      final atlas = TypledAtlas.parse(rawContent);
      expect(atlas.imagePath, 'assets/atlas.png');
      expect(atlas.tileSize, 16);
      expect(atlas.sprites['player'], (0, 0, null, null));

      expect(atlas.sprites['sprite2'], (0, 0, 1, null));
      expect(atlas.sprites['sprite3'], (0, 0, 1, 2));
    });

    group('when hitboxes are specified', () {
      test('parses hitboxes correctly', () {
        const rawContent = '''
[atlas]
imagePath = assets/atlas.png
tileSize = 16

[sprites]
player = 0,0
sprite2 = 0,0,1
sprite3 = 0,0,1,2

[hitboxes]
player = 0,0
sprite2 = 0,0,1,1
sprite3 = 0,0,2,1
''';

        final atlas = TypledAtlas.parse(rawContent);
        expect(atlas.imagePath, 'assets/atlas.png');
        expect(atlas.tileSize, 16);
        expect(atlas.sprites['player'], (0, 0, null, null));
        expect(atlas.sprites['sprite2'], (0, 0, 1, null));
        expect(atlas.sprites['sprite3'], (0, 0, 1, 2));

        expect(atlas.hitboxes!['player'], (0, 0, null, null));
        expect(atlas.hitboxes!['sprite2'], (0, 0, 1, 1));
        expect(atlas.hitboxes!['sprite3'], (0, 0, 2, 1));
      });
    });
  });
}
