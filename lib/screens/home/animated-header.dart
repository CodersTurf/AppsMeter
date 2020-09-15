import 'dart:math';

import 'package:AppsMeter/widgets/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedHeader extends AnimatedWidget {
  final Widget childFront;
  final Widget childBack;
  AnimatedHeader(this.childFront, this.childBack, controller)
      : super(listenable: controller);
  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(pi * animation.value),
        alignment: Alignment.center,
        child: Container(
            decoration: new BoxDecoration(
              boxShadow: [
                CustomBoxShadow(
                    color: Colors.purple[500],
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 5.0,
                    blurStyle: BlurStyle.outer)
              ],
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              //border: Border.all(color: Colors.white, width: 3)
            ),
            width: MediaQuery.of(context).size.width * 0.85,
            height: 170,
            child: animation.value < 0.5
                ? childFront
                : Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(pi * 1),
                    alignment: Alignment.center,
                    child: childBack)));
  }
}
