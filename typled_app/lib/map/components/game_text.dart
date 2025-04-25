import 'dart:ui';

import 'package:flame/components.dart';
import 'package:google_fonts/google_fonts.dart';

class GameText extends TextComponent with HasPaint {
  GameText({
    this.fontSize = 8,
    Color color = const Color(0xffffffff),
    super.position,
    super.text,
    super.anchor,
    super.children,
  }) : super(
          textRenderer: TextPaint(
            style: GoogleFonts.pressStart2p(fontSize: fontSize, color: color),
          ),
        ) {
    paint = Paint()..color = color;
    _lastColor = color;
  }

  final double fontSize;
  late Color _lastColor;

  @override
  void update(double dt) {
    super.update(dt);

    if (_lastColor != paint.color) {
      textRenderer = TextPaint(
        style: GoogleFonts.pressStart2p(fontSize: fontSize, color: paint.color),
      );
      _lastColor = paint.color;
    }
  }

  Vector2 get textSize {
    final metrics = textRenderer.getLineMetrics(text);

    return Vector2(metrics.width, metrics.height);
  }
}
