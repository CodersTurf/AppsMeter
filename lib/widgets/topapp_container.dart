import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopAppContainer extends StatelessWidget {
  final Widget child;
  TopAppContainer(this.child);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
        // decoration: BoxDecoration(
        //     boxShadow: <BoxShadow>[
        //       BoxShadow(
        //           color: Colors.grey,
        //           offset: Offset(3.0, 3.0),
        //           blurRadius: 2.0,
        //           spreadRadius: 1.0),
        //     ],
        //     borderRadius: BorderRadius.circular(20),
        //     gradient: LinearGradient(
        //         colors: [Colors.purple, Colors.purple[900]],
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter)),
        child: child);
  }
}

// class ContainerClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width * 0.65, 0);

//     var initStartPoint = Offset(size.width, size.height * 0.25);
//     var initEndPoint = Offset(size.width, size.height * 0.55);
//     path.quadraticBezierTo(
//         initStartPoint.dx, initStartPoint.dy, initEndPoint.dx, initEndPoint.dy);
//     path.lineTo(size.width, size.height);
//     // var secondEndPoint = Offset(size.width, size.height - 60);
//     // var secondStartPoint = Offset(size.width * 0.75, size.height);
//     // path.quadraticBezierTo(secondStartPoint.dx, secondStartPoint.dy,
//     //     secondEndPoint.dx, secondEndPoint.dy);

//     path.lineTo(0, size.height);

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
//     // basically that means that clipping will be redrawn on any changes
//     return true;
//   }
// }
