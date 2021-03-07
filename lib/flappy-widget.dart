import 'dart:async';

import 'package:flutter/material.dart';

class FlappyWidget extends StatefulWidget {
  @override
  _FlappyWidgetState createState() => _FlappyWidgetState();
}

class Bird {
  Offset position;
  Offset velocity;
  double accel;
  Rect rect;
  bool isDead;
}

class _FlappyWidgetState extends State<FlappyWidget> {
  Timer timer;
  List<Rect> walls;
  Bird bird;
  static double gravity = 0.1;

  @override
  void initState() {
    super.initState();

    // walls
    walls = List<Rect>();
    walls.add(Rect.fromLTRB(500, 100, 600, 400));
    walls.add(Rect.fromLTRB(500, 500, 600, 800));

    //bird
    bird = createNewBird();

    // create update timer tick
    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      // update objects
      setState(() {
        bird.position += bird.velocity;
        bird.velocity += Offset(0, bird.accel + gravity);
        bird.accel += 0.1; // decay the accelleration
        bird.accel = bird.accel > 0 ? 0.0 : bird.accel;
        bird.rect =
            Rect.fromCenter(center: bird.position, width: 30, height: 30);

        //collision detection
        for (var wall in walls) {
          if (collisionDetection(bird, wall)) {
            bird.velocity = Offset(0, 5.0);
            bird.isDead = true;
          }
        }
        //reset game
        if (bird.position.dx <= 0 ||
            bird.position.dx > W ||
            bird.position.dy <= 0 ||
            bird.position.dy >= H) {
          // out of bounds
          bird = createNewBird();
        }
      });
    });
  }

  Bird createNewBird() {
    final pos = Offset(100, 300);

    return Bird()
      ..position = pos
      ..velocity = Offset(1.0, 3.0)
      ..accel = 0.0
      ..isDead = false
      ..rect = Rect.fromCenter(center: pos, width: 30, height: 30);
  }

  bool collisionDetection(Bird bird, Rect wall) {
    final c1 = bird.rect.right >= wall.left && bird.rect.right <= wall.right;
    final c2 = bird.rect.top >= wall.top && bird.rect.top <= wall.bottom; //

    final c3 =
        bird.rect.bottom >= wall.top && bird.rect.bottom <= wall.bottom; //
    // final c4 = bird.rect.right >= wall.left && bird.rect.right <= wall.right;//

    final c5 = bird.rect.left >= wall.left && bird.rect.left <= wall.right;
    // final c6 = bird.rect.top >= wall.top && bird.rect.top <= wall.bottom;//

    // final c7 = bird.rect.bottom >= wall.top && bird.rect.bottom <= wall.bottom;//
    // final c8 = bird.rect.left >= wall.left && bird.rect.left <= wall.right;

    // return (c1 && c2) || (c3 && c4) || (c5 && c6) || (c7 && c8);
    return (c1 && c2) || (c3 && c1) || (c5 && c2) || (c3 && c5);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  double W = 0;
  double H = 0;
  @override
  Widget build(BuildContext context) {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.width;

    return Container(
        child: GestureDetector(
      onTap: handleOnTap,
      child: CustomPaint(
          child: Container(), painter: MyFlappyPainter(walls, bird)),
    ));
  }

  void handleOnTap() {
    bird.accel = -1.0;
  }
}

class MyFlappyPainter extends CustomPainter {
  final List<Rect> walls;
  final Bird bird;
  MyFlappyPainter(this.walls, this.bird);
  @override
  void paint(Canvas canvas, Size size) {
    walls.forEach((wall) {
      canvas.drawRect(wall, pp);
    });
    //draw bird
    canvas.drawRect(bird.rect, bird.isDead ? rr : qq);
  }

  final pp = Paint()
    ..color = Colors.red
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  final rr = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  final qq = Paint()
    ..color = Colors.green
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
