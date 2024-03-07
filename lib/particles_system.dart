import 'dart:math';

import 'package:flutter/material.dart';

class PInterval<T> {
  T begin;
  T end;

  PInterval({required this.begin, required this.end});

  PInterval.value(T value)
      : begin = value,
        end = value;
}

class Particle {
  // All positions are relative and
  // accept values in [0, 1]
  double x;
  double y;

  // All velocities are relative and
  // accept values in [-1, 1]
  double dx;
  double dy;

  Color color;
  double opacity;
  double size;

  Particle(
      {required this.x,
      required this.y,
      required this.dx,
      required this.dy,
      required this.color,
      required this.opacity,
      required this.size,
    }) {
    if (x < 0 ||
        x > 1 ||
        y < 0 ||
        y > 1 ||
        dx < -1 ||
        dx > 1 ||
        dy < -1 ||
        dy > 1) {
      throw UnsupportedError(
          "Position and velocity components can only be in [0, 1] interval.");
    }
  }
}

class PhaseParticle extends Particle {
  final double timeShift;
  double? lastT;
  bool _forward = true;

  PhaseParticle({
      required super.x,
      required super.y,
      required super.dx,
      required super.dy,
      required super.color,
      required super.opacity,
      required super.size,
      required this.timeShift,
  }) {
    if (timeShift < 0 || timeShift > 1) {
      throw UnsupportedError("Time shift must be in [0, 1]");
    }
  }

  double evaluateWithTimeShift(double t) {
    lastT ??= t;
    _forward = t - lastT! >= 0;
    lastT = t;

    double efficientTime;

    if (_forward) {
      efficientTime = t + timeShift;

      if (efficientTime > 1) {
        efficientTime = 1 - (efficientTime - 1);
      }
    } else {
      efficientTime = t - timeShift;

      if (efficientTime < 0) {
        efficientTime = -efficientTime;
      }
    }


    return efficientTime;
  }
}

class ParticleManager {
  final AnimationController controller;

  List<PhaseParticle> particles = [];
  final List<Color> colors;
  final PInterval<double> opacityRange;
  final PInterval<double> sizeRange;
  final PInterval<double> velocityRange;
  final bool fading;

  DateTime _lastTime = DateTime.now();

  bool inited = false;

  double _generateFromInterval(PInterval<double> interval) {
    Random rng = Random();

    return interval.begin + (interval.end - interval.begin) * rng.nextDouble();
  }

  // Generate $particlesCount particles and randomly set their position
  ParticleManager(
      {required this.controller,
      required this.colors,
      required this.opacityRange,
      required this.sizeRange,
      required this.velocityRange,
      this.fading = false});

  void initParticles(int particlesCount) {
    if (particlesCount < 1) {
      throw UnsupportedError(
          "Particle Manager: count of particles must be at least one(>=1), but it's $particlesCount.");
    }

    inited = true;

    Random rng = Random();
    for (int i = 0; i < particlesCount; i++) {
      particles.add(PhaseParticle(
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          dx: sin(rng.nextDouble() * 2 * pi) *
              _generateFromInterval(velocityRange),
          dy: cos(rng.nextDouble() * 2 * pi) *
              _generateFromInterval(velocityRange),
          color: colors[rng.nextInt(colors.length)],
          opacity: _generateFromInterval(opacityRange),
          size: _generateFromInterval(sizeRange),
          timeShift: rng.nextDouble()));
    }
  }

  void update() {
    double delta = DateTime.now().difference(_lastTime).inMilliseconds / 1000;
    _lastTime = DateTime.now();

    for (int i = 0; i < particles.length; i++) {
      PhaseParticle currentParticle = particles[i];

      currentParticle.x += currentParticle.dx * delta;
      if (currentParticle.x < 0) {
        currentParticle.x += 1;
      } else if (currentParticle.x > 1) {
        currentParticle.x -= 1;
      }

      currentParticle.y += currentParticle.dy * delta;
      if (currentParticle.y < 0) {
        currentParticle.y += 1;
      } else if (currentParticle.y > 1) {
        currentParticle.y -= 1;
      }

      if (fading) {
        currentParticle.opacity = opacityRange.begin +
            (opacityRange.end - opacityRange.begin) *
                currentParticle.evaluateWithTimeShift(
                    controller.drive(CurveTween(curve: Curves.easeOut)).value);
      }
      // currentParticle.dx += currentParticle.dx * (rng.nextDouble() - 0.5);
      // currentParticle.dy += currentParticle.dy * (rng.nextDouble() - 0.5);
    }
  }
}
