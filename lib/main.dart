import 'package:another_march_card/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MarchCardApp());
}

class MarchCardApp extends StatelessWidget{
  const MarchCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}