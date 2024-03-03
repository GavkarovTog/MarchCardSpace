import 'package:another_march_card/animation_utils.dart';
import 'package:another_march_card/particle_painter.dart';
import 'package:another_march_card/particles_system.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ParticleManager particleManager = ParticleManager(70);
  late final AnimationController controller;

  @override
  void initState() {
    AnimationControllerFactory factory = AnimationControllerFactory(this);
    controller = factory.createController(const Duration(seconds: 1), toRepeat: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            particleManager.update();

            return Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: CustomPaint(
                size: Size.infinite,
                foregroundPainter: ParticlePainter(particleManager.particles),
              ),
            );
          }
        ),
      )
    );
  }
}
