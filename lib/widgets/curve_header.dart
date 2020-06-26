import 'dart:ui';

import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  double height;
  String headerText;
  Widget leading;
  CustomHeader(this.height,this.headerText,[this.leading]);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: CurvedBottomClipper(),
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.grey[900], Colors.pink[800]],
            )),
            height: height,
            child: Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 90),
                    child: Row(children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      leading,
                      Expanded(
                          child: Center(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                            child: Text(headerText,
                                style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                ))),
                      ))
                    ])))));
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    var initStartPoint = Offset(size.width * 0.25, size.height - 50);
    var initEndPoint = Offset(size.width * 0.5, size.height - 35);
    path.quadraticBezierTo(
        initStartPoint.dx, initStartPoint.dy, initEndPoint.dx, initEndPoint.dy);
    var secondEndPoint = Offset(size.width, size.height - 80);
    var secondStartPoint = Offset(size.width * 0.75, size.height - 10);
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
