import 'package:flutter/material.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/widgets/bottombar.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.notifications,
                color: Colors.pink,
              ),
              SizedBox(
                width: 10,
              ),
              Text(bottomNavBars[2], style: TextStyle(color: Colors.pink)),
              // Your widgets here
            ],
          ),
        ),
        body: Container(
            height: 500,
            child: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  Icon(Icons.notifications_none,size: 25,color: Colors.white38,),
                  SizedBox(height: 10,),
                  Text('No new notifications',style: TextStyle(fontSize: 18,color: Colors.white54),)
                ]))),
      ));
  }
}
