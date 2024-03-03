import 'dart:math';

import 'package:flutter/material.dart';

enum FlowerType {
  redCartoon,
  blueStrange,
  pinkMorning,
  yellowSun,
  greenFrog,
  redSunrise
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

class _Flower extends AnimatedWidget {
  final double size;
  final FlowerType type;
  final double beginScale;
  final double endScale;
  final AnimationController turns;
  final AnimationController scale;

  _Flower({
    super.key,
      required this.size,
      required this.type,
      required this.beginScale,
      required this.endScale,
      required this.turns,
      required this.scale}) : super(listenable: Listenable.merge([turns, scale]));

  @override
  Widget build(BuildContext context) {
    int flowerNumber = 0;
    switch (type) {
      case FlowerType.redCartoon:
        flowerNumber = 1;
        break;

      case FlowerType.blueStrange:
        flowerNumber = 2;
        break;

      case FlowerType.pinkMorning:
        flowerNumber = 3;
        break;

      case FlowerType.yellowSun:
        flowerNumber = 4;
        break;

      case FlowerType.greenFrog:
        flowerNumber = 5;
        break;

      case FlowerType.redSunrise:
        flowerNumber = 6;
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
        turns: turns,
        child: Image.asset(
          "assets/images/flower_${(flowerNumber < 10 ? '0' : '') + flowerNumber.toString()}.png",
          width: size * scaleValue,
          height: size * scaleValue,
        ),
      ),
    );
  }
}

class FlowerFactory {
  final double size;
  const FlowerFactory(this.size);

  Widget createFlower({
    required FlowerType type,
    required double beginScale,
    required double endScale,
    required AnimationController turns,
    required AnimationController scale
  }) {
    return _Flower(
      size: size,
      type: type,
      beginScale: beginScale,
      endScale: endScale,
      turns: turns,
      scale: scale,
    );
  }
}

class FlowerManager {
  final double width;
  final double height;
  final double size;
  final FlowerFactory factory;

  FlowerManager(this.width, this.height, this.size) : factory = FlowerFactory(size);

  Widget createFlower({
    required double widthAxis,
    required double heightAxis,
    required FlowerType type,
    required double beginScale,
    required double endScale,
    required AnimationController turns,
    required AnimationController scale
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
        child: factory.createFlower(type: type, beginScale: beginScale, endScale: endScale, turns: turns, scale: scale)
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