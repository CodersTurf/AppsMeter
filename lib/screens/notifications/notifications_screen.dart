import 'package:AppsMeter/widgets/curve_header.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen(this.leadingAppBarIcon);
  double appBArHeight = 180;
  Widget leadingAppBarIcon;
  String headerText = 'Notifications';
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
      getHeader(),
      Positioned(
          top: appBArHeight+90,
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child:
                      Column(
                        
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                Icon(
                  Icons.notifications_none,
                  size: 25,
                  color: Colors.white38,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'No new notifications',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                )
              ]))))
    ]);
  }

  getHeader() {
    return CustomHeader(appBArHeight, headerText, leadingAppBarIcon);
  }
}
