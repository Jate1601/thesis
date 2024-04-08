import 'package:flutter/material.dart';

class SpeechBubblePainter extends CustomPainter {
  final Color color;
  final bool isSender;

  SpeechBubblePainter({required this.color, required this.isSender});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create a path for a speech bubble with a pointy left edge
    Path path = Path();
    const double offset = 8; // Adjust this value to control the shift amount

    if (isSender) {
      // Sender's bubble: pointy edge on the left
      path.moveTo(0 - offset,
          size.height / 2); // Start from the pointy edge shifted left
      path.lineTo(size.width * 0.2 - offset, 0); // Top-left corner
      path.lineTo(size.width - offset, 0); // Top horizontal line
      path.lineTo(size.width - offset, size.height); // Right vertical line
      path.lineTo(
          size.width * 0.2 - offset, size.height); // Bottom horizontal line
      path.lineTo(0 - offset, size.height / 2); // Back to the pointy edge
    } else {
      // Receiver's bubble: pointy edge on the right
      path.moveTo(
          size.width * 0.8 + offset, 0); // Top-right corner before the point
      path.lineTo(0 + offset, 0); // Top horizontal line shifted right
      path.lineTo(0 + offset, size.height); // Left vertical line
      path.lineTo(
          size.width * 0.8 + offset, size.height); // Bottom horizontal line
      path.lineTo(
          size.width + offset, size.height / 2); // Pointy edge shifted right
      path.lineTo(size.width * 0.8 + offset, 0); // Back to the top-right corner
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
