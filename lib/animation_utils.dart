import 'dart:math';

import 'package:flutter/material.dart';

enum AsteroidType {
  gold_planet,
  gray_moon,
  blue_fish,
  desert_rock
}

class AnimationControllerFactory {
  TickerProvider ticker;

  AnimationControllerFactory(this.ticker);

  AnimationController createController(Duration duration,
      {
        bool inReverse = false,
        bool toRepeat = false,
        bool loopBack = false
      }) {
    if (loopBack && toRepeat) {
      throw UnsupportedError("Animation can't loop back and repeat simultaneously.");
    }

    AnimationController _controller = AnimationController(duration: duration, vsync: ticker);

    _controller.addStatusListener((status) {
      if (loopBack) {
        if (status == AnimationStatus.dismissed) {
          _controller.forward(from: 0.0);
        }

        else if (status == AnimationStatus.completed) {
          _controller.reverse(from: 1.0);
        }
      } else if (toRepeat) {
        if (inReverse) {
          if (status == AnimationStatus.dismissed) {
            _controller.reverse(from: 1.0);
          }
        } else {
          if (status == AnimationStatus.completed) {
            _controller.forward(from: 0.0);
          }
        }
      }
    });

    if (inReverse) {
      _controller.reverse(from: 1.0);
    } else {
      _controller.forward(from: 0.0);
    }

    return _controller;
  }
}

class _Asteroid extends AnimatedWidget {
  final double size;
  final AsteroidType type;
  final double beginScale;
  final double endScale;
  final AnimationController turns;
  final AnimationController scale;
  final double alignWidth;
  final double alignHeight;

  _Asteroid({
    super.key,
      required this.size,
      required this.type,
      required this.beginScale,
      required this.endScale,
      required this.turns,
      required this.scale,
      this.alignWidth = 0,
      this.alignHeight = 0
  }) : super(listenable: Listenable.merge([turns, scale]));

  @override
  Widget build(BuildContext context) {
    int asteroidNumber = 0;
    switch (type) {
      case AsteroidType.gold_planet:
        asteroidNumber = 1;
        break;

      case AsteroidType.gray_moon:
        asteroidNumber = 2;
        break;

      case AsteroidType.blue_fish:
        asteroidNumber = 3;
        break;

      case AsteroidType.desert_rock:
        asteroidNumber = 4;
        break;
    }

    double effectiveSize = max(beginScale, endScale) * size;
    double scaleValue = scale.drive(
      Tween<double>(
        begin: beginScale,
        end: endScale
      )
    ).value;

    return Container(
      alignment: Alignment.center,
      width: effectiveSize,
      height: effectiveSize,
      // color: Colors.red, // TODO: if you need debug
      child: RotationTransition(
        alignment: Alignment(alignWidth, alignHeight),
        turns: turns,
        child: Image.asset(
          "assets/images/asteroid_${(asteroidNumber < 10 ? '0' : '') + asteroidNumber.toString()}.png",
          width: size * scaleValue,
          height: size * scaleValue,
        ),
      ),
    );
  }
}

class AsteroidFactory {
  final double size;
  const AsteroidFactory(this.size);

  Widget createAsteroid({
    required AsteroidType type,
    required double beginScale,
    required double endScale,
    required AnimationController turns,
    required AnimationController scale,
    double alignWidth = 0,
    double alignHeight = 0
  }) {
    return _Asteroid(
      size: size,
      type: type,
      beginScale: beginScale,
      endScale: endScale,
      turns: turns,
      scale: scale,
      alignWidth: alignWidth,
      alignHeight: alignHeight,
    );
  }
}

class AsteroidManager {
  final double width;
  final double height;
  final double size;
  final AsteroidFactory factory;

  AsteroidManager(this.width, this.height, this.size) : factory = AsteroidFactory(size);

  Widget createAsteroid({
    required double widthAxis,
    required double heightAxis,
    required AsteroidType type,
    required double beginScale,
    required double endScale,
    required AnimationController turns,
    required AnimationController scale,
    double alignWidth = 0,
    double alignHeight = 0
  }) {
    if (widthAxis < 0 || widthAxis > 1 || heightAxis < 0 || heightAxis > 1) {
      throw UnsupportedError("Axis values must be in interval 0 <= x <= 1");
    }

    double effectiveSize = max(beginScale, endScale) * size / 2;
    double safeLeft = (width - effectiveSize * 2) * widthAxis;
    double safeTop = (height - effectiveSize * 2) * heightAxis;

    return Positioned(
        left: safeLeft,
        top: safeTop,
        child: factory.createAsteroid(
            type: type,
            beginScale: beginScale,
            endScale: endScale,
            turns: turns,
            scale: scale,
            alignWidth: alignWidth,
            alignHeight: alignHeight
        )
    );
  }
}

class AnimatedLinearGradientContainer extends AnimatedWidget {
  final List<ColorTween> tweens;
  final AnimationController controller;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final Widget child;

  const AnimatedLinearGradientContainer(
    {
      super.key,
      this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.tweens,
      required this.controller,
      required this.child,
    }
  ) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = tweens.map((tween) => controller.drive(tween).value!).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors
        )
      ),
      child: child,
    );
  }
  
  
}

class AnimatedText extends AnimatedWidget {
  final String content;
  final AnimationController controller;
  final Tween? color;
  final Tween? shadowColor;
  final Tween<double>? fontSize;
  final Tween<double>? blurRadius;
  final String? fontFamily;

  const AnimatedText(
    this.content,
    {
      super.key,
      required this.controller,
      this.color,
      this.shadowColor,
      this.fontSize,
      this.fontFamily,
      this.blurRadius
    }
  ) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Text(content, style: DefaultTextStyle.of(context).style.copyWith(
      color: (color == null) ? null : controller.drive(color!).value as Color,
      shadows: [
        Shadow(
          blurRadius: (blurRadius == null) ? 0 : controller.drive(blurRadius!).value,
          color: (shadowColor == null) ? Colors.transparent : controller.drive(shadowColor!).value! as Color
        )
      ],
      fontSize: (fontSize == null) ? null : controller.drive(fontSize!).value,
      fontFamily: "Christmass"
    ));
  }

}