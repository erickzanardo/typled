import 'dart:io';

enum _ReadingState { none, map, palette, layers }

class Typled {
  Typled({
    required this.name,
    required this.width,
    required this.height,
    required this.atlas,
    required this.palette,
    required this.layers,
  });

  final String name;
  final int width;
  final int height;
  final String atlas;
  final Map<String, String> palette;
  final List<List<List<String>>> layers;

  factory Typled.parse(String content)  {
    final lines = content.split(Platform.lineTerminator);

    void throwError(String line, String expected) {
      throw Exception('Unknown token at line ${lines.indexOf(line)} $line');
    }

    late final String name;
    late final int width;
    late final int height;
    late final String atlas;
    final palette = <String, String>{};
    final layers = <List<List<String>>>[];

    var state = _ReadingState.none;
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) {
        continue;
      }

      switch (state) {
        case _ReadingState.none:
          if (trimmedLine == '[map]') {
            state = _ReadingState.map;
          } else {
            throwError(line, '[map]');
          }
        case _ReadingState.map:
          if (trimmedLine == '[palette]') {
            state = _ReadingState.palette;
          } else if (line.startsWith('name')) {
            name = line.split('=')[1].trim();
          } else if (line.startsWith('width')) {
            width = int.parse(line.split('=')[1].trim());
          } else if (line.startsWith('height')) {
            height = int.parse(line.split('=')[1].trim());
          } else if (line.startsWith('atlas')) {
            atlas = line.split('=')[1].trim();
          } else {
            throwError(line, '[palette]|name|width|height|atlas');
          }
        case _ReadingState.palette:
          if (trimmedLine == '[layer]') {
            state = _ReadingState.layers;
            layers.add([]);
          } else if (trimmedLine.isNotEmpty) {
            final parts = line.split('=');
            if (parts.length != 2) {
              throwError(line, 'key=value');
            }
            final key = parts[0].trim();
            final value = parts[1].trim();
            if (key.isEmpty || value.isEmpty) {
              throwError(line, 'key=value');
            }
            palette[key] = value;
          } else {
            throwError(line, '[layer]|key=value');
          }
        case _ReadingState.layers:
          if (trimmedLine.startsWith('[layer]')) {
            layers.add([]);
          } else {
            final layer = layers.last;
            layer.add(line.split(''));
          }
      }
    }

    return Typled(
      name: name,
      width: width,
      height: height,
      atlas: atlas,
      palette: palette,
      layers: layers,
    );
  }
}
