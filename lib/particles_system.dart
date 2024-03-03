import 'dart:math';

class Particle {
  // All positions are relative and
  // accept values in [0, 1]
  double x;
  double y;

  // All velocities are relative and
  // accept values in [-1, 1]
  double dx;
  double dy;

  Particle(this.x, this.y, this.dx, this.dy) {
    if (x < 0 || x > 1 || y < 0 || y > 1 || dx < -1 || dx > 1 || dy < -1 || dy > 1) {
      throw UnsupportedError("Position and velocity components can only be in [0, 1] interval.");
    }
  }
}

class ParticleManager {
  List<Particle> particles = [];

  // Generate $particlesCount particles and randomly set their position
  ParticleManager(int particlesCount) {
    if (particlesCount < 1) {
      throw UnsupportedError("Particle Manager: count of particles must be at least one(>=1), but it's $particlesCount.");
    }

    Random rng = Random();
    for (int i = 0; i < particlesCount; i ++) {
      particles.add(Particle(
          rng.nextDouble(),
          rng.nextDouble(),
          sin(rng.nextDouble() * 2 * pi) * 0.00005,
          cos(rng.nextDouble() * 2 * pi) * 0.00005
        )
      );
    }
  }

  void update() {
    for (int i = 0; i < particles.length; i ++) {
      Particle currentParticle = particles[i];

      currentParticle.x += currentParticle.dx;
      if (currentParticle.x < 0) {
        currentParticle.x += 1;
      } else if (currentParticle.x > 1) {
        currentParticle.x -= 1;
      }

      currentParticle.y += currentParticle.dy;
      if (currentParticle.y < 0) {
        currentParticle.y += 1;
      } else if (currentParticle.y > 1) {
        currentParticle.y -= 1;
      }

      Random rng = Random();
      // currentParticle.dx += currentParticle.dx * (rng.nextDouble() - 0.5);
      // currentParticle.dy += currentParticle.dy * (rng.nextDouble() - 0.5);

    }
  }
}