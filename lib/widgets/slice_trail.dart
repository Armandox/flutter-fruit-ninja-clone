import 'package:flutter/material.dart';

class SliceTrail extends StatelessWidget {
  final List<Offset> points;

  const SliceTrail({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();

    return CustomPaint(
      painter: SliceTrailPainter(points: points),
      size: Size.infinite,
    );
  }
}

class SliceTrailPainter extends CustomPainter {
  final List<Offset> points;

  SliceTrailPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final shadowPath = Path();

    // Disegna il trail principale
    path.moveTo(points.first.dx, points.first.dy);
    shadowPath.moveTo(points.first.dx + 2, points.first.dy + 2);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      shadowPath.lineTo(points[i].dx + 2, points[i].dy + 2);
    }

    // Disegna l'ombra
    canvas.drawPath(shadowPath, shadowPaint);
    
    // Disegna il trail principale
    canvas.drawPath(path, paint);

    // Aggiungi effetti di particelle ai punti del trail
    for (int i = 0; i < points.length; i += 3) {
      if (i < points.length) {
        final point = points[i];
        final alpha = 1.0 - (i / points.length);
        
        final particlePaint = Paint()
          ..color = Colors.yellow.withOpacity(alpha * 0.8)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(point, 3 + alpha * 5, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 