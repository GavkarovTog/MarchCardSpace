import 'dart:math';

import 'package:another_march_card/animated_asteroids_background.dart';
import 'package:another_march_card/animated_space_background.dart';
import 'package:another_march_card/animation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController controller;
  final AudioPlayer player = AudioPlayer();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      player.pause();
    } else if (state == AppLifecycleState.resumed) {
      player.resume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AnimationControllerFactory factory = AnimationControllerFactory(this);
    controller = factory.createController(const Duration(seconds: 1), loopBack: true);

    player.play(AssetSource("sounds/ambient.mp3"));
    player.onPlayerComplete.listen((event) {
      player.play(AssetSource("sounds/ambient.mp3"));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent
        ),
        child: SafeArea(
          top: false,
          child: Stack(children: [
            AnimatedSpaceBackground(controller: controller,),
            const AnimatedAsteroidsBackground(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("8 Марта",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Bicubik",
                      color: Colors.yellow.shade700,
                      fontSize: 24,
                    )
                  ),
                  const SizedBox(height: 10,),
                  Text(
                  """
С Женским днем 8 Марта!
Пусть исполнятся мечты.
Пусть улыбкой озарятся
Лиц прекрасные черты.

Теплоты, любви, успехов,
Ощущения весны,
Жизни яркой, полной смеха,
Ласки, счастья, доброты.
                """,

                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Bicubik",
                  color: Colors.yellow.shade700,
                  fontSize: 18,
                ),),
              ]
              ),
            )
          ])
        ),
      )
    );
  }
}
