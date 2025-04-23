import 'package:test/test.dart';
import 'package:typled/typled.dart';

void main() {
  group('Typled', () {
    group('parse', () {
      test('can parse Typled object', () {
        const rawTypled = '''
[map]
name = 1 - 1
width = 20
height = 12
atlas = game.fa
backgroundColor = #FFFFFF

[metadata]
author = John Doe
description = This is a test map.

[palette]
_ = EMPTY

B = bot
D = door
K = key

1 = gem_1
2 = gem_2

a = ground_bottom_1
b = ground_bottom_1

c = ground_bottom_left
d = ground_bottom_right

e = ground_right_wall_1
f = ground_right_wall_2

g = ground_left_wall_1
h = ground_left_wall_2

i = ground_ceiling_1
j = ground_ceiling_2

k = ground_top_right
l = ground_top_left

m = ground_full_block

[layer]
lijijijijijijijijijk
gmmm_______________f
hmm________________e
gm_________________f
h__________________e
g___1__1__1_______1f
hK__m__m__m__1____1e
gmmm_________m____mf
h_____1_________mmme
g____1m1_____11____f
hB__1mmm1____mm___De
cbababababababababad
''';

        final typled = Typled.parse(rawTypled);

        expect(typled.name, '1 - 1');
        expect(typled.width, 20);
        expect(typled.height, 12);
        expect(typled.atlas, 'game.fa');
        expect(typled.backgroundColor, '#FFFFFF');

        // Verify the palette items
        expect(typled.palette, {
          '_': 'EMPTY',
          'B': 'bot',
          'D': 'door',
          'K': 'key',
          '1': 'gem_1',
          '2': 'gem_2',
          'a': 'ground_bottom_1',
          'b': 'ground_bottom_1',
          'c': 'ground_bottom_left',
          'd': 'ground_bottom_right',
          'e': 'ground_right_wall_1',
          'f': 'ground_right_wall_2',
          'g': 'ground_left_wall_1',
          'h': 'ground_left_wall_2',
          'i': 'ground_ceiling_1',
          'j': 'ground_ceiling_2',
          'k': 'ground_top_right',
          'l': 'ground_top_left',
          'm': 'ground_full_block',
        });

        expect(typled.metadata, {
          'author': 'John Doe',
          'description': 'This is a test map.',
        });

        // Verify the layers
        expect(typled.layers, [
          [
            'lijijijijijijijijijk'.split(''),
            'gmmm_______________f'.split(''),
            'hmm________________e'.split(''),
            'gm_________________f'.split(''),
            'h__________________e'.split(''),
            'g___1__1__1_______1f'.split(''),
            'hK__m__m__m__1____1e'.split(''),
            'gmmm_________m____mf'.split(''),
            'h_____1_________mmme'.split(''),
            'g____1m1_____11____f'.split(''),
            'hB__1mmm1____mm___De'.split(''),
            'cbababababababababad'.split(''),
          ],
        ]);
      });

      group('when the string has no metadata', () {
        test('can parse Typled object', () {
          const rawTypled = '''
[map]
name = 1 - 1
width = 20
height = 12
atlas = game.fa
backgroundColor = #FFFFFF

[palette]
_ = EMPTY

B = bot
D = door
K = key

1 = gem_1
2 = gem_2

a = ground_bottom_1
b = ground_bottom_1

c = ground_bottom_left
d = ground_bottom_right

e = ground_right_wall_1
f = ground_right_wall_2

g = ground_left_wall_1
h = ground_left_wall_2

i = ground_ceiling_1
j = ground_ceiling_2

k = ground_top_right
l = ground_top_left

m = ground_full_block

[layer]
lijijijijijijijijijk
gmmm_______________f
hmm________________e
gm_________________f
h__________________e
g___1__1__1_______1f
hK__m__m__m__1____1e
gmmm_________m____mf
h_____1_________mmme
g____1m1_____11____f
hB__1mmm1____mm___De
cbababababababababad
''';

          final typled = Typled.parse(rawTypled);

          expect(typled.name, '1 - 1');
          expect(typled.width, 20);
          expect(typled.height, 12);
          expect(typled.atlas, 'game.fa');
          expect(typled.backgroundColor, '#FFFFFF');

          // Verify the palette items
          expect(typled.palette, {
            '_': 'EMPTY',
            'B': 'bot',
            'D': 'door',
            'K': 'key',
            '1': 'gem_1',
            '2': 'gem_2',
            'a': 'ground_bottom_1',
            'b': 'ground_bottom_1',
            'c': 'ground_bottom_left',
            'd': 'ground_bottom_right',
            'e': 'ground_right_wall_1',
            'f': 'ground_right_wall_2',
            'g': 'ground_left_wall_1',
            'h': 'ground_left_wall_2',
            'i': 'ground_ceiling_1',
            'j': 'ground_ceiling_2',
            'k': 'ground_top_right',
            'l': 'ground_top_left',
            'm': 'ground_full_block',
          });

          expect(typled.metadata, {});

          // Verify the layers
          expect(typled.layers, [
            [
              'lijijijijijijijijijk'.split(''),
              'gmmm_______________f'.split(''),
              'hmm________________e'.split(''),
              'gm_________________f'.split(''),
              'h__________________e'.split(''),
              'g___1__1__1_______1f'.split(''),
              'hK__m__m__m__1____1e'.split(''),
              'gmmm_________m____mf'.split(''),
              'h_____1_________mmme'.split(''),
              'g____1m1_____11____f'.split(''),
              'hB__1mmm1____mm___De'.split(''),
              'cbababababababababad'.split(''),
            ],
          ]);
        });
      });
    });
  });
}
