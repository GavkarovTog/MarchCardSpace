import 'dart:math';

import 'package:another_march_card/animation_utils.dart';
import 'package:flutter/cupertino.dart';

class AnimatedAsteroidsBackground extends StatefulWidget {
  const AnimatedAsteroidsBackground({super.key});

  @override
  State<AnimatedAsteroidsBackground> createState() => _AnimatedAsteroidsBackgroundState();
}

class _AnimatedAsteroidsBackgroundState extends State<AnimatedAsteroidsBackground> with TickerProviderStateMixin {
  late AnimationController normalRotation;
  late AnimationController fasterRotation;
  late AnimationController backwardNormalRotation;
  late AnimationController backwardFasterRotation;
  late AnimationController scaleNormal;

  @override
  void initState() {
    super.initState();
    AnimationControllerFactory factory = AnimationControllerFactory(this);

    normalRotation = factory.createController(const Duration(seconds: 5), toRepeat: true);
    fasterRotation = factory.createController(const Duration(seconds: 3), toRepeat: true);
    backwardNormalRotation = factory.createController(const Duration(seconds: 4), toRepeat: true, inReverse: true);
    backwardFasterRotation = factory.createController(const Duration(seconds: 3), toRepeat: true, inReverse: true);
    scaleNormal = factory.createController(const Duration(seconds: 2), loopBack: true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constraints) {
          AsteroidManager asteroidManager = AsteroidManager(
              constraints.maxWidth,
              constraints.maxHeight,
              min(constraints.maxWidth, constraints.maxHeight)
          );

          return AnimatedBuilder(
            animation: Listenable.merge([
              normalRotation
            ]),
            builder: (context, _) => Stack(
              children: [
                asteroidManager.createAsteroid(
                  widthAxis: 0.55,
                  heightAxis: 0.98,
                  type: AsteroidType.gray_moon,
                  beginScale: 0.2,
                  endScale: 0.25,
                  turns: fasterRotation,
                  scale: scaleNormal,
                ),

                asteroidManager.createAsteroid(
                    widthAxis: 0.95,
                    heightAxis: 0.76,
                    type: AsteroidType.desert_rock,
                    beginScale: 0.2,
                    endScale: 0.25,
                    turns: backwardFasterRotation,
                    scale: scaleNormal,
                ),

                asteroidManager.createAsteroid(
                    widthAxis: 0.22,
                    heightAxis: 0.86,
                    type: AsteroidType.gold_planet,
                    beginScale: 0.05,
                    endScale: 0.07,
                    turns: backwardFasterRotation,
                    scale: scaleNormal,
                    alignWidth: 0.5,
                    alignHeight: 0.2
                ),

                asteroidManager.createAsteroid(
                    widthAxis: 0.2,
                    heightAxis: 0.80,
                    type: AsteroidType.blue_fish,
                    beginScale: 0.1,
                    endScale: 0.1,
                    turns: normalRotation,
                    scale: scaleNormal,
                    alignWidth: 0.6
                ),

                asteroidManager.createAsteroid(
                    widthAxis: 0.1,
                    heightAxis: 0.85,
                    type: AsteroidType.desert_rock,
                    beginScale: 0.1,
                    endScale: 0.1,
                    turns: fasterRotation,
                    scale: scaleNormal),

                asteroidManager.createAsteroid(
                    widthAxis: 0.1,
                    heightAxis: 0.15,
                    type: AsteroidType.blue_fish,
                    beginScale: 0.1,
                    endScale: 0.1,
                    turns: fasterRotation,
                    scale: scaleNormal,
                    alignWidth: 0.1,
                    alignHeight: 0.1
                ),

                asteroidManager.createAsteroid(
                    widthAxis: 0.9,
                    heightAxis: 0.15,
                    type: AsteroidType.gray_moon,
                    beginScale: 0.2,
                    endScale: 0.2,
                    turns: backwardFasterRotation,
                    scale: scaleNormal,
                    alignWidth: 0.3,
                ),

                asteroidManager.createAsteroid(
                    widthAxis: 0.5,
                    heightAxis: 0.01,
                    type: AsteroidType.gold_planet,
                    beginScale: 0.4,
                    endScale: 0.5,
                    turns: normalRotation,
                    scale: scaleNormal,
                    alignWidth: 0.1,
                    alignHeight: 0.1
                ),
              ],
            ),
          );
        }
    );
  }
}