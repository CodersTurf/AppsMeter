import 'package:AppsMeter/screens/history/history_screen.dart';
import 'package:AppsMeter/screens/notifications/notifications_screen.dart';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:flutter/material.dart';

import 'package:AppsMeter/utilities/constants.dart';

import 'home/home_screen.dart';

class DefaultScreen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<DefaultScreen> {
  final NavigationService navService = locator<NavigationService>();
  int selectedNavIndex = 0;
  getScreen() {
    switch (selectedNavIndex) {
      case 0:
        return HomeScreen();
        break;
      case 1:
        return HistoryScreen();
        break;
      case 2:
        return NotificationScreen();
        break;
    }
  }

  Future<bool> _willPopCallback() async {
    if(selectedNavIndex==0)
    {
      return true;
    }
    setState(() {
      selectedNavIndex--;
    });
    return false; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:_willPopCallback,
        child:SafeArea(child: Scaffold(
            body: getScreen(),
            bottomNavigationBar: CircleBottomNavigation(
              key:GlobalKey(),
                initialSelection: selectedNavIndex,
                barBackgroundColor: Colors.grey[900],
                tabs: [
                  TabData(
                      icon: Icons.home, iconSize: 25, title: bottomNavBars[0]),
                  TabData(
                      icon: Icons.history,
                      iconSize: 25,
                      title: bottomNavBars[1]),
                  TabData(
                      icon: Icons.notifications,
                      iconSize: 25,
                      title: bottomNavBars[2])
                ],
                onTabChangedListener: (index) {
                  setState(() {
                    selectedNavIndex = index;
                  });
                }))));
  }

  dispose() {}
}
