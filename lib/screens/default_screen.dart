import 'package:AppsMeter/screens/notifications/notifications_screen.dart';
import 'package:AppsMeter/screens/unused_apps/unused_apps_screen.dart';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:AppsMeter/widgets/drawer_menu.dart';

import 'package:flutter/material.dart';
import 'dart:math';

import 'home/home_screen.dart';

class DefaultScreen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<DefaultScreen>
    with SingleTickerProviderStateMixin {
  int selectedPageScreen = 0;
  double appBArHeight = 180;
  final double maxSlide = 300.0;
  bool _canBeDragged = true;
  AnimationController animationController;
  final NavigationService navService = locator<NavigationService>();
  int selectedNavIndex = 0;
  Widget child;
  getMenuIcon() {
    return IconButton(
        onPressed: () {
          toggle();
        },
        icon: Icon(
          Icons.menu,
          color: Colors.white70,
          size: 30,
        ));
  }

  getScreen() {
    switch (selectedPageScreen) {
      case 0:
        child = HomeScreen(getMenuIcon());
        break;

      case 1:
        return SafeArea(
            child: UnusedAppsScreen(changeScreen, getMenuIcon(), UniqueKey()));
      case 2:
        return SafeArea(child: NotificationScreen(getMenuIcon()));
      case 4:
        child = NotificationScreen(IconButton(
            onPressed: () {
              toggle();
            },
            icon: Icon(
              Icons.menu,
              size: 30,
            )));
        break;
    }
    return child;
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

  getStackedWidget(child) {
    return Stack(children: <Widget>[
      Positioned(
        width: 86,
        height: 56,
        top: 85,
        left: 300 + (2600 * (1 - animationController.value)),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
              onTap: () {
                toggle();
              },
              child: Container(
                child: Center(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                        decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.4),
                            borderRadius: BorderRadius.circular(35)),
                        height: 35,
                        width: 35,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 21,
                        ))),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.cyan[200], Colors.cyan[300]],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft),
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
          child: child,
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
        child: DrawerMenu(changeScreen));
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
    // switch (selectedPageScreen) {
    //   case 0:
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: GestureDetector(
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            behavior: HitTestBehavior.translucent,
            child: SafeArea(
                child: Scaffold(
              body: getScreen(),
            ))));
    // case 1:
    //   return SafeArea(child: UnusedAppsScreen(changeScreen));
    // case 2:
    //   return SafeArea(child: ReportScreen(changeScreen));
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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
    var child = getDefaultScreen();
    return AnimatedBuilder(
        animation: animationController,
        child: child,
        builder: (context, child) {
          return getStackedWidget(child);
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
