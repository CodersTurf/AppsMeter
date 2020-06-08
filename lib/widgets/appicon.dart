
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final Uint8List appIconImage;
  AppIcon(this.appIconImage);
  @override
  Widget build(BuildContext context) {
    return new Container(
      
        padding: EdgeInsets.all(8),
        //margin: EdgeInsets.all(3),
        child: Image.memory(
          appIconImage,
          fit: BoxFit.cover,
          height: 40,
          width: 40,
        ),
        decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.blue,
                blurRadius: 2.0,
                spreadRadius: 2.0,
                offset: Offset(
                  0.0,
                  0.0,
                ),
              ),
            ]));
  }
}