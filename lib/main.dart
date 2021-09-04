import 'package:flutter/material.dart';
import 'package:snake/game.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: GamePage(),
  ));
}
