import 'package:another_march_card/particle_painter.dart';
import 'package:another_march_card/particles_system.dart';
import 'package:flutter/material.dart';

class AnimatedSpaceBackground extends AnimatedWidget {
  final AnimationController controller;
  late final ParticleManager particleManager;

  AnimatedSpaceBackground({super.key, required this.controller}) : super(listenable: controller) {
    particleManager = ParticleManager(
        controller: controller,
        colors: [
          Colors.white,
          Colors.greenAccent.shade100,
          Colors.lightBlueAccent.shade100,
          Colors.red.shade100
        ],
        opacityRange: PInterval(begin: 0.1, end: 1.0),
        sizeRange: PInterval(begin: 1, end: 5),
        velocityRange: PInterval(begin: 0.005, end: 0.01),
        fading: true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (! particleManager.inited) {
          const baseDeviceArea = 289618.5123966942;
          // pixel 3 -> 500
          // another - x

          final countOfParticles = 500 * constraints.maxWidth * constraints.maxHeight
              ~/ baseDeviceArea;

          particleManager.initParticles(countOfParticles);
        }

        return Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: CustomPaint(
            size: Size.infinite,
            foregroundPainter: ParticlePainter(
                particleManager.particles),
          ),);
      },
    );
  }
}
