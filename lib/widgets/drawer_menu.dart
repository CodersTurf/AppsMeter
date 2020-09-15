import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final Function onChangeMenu;
  DrawerMenu(this.onChangeMenu);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        //color: Colors.pink[200],
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan[100], Colors.cyan[300]],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        width: 300,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                height: 60,
                width: 300,
                color: Colors.grey[300],
                child: ListTile(
                  leading: Image.asset(
                    "assets/images/app_icon.png",
                    height: 46,
                  ),
                  title: Text('AppsMeter',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 19,
                          fontWeight: FontWeight.w500)),
                )),
            ListTile(
              onTap: () {
                onChangeMenu(0);
              },
              leading: Icon(
                Icons.home,
                color: Colors.white,
                size: 29,
              ),
              title: Text('Home',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
            ListTile(
              onTap: () {
                onChangeMenu(1);
              },
              leading: Icon(
                Icons.report,
                color: Colors.white,
                size: 29,
              ),
              title: Text('Unused Apps',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
            ListTile(
              onTap: () {
                onChangeMenu(2);
              },
              leading: Icon(
                Icons.notifications,
                size: 29,
                color: Colors.white,
              ),
              title: Text('Notifications',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
            ListTile(
              onTap: () {
                onChangeMenu(3);
              },
              leading: Icon(
                Icons.show_chart,
                size: 29,
                color: Colors.white,
              ),
              title: Text('App Tracker',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
