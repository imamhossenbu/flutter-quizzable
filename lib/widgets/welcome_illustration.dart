import 'package:flutter/material.dart';

class WelcomeIllustration extends StatelessWidget {
  final double size;

  const WelcomeIllustration({super.key, this.size = 280});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WelcomeIllustrationPainter(),
      ),
    );
  }
}

class _WelcomeIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Giant Curved Yellow Question Mark in Background
    final yellowPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(w * 0.25, h * 0.70);
    path.cubicTo(
      w * 0.40, h * 0.45,
      w * 0.55, h * 0.35,
      w * 0.58, h * 0.28,
    );
    path.cubicTo(
      w * 0.65, h * 0.15,
      w * 0.48, h * 0.05,
      w * 0.35, h * 0.12,
    );
    canvas.drawPath(path, yellowPaint);

    // Decorative floating pink bubble with stripes
    final bubblePaint = Paint()..color = const Color(0xFFFF6584);
    canvas.drawCircle(Offset(w * 0.20, h * 0.35), w * 0.10, bubblePaint);

    final stripePaint = Paint()
      ..color = const Color(0xFF00C853)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.14, h * 0.36),
      Offset(w * 0.26, h * 0.30),
      stripePaint,
    );
    canvas.drawLine(
      Offset(w * 0.15, h * 0.39),
      Offset(w * 0.26, h * 0.38),
      stripePaint,
    );

    // Coral question mark on the right
    final coralPaint = Paint()
      ..color = const Color(0xFFFF5252).withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;

    final coralPath = Path();
    coralPath.moveTo(w * 0.88, h * 0.48);
    coralPath.cubicTo(
      w * 0.95, h * 0.42,
      w * 0.85, h * 0.38,
      w * 0.80, h * 0.43,
    );
    coralPath.cubicTo(
      w * 0.78, h * 0.48,
      w * 0.85, h * 0.55,
      w * 0.82, h * 0.63,
    );
    canvas.drawPath(coralPath, coralPaint);
    canvas.drawCircle(
      Offset(w * 0.82, h * 0.71),
      w * 0.04,
      Paint()..color = const Color(0xFFFF5252).withOpacity(0.85),
    );

    // Green question mark at bottom right
    final greenPaint = Paint()
      ..color = const Color(0xFF4CAF50).withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round;

    final greenPath = Path();
    greenPath.moveTo(w * 0.88, h * 0.83);
    greenPath.cubicTo(
      w * 0.92, h * 0.89,
      w * 0.82, h * 0.93,
      w * 0.80, h * 0.83,
    );
    canvas.drawPath(greenPath, greenPaint);
    canvas.drawCircle(
      Offset(w * 0.77, h * 0.75),
      w * 0.03,
      Paint()..color = const Color(0xFF4CAF50).withOpacity(0.85),
    );

    // Yellow solid circle at bottom left
    final circlePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFEE58), Color(0xFFF57F17)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.24, h * 0.78), radius: w * 0.10));
    canvas.drawCircle(Offset(w * 0.24, h * 0.78), w * 0.10, circlePaint);

    // 2. The Curious Boy with Curly Purple Hair in Center
    final headCenter = Offset(w * 0.50, h * 0.58);
    final headRadius = w * 0.22;

    // Ears
    final earPaint = Paint()..color = const Color(0xFFFFCCBC);
    canvas.drawCircle(Offset(w * 0.35, h * 0.58), w * 0.05, earPaint);
    canvas.drawCircle(Offset(w * 0.67, h * 0.63), w * 0.05, earPaint);

    // Face / Head
    final skinPaint = Paint()..color = const Color(0xFFFFE0B2);
    canvas.drawCircle(headCenter, headRadius, skinPaint);

    // Rosy cheeks
    final cheekPaint = Paint()
      ..color = const Color(0xFFFF8A80).withOpacity(0.5);
    canvas.drawCircle(Offset(w * 0.39, h * 0.62), w * 0.045, cheekPaint);
    canvas.drawCircle(Offset(w * 0.53, h * 0.69), w * 0.045, cheekPaint);

    // Eyes looking up in wonder
    final eyePaint = Paint()..color = const Color(0xFF1A237E);
    canvas.drawCircle(Offset(w * 0.43, h * 0.57), w * 0.026, eyePaint);
    canvas.drawCircle(Offset(w * 0.54, h * 0.63), w * 0.026, eyePaint);

    // Eye catchlights
    final catchLight = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.44, h * 0.56), w * 0.009, catchLight);
    canvas.drawCircle(Offset(w * 0.55, h * 0.62), w * 0.009, catchLight);

    // Eyebrows (purple)
    final browPaint = Paint()
      ..color = const Color(0xFF673AB7)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.45, h * 0.52),
      Offset(w * 0.47, h * 0.55),
      browPaint,
    );
    canvas.drawLine(
      Offset(w * 0.54, h * 0.58),
      Offset(w * 0.56, h * 0.60),
      browPaint,
    );

    // Nose & Mouth
    final nosePaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.47, h * 0.63), 2.5, nosePaint);

    final mouthPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.45, h * 0.67),
      Offset(w * 0.48, h * 0.67),
      mouthPaint,
    );

    // 3. Curly Purple Hair on top
    final hairPaint = Paint()..color = const Color(0xFF7E57C2);
    final hairHighlights = Paint()..color = const Color(0xFF9575CD);

    final curls = [
      Offset(w * 0.50, h * 0.38),
      Offset(w * 0.42, h * 0.40),
      Offset(w * 0.58, h * 0.41),
      Offset(w * 0.38, h * 0.46),
      Offset(w * 0.64, h * 0.46),
      Offset(w * 0.39, h * 0.51),
      Offset(w * 0.68, h * 0.53),
      Offset(w * 0.70, h * 0.60),
      Offset(w * 0.46, h * 0.44),
      Offset(w * 0.54, h * 0.47),
    ];

    for (final curl in curls) {
      canvas.drawCircle(curl, w * 0.08, hairPaint);
      canvas.drawCircle(
        Offset(curl.dx - 2, curl.dy - 2),
        w * 0.065,
        hairHighlights,
      );
    }

    // Little motion dashes around
    final dashPaint = Paint()
      ..color = const Color(0xFF673AB7)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.28, h * 0.16),
      Offset(w * 0.30, h * 0.11),
      dashPaint,
    );
    canvas.drawLine(
      Offset(w * 0.27, h * 0.20),
      Offset(w * 0.29, h * 0.15),
      dashPaint,
    );

    final orangeDash = Paint()
      ..color = const Color(0xFFFF5722)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.56, h * 0.88),
      Offset(w * 0.64, h * 0.85),
      orangeDash,
    );
    canvas.drawLine(
      Offset(w * 0.58, h * 0.91),
      Offset(w * 0.63, h * 0.89),
      orangeDash,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
