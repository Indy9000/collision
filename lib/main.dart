import 'package:collision/flappy-widget.dart';
import 'package:collision/mypainter-widget.dart';
import 'package:flutter/material.dart';

import 'mypainter-widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyPainterWidget(),
      home: FlappyWidget(),
    );
  }
}
