import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen(this.leadingAppBarIcon);
  double appBArHeight = 180;
  Widget leadingAppBarIcon;
  String headerText = 'Notifications';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {},
        child: Scaffold(body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    leadingAppBarIcon,
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            (MediaQuery.of(context).size.width / 2) - 120,
                            10,
                            20,
                            0),
                        child: Column(children: <Widget>[
                          Text("Notifications", style: TextStyle(fontSize: 22)),
                        ]))
                  ]),
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pink[200], Colors.pink[700]],
                      begin: Alignment.centerRight,
                      end: Alignment.topLeft)),
            ),
            Positioned(
                top: 120,
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: viewportConstraints.maxHeight - 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No Notifications Found',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        ))))
          ]);
        })));
  }
}
