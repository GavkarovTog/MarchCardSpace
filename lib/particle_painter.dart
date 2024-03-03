import 'package:another_march_card/particles_system.dart';
import 'package:flutter/material.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles) : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = (Colors.white);

    for (Particle particle in particles) {
      canvas.drawCircle(Offset(particle.x * size.width, particle.y * size.height), size.width * 0.001, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}