import 'package:flutter/material.dart';

class ConfigIllustration extends StatelessWidget {
  final double size;

  const ConfigIllustration({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ConfigIllustrationPainter(),
      ),
    );
  }
}

class _ConfigIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background card with rounded corners
    final bgRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.10, w * 0.70, h * 0.80),
      const Radius.circular(24),
    );
    final bgPaint = Paint()..color = const Color(0xFFD3EAFB);
    final borderPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(bgRRect, bgPaint);
    canvas.drawRRect(bgRRect, borderPaint);

    // Left Gear Badge (Yellow)
    final gearRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.12, w * 0.38, h * 0.36),
      const Radius.circular(16),
    );
    canvas.drawRRect(gearRRect, Paint()..color = const Color(0xFFFDE99D));
    canvas.drawRRect(gearRRect, borderPaint);

    // Gear Icon in the yellow box
    final gearCenter = Offset(w * 0.31, h * 0.30);
    final gearPaint = Paint()
      ..color = const Color(0xFFBCAAA4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(gearCenter, w * 0.10, gearPaint);
    canvas.drawCircle(gearCenter, w * 0.04, Paint()..color = const Color(0xFFFDE99D));

    // Two Toggle Switches on the right
    // Top Switch
    final switch1RRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.44, h * 0.18, w * 0.38, h * 0.15),
      const Radius.circular(18),
    );
    canvas.drawRRect(switch1RRect, Paint()..color = const Color(0xFFFF5252));
    canvas.drawRRect(switch1RRect, borderPaint);
    // Switch knob 1
    final knob1 = Offset(w * 0.53, h * 0.255);
    canvas.drawCircle(knob1, w * 0.065, Paint()..color = const Color(0xFFFFCDD2));
    canvas.drawCircle(knob1, w * 0.065, borderPaint);

    // Bottom Switch
    final switch2RRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.44, h * 0.38, w * 0.38, h * 0.15),
      const Radius.circular(18),
    );
    canvas.drawRRect(switch2RRect, Paint()..color = const Color(0xFFFF5252));
    canvas.drawRRect(switch2RRect, borderPaint);
    // Switch knob 2
    final knob2 = Offset(w * 0.73, h * 0.455);
    canvas.drawCircle(knob2, w * 0.065, Paint()..color = const Color(0xFFFFCDD2));
    canvas.drawCircle(knob2, w * 0.065, borderPaint);

    // Arm & Hand pressing the top toggle
    // Blue striped sleeve
    final sleevePath = Path();
    sleevePath.moveTo(w * 0.20, h * 0.88);
    sleevePath.lineTo(w * 0.32, h * 0.65);
    sleevePath.lineTo(w * 0.48, h * 0.72);
    sleevePath.lineTo(w * 0.44, h * 0.90);
    sleevePath.close();

    final sleevePaint = Paint()..color = const Color(0xFF2979FF);
    canvas.drawPath(sleevePath, sleevePaint);
    canvas.drawPath(sleevePath, borderPaint);

    // Hand (Brown skin tone)
    final handPaint = Paint()..color = const Color(0xFF6D4C41);
    final handPath = Path();
    handPath.moveTo(w * 0.34, h * 0.64);
    handPath.lineTo(w * 0.48, h * 0.32); // Index finger pointing up to switch 1
    handPath.lineTo(w * 0.54, h * 0.32);
    handPath.lineTo(w * 0.54, h * 0.50);
    handPath.lineTo(w * 0.57, h * 0.52);
    handPath.lineTo(w * 0.53, h * 0.70);
    handPath.lineTo(w * 0.40, h * 0.72);
    handPath.close();

    canvas.drawPath(handPath, handPaint);
    canvas.drawPath(handPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
