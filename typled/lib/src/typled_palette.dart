class TypledPalette {
  TypledPalette({
    required this.atlas,
    required this.palette,
  });

  factory TypledPalette.parse(String content) {
    final lines = content.split('\n');

    String? atlas;
    final palette = <String, String>{};

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) {
        continue;
      }

      if (trimmedLine.startsWith('_typled_atlas')) {
        atlas = trimmedLine.split('=')[1].trim();
      } else if (trimmedLine.contains('=')) {
        final parts = trimmedLine.split('=');
        if (parts.length == 2) {
          palette[parts[0].trim()] = parts[1].trim();
        } else {
          throw Exception('Invalid palette entry: $trimmedLine');
        }
      } else {
        throw Exception('Unknown token: $trimmedLine');
      }
    }

    return TypledPalette(atlas: atlas, palette: palette);
  }

  final String? atlas;
  final Map<String, String> palette;
}
