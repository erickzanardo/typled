import 'dart:io';

enum _ReadingState { none, atlas, sprites }

class TypledAtlas {
  TypledAtlas({
    required this.imagePath,
    required this.tileSize,
    required this.sprites,
  });

  final String imagePath;
  final int tileSize;
  final Map<String, (int, int, int?, int?)> sprites;

  factory TypledAtlas.parse(String content) {
    final lines = content.split(Platform.lineTerminator);

    void throwError(String line, String expected) {
      throw Exception('Unknown token at line ${lines.indexOf(line)} $line');
    }

    late final String imagePath;
    late final int tileSize;
    final Map<String, (int, int, int?, int?)> sprites = {};

    var state = _ReadingState.none;
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) {
        continue;
      }

      switch (state) {
        case _ReadingState.none:
          if (trimmedLine == '[atlas]') {
            state = _ReadingState.atlas;
          } else {
            throwError(line, '[atlas]');
          }
        case _ReadingState.atlas:
          if (trimmedLine == '[sprites]') {
            state = _ReadingState.sprites;
          } else if (line.startsWith('imagePath')) {
            imagePath = line.split('=')[1].trim();
          } else if (line.startsWith('tileSize')) {
            tileSize = int.parse(line.split('=')[1].trim());
          } else {
            throwError(line, '[sprites]|imagePath|tileSize]');
          }
        case _ReadingState.sprites:
          if (trimmedLine.isNotEmpty) {
            final parts = line.split('=');
            if (parts.length != 2) {
              throwError(line, 'key=value');
            }
            final key = parts[0].trim();
            final value = parts[1].trim();
            if (key.isEmpty || value.isEmpty) {
              throwError(line, 'key=x,y,w?,h?');
            }
            final coords = value.split(',');
            if (!const [2, 3, 4].contains(coords.length)) {
              throwError(line, 'key=x,y,w?,h?');
            }
            final x = int.tryParse(coords[0]);
            final y = int.tryParse(coords[1]);
            final w = coords.length > 2 ? int.tryParse(coords[2]) : null;
            final h = coords.length > 3 ? int.tryParse(coords[3]) : null;

            if (x == null ||
                y == null ||
                (coords.length >= 3 && w == null) ||
                (coords.length >= 4 && h == null)) {
              throwError(line, 'key=x,y,w?,h?');
            }

            if (sprites.containsKey(key)) {
              throw Exception(
                'Duplicated key $key with values ($value, ${sprites[key]})',
              );
            }
            sprites[key] = (x!, y!, w, h);
          } else {
            throwError(line, '[layer]|key=value');
          }
      }
    }

    return TypledAtlas(
      imagePath: imagePath,
      tileSize: tileSize,
      sprites: sprites,
    );
  }
}
