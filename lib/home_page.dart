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
  late final ParticleManager particleManager;
  late final AnimationController controller;

  @override
  void initState() {
    AnimationControllerFactory factory = AnimationControllerFactory(this);
    controller = factory.createController(const Duration(seconds: 1), loopBack: true);

    particleManager = ParticleManager(
      controller: controller,
      colors: [Colors.white, Colors.greenAccent.shade100, Colors.lightBlueAccent.shade100, Colors.red.shade100],
      opacityRange: PInterval(begin: 0.1, end: 1.0),
      sizeRange: PInterval(begin: 1, end: 5),
      velocityRange: PInterval(begin: 0.005, end: 0.01),
      fading: true
    );

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
        ),
      )
    );
  }
}
