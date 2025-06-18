# Typled

Typled is a simple grid map tool, which uses plain text to represent the map.

This package parses the text content and converts it to objects that can be used
from withing the dart code.

## Example of usage

A single room can be parsed out like this
```dart
final map = Typled.parse('''
[map]
name = My Map
width = 10
height = 10
atlas = atlas.fa
backgroundColor = #000000

[palette]
_ = EMPTY
X = block
D = door

[layer]
XXXXX
X___D
XXXXX
```

Maps can also use external palette files, in order to do so, you can use the following syntax:

```dart
[palette]
_ = EMPTY
X = block
D = door
...relative/path/to/palette.typled_palette
```

When loading a map with external palettes, you must have the palette file loaded first and
pass them to the `Typled.parse` method as the `externalPalettes` parameter:

```dart
final externalPalettes = <String, TypledPalette>{...};
final map = Typled.parse(
  rawContent,
  externalPalettes: externalPalettes,
);
```

External palettes are simple files where the palette entries are defined just like they are in a map, but directly in the file content.

```dart
A = sprite_1
B = sprite_2
C = sprite_3
```

Additionally, a speciel entry named `_typled_atlas` can be define to inform the
editor what is the atlas file to be used for this palette, so you can preview
all the entries in the editor.

A grid of rooms would be something like the following:

````dart
const rawContent = '''
1,1
20,12
0, 0: levels/1/1.typled
''';

final grid = TypledGrid.parse(rawContent);
```

An atlas file would look like this:

```dart
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
