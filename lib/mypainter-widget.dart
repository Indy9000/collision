import 'dart:async';

import 'package:flutter/material.dart';

class Object {
  Offset position;
  Offset velocity;
  double radius;
}

class MyPainterWidget extends StatefulWidget {
  @override
  _MyPainterWidgetState createState() => _MyPainterWidgetState();
}

class _MyPainterWidgetState extends State<MyPainterWidget> {
  Timer timer;
  Object obj;
  Rect rect;
  @override
  void initState() {
    super.initState();
    // initialise
    obj = Object()
      ..position = Offset(150, 200)
      ..velocity = Offset(1.0, 1.0)
      ..radius = 10.0;

    rect = Rect.fromLTRB(100, 100, 500, 500);
    // create update timer tick
    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      //update object
      setState(() {
        obj.position += obj.velocity;
        // collision detection
        if (obj.position.dx + obj.radius >= rect.right) {
          //right wall hit
          obj.velocity = Offset(-obj.velocity.dx, obj.velocity.dy);
        }
        if (obj.position.dx - obj.radius <= rect.left) {
          // left wall was hit
          obj.velocity = Offset(-obj.velocity.dx, obj.velocity.dy);
        }
        if (obj.position.dy + obj.radius >= rect.bottom) {
          //bottom wall hit
          obj.velocity = Offset(obj.velocity.dx, -obj.velocity.dy);
        }
        if (obj.position.dy - obj.radius <= rect.top) {
          //top wall hit
          obj.velocity = Offset(obj.velocity.dx, -obj.velocity.dy);
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(child: Container(), painter: MyPainter(obj, rect)));
  }
}

class MyPainter extends CustomPainter {
  final pp = Paint()
    ..color = Colors.red
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke;

  final qq = Paint()
    ..color = Colors.green
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke;

  final Object obj;
  final Rect rect;
  MyPainter(this.obj, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    //draw rect
    canvas.drawRect(rect, pp);
    canvas.drawCircle(obj.position, obj.radius, qq);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
