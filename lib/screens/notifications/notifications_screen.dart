import 'package:flutter/material.dart';


class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
        Container(
            height: 500,
            child: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  Icon(Icons.notifications_none,size: 25,color: Colors.white38,),
                  SizedBox(height: 10,),
                  Text('No new notifications',style: TextStyle(fontSize: 18,color: Colors.white54),)
                ])));
      
  }
}
