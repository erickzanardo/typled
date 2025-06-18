import 'package:test/test.dart';
import 'package:typled/typled.dart';

void main() {
  final content = '''
_typled_atlas = example_atlas.typled_atlas
A = sprite_1
B = sprite_2
C = sprite_3
''';

  group('TypledPalette', () {
    test('can be parsed', () {
      final palette = TypledPalette.parse(content);
      expect(palette.atlas, 'example_atlas.png');
      expect(palette.palette, {
        'A': 'sprite_1',
        'B': 'sprite_2',
        'C': 'sprite_3',
      });
    });

    group('atlas can be null', () {
      final contentWithoutAtlas = '''
A = sprite_1
B = sprite_2
 ''';
      test('when atlas is not defined', () {
        final palette = TypledPalette.parse(contentWithoutAtlas);
        expect(palette.atlas, isNull);
        expect(palette.palette, {
          'A': 'sprite_1',
          'B': 'sprite_2',
        });
      });
    });
  });
}
