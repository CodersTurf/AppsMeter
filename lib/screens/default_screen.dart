import 'package:AppsMeter/screens/history/history_screen.dart';
import 'package:AppsMeter/screens/notifications/notifications_screen.dart';
import 'package:AppsMeter/screens/unused_apps/unused_apps_screen.dart';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:AppsMeter/utilities/constants.dart';

import 'home/home_screen.dart';

class DefaultScreen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<DefaultScreen>
    with SingleTickerProviderStateMixin {
  int selectedPageScreen = 0;
  final double maxSlide = 300.0;
  bool _canBeDragged = true;
  AnimationController animationController;
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

  getTitle() {
    switch (selectedNavIndex) {
      case 0:
        return "Daily Usage";
        break;
      case 1:
        return "Past Week Usage";
        break;
      case 2:
        return "Notification";
        break;
    }
  }

  Future<bool> _willPopCallback() async {
    if (selectedNavIndex == 0) {
      return true;
    }
    setState(() {
      selectedNavIndex--;
    });
    return false; // return true if the route to be popped
  }

  getStackedWidget() {
    return Stack(children: <Widget>[
      Positioned(
        width: 86,
        height: 56,
        top: 90,
        left: 300+(2600*(1-animationController.value)),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
              onTap: () {
                toggle();
              },
              child: Container(
                child: Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 0,0,0),
                        decoration: BoxDecoration(
                            color: Colors.black87.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(35)),
                        height: 35,
                        width: 35,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 21,
                        ))),
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    gradient: LinearGradient(
                      colors: [Colors.grey[900], Colors.pink[800]],
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
              )),
        ),
      ),
      Transform.translate(
          offset: Offset((maxSlide) * ((animationController.value) - 1), 0),
          child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi / 2 * (1 - animationController.value)),
              alignment: Alignment.centerRight,
              child: getDrawerMenu())),
      Transform.translate(
        offset: Offset((maxSlide) * animationController.value, 0),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(-pi * animationController.value / 2),
          alignment: Alignment.centerLeft,
          child: getDefaultScreen(),
        ),
      ),
    ]);
  }

  getDrawerMenu() {
    return GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Container(
            color: Colors.grey[800],
            width: 300,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    height: 60,
                    width: 300,
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Image.asset(
                        "assets/images/app_icon.png",
                        height: 46,
                      ),
                      title: Text('AppsMeter',
                          style: TextStyle(color: Colors.pink, fontSize: 19)),
                    )),
                ListTile(
                  onTap: () {
                    changeScreen(1);
                  },
                  leading: Icon(
                    Icons.report,
                    color: Colors.white,
                  ),
                  title: Text('Unused Apps',
                      style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  onTap: () {
                    changeScreen(2);
                  },
                  leading: Icon(
                    Icons.grade,
                    color: Colors.white,
                  ),
                  title: Text('Progress Report',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ));
  }

  changeScreen(int index) {
    animationController.reverse();
    setState(() {
      selectedPageScreen = index;
    });
  }

  closeActiveScreen(int index) {
    //slide current screen to left
    changeScreen(index);
  }

  getDefaultScreen() {
    switch (selectedPageScreen) {
      case 0:
        return WillPopScope(
            onWillPop: _willPopCallback,
            child: GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                behavior: HitTestBehavior.translucent,
                child: SafeArea(
                    child: Scaffold(
                        appBar: AppBar(
                            elevation: 0,
                            leading: GestureDetector(
                                child: Icon(Icons.menu), onTap: toggle),
                            title: Text(
                              getTitle(),
                              style: TextStyle(color: Colors.pink),
                            )),
                        body: getScreen(),
                        bottomNavigationBar: CircleBottomNavigation(
                            key: GlobalKey(),
                            initialSelection: selectedNavIndex,
                            barBackgroundColor: Colors.grey[900],
                            tabs: [
                              TabData(
                                  icon: Icons.home,
                                  iconSize: 25,
                                  title: bottomNavBars[0]),
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
                            })))));
      case 1:
        return SafeArea(child: UnusedAppsScreen(changeScreen));
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  void toggle() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
  }

  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getMainScreen();
  }

  getMainScreen() {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return getStackedWidget();
        });
  }

  getBackButon(BuildContext context) {
    OverlayEntry _overlayEntry = null;
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        width: 86,
        height: 56,
        top: 90,
        left: 300,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
              onTap: () {
                toggle();
                _overlayEntry.remove();
              },
              child: Container(
                child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black87.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(35)),
                        height: 35,
                        width: 35,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 21,
                        ))),
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    gradient: LinearGradient(
                      colors: [Colors.grey[900], Colors.pink[800]],
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
              )),
        ),
      );
    });
    return Overlay.of(context).insert(_overlayEntry);
  }
}
