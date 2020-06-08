import 'dart:async';
import 'dart:math';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

class PermissionError extends StatelessWidget {

  final NavigationService navService = locator<NavigationService>();
  checkAppPerm() async {    
    var perm = await UsageStats.checkUsagePermission();
    if (!perm) {      
      await UsageStats.grantUsagePermission();     
    } else {
      navService.navigateTo('Default');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: Center(
                child: Column(children: <Widget>[
          ClipPath(
              clipper: CurvedBottomClipper(),
              child: Container(
                  color: Colors.grey[800],
                  height: 180.0,
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Text(
                      "Permission Required",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.blue,
                      ),
                    ),
                  )))),
          SizedBox(height: 20),
          Container(
              child: Card(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(children: <Widget>[
                        Text(
                            "AppsMeter needs 'Usage Data Access' permission to get " +
                                "the proper usage data. Please grant the permission using the option below",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70)),
                        SizedBox(
                          height: 20,
                        ),
                        // Image.asset("assets/images/permission_icon.png"),
                      ])))),
          SizedBox(
            height: 30,
          ),
          OutlineButton(
            onPressed: checkAppPerm,
            child: Text('Grant Permission'),
            highlightedBorderColor: Colors.pink,
            textColor: Colors.pink,
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  "**DISCLAIMER: We dont store any 'App Usage' data or user's personnel information " +
                      "in our server.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center)),
        ]))));
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // I've taken approximate height of curved part of view
    // Change it if you have exact spec for it
    final roundingHeight = size.height * 3 / 5;

    // this is top part of path, rectangle without any rounding
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);

    // this is rectangle that will be used to draw arc
    // arc is drawn from center of this rectangle, so it's height has to be twice roundingHeight
    // also I made it to go 5 units out of screen on left and right, so curve will have some incline there
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);

    final path = Path();
    path.addRect(filledRectangle);

    // so as I wrote before: arc is drawn from center of roundingRectangle
    // 2nd and 3rd arguments are angles from center to arc start and end points
    // 4th argument is set to true to move path to rectangle center, so we don't have to move it manually
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}
