import 'package:flutter/material.dart';

class MenuClipper extends CustomClipper<Path> {
  final double verticalDragVal;
  final double fallbackAnimationVal;
  final double buttonSize;

  double radius = 0;

  MenuClipper(this.verticalDragVal, this.fallbackAnimationVal, this.buttonSize);
  @override
  Path getClip(Size size) {
    if (buttonSize <= 50) {
      radius = 0.4;
    } else if (buttonSize <= 70) {
      radius = 0.3;
    } else if (buttonSize <= 90) {
      radius = 0.2;
    } else {
      radius = 0;
    }

    final path = Path()
      ..moveTo(0, size.height)
      ..cubicTo(
        size.width *
            (.60 + (0.0015 * verticalDragVal) * (1 - fallbackAnimationVal)),
        size.height,
        size.width * radius,
        size.height * (.88 + 0.12 * fallbackAnimationVal) -
            verticalDragVal +
            fallbackAnimationVal * verticalDragVal,
        size.width * .50,
        size.height * (.88 + 0.12 * fallbackAnimationVal) -
            verticalDragVal +
            fallbackAnimationVal * verticalDragVal,
      )
      ..cubicTo(
        size.width * (1 - radius),
        size.height * (.88 + 0.12 * fallbackAnimationVal) -
            verticalDragVal +
            fallbackAnimationVal * verticalDragVal,
        size.width *
            (.40 - (0.0015 * verticalDragVal) * (1 - fallbackAnimationVal)),
        size.height,
        size.width,
        size.height,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    return path;
    // final path = Path()
    //   ..moveTo(0, size.height)
    //   ..cubicTo(
    //     size.width * (.60 + 0.0015 * verticalDragVal),
    //     size.height * .99,
    //     size.width * .30,
    //     size.height * .88 - verticalDragVal,
    //     size.width * .50,
    //     size.height * .88 - verticalDragVal,
    //   )
    //   ..cubicTo(
    //     size.width * .70,
    //     size.height * .88 - verticalDragVal,
    //     size.width * (.40 - 0.0015 * verticalDragVal),
    //     size.height * .99,
    //     size.width,
    //     size.height,
    //   )
    //   ..lineTo(size.width, 0)
    //   ..lineTo(0, 0)
    //   ..close();

    // return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class AnimatedMenu extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final path = new Path()
      ..moveTo(size.width * .6, 0)
      ..quadraticBezierTo(
        size.width * .7,
        size.height * .08,
        size.width * .9,
        size.height * .05,
      )
      ..arcToPoint(
        Offset(
          size.width * .93,
          size.height * .15,
        ),
        radius: Radius.circular(size.height * .05),
        largeArc: true,
      )
      ..cubicTo(
        size.width * .6,
        size.height * .15,
        size.width * .5,
        size.height * .46,
        0,
        size.height * .3,
      )
      ..lineTo(0, 0)
      ..close();

    //canvas.drawPath(path, paint);
    canvas.clipPath(path);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
