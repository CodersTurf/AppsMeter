import 'dart:math';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:AppsMeter/widgets/curve_header.dart';
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

