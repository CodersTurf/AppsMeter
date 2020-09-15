import 'dart:ui';

import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  String headerText;

  Widget child;
  CustomHeader(this.headerText, [this.child]);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: CurvedBottomClipper(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple[500], Colors.purple[900]],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft)),
          child: child,
        ));
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    var initStartPoint = Offset(size.width * 0.25, size.height);
    var initEndPoint = Offset(size.width * 0.5, size.height);
    path.quadraticBezierTo(
        initStartPoint.dx, initStartPoint.dy, initEndPoint.dx, initEndPoint.dy);
    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondStartPoint = Offset(size.width * 0.75, size.height);
    path.quadraticBezierTo(secondStartPoint.dx, secondStartPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}
