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
