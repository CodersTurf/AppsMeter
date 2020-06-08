import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName,[param='']) {
    return navigatorKey.currentState.pushNamed(routeName,arguments:param);
  }
  showDialogue(Widget Function(BuildContext) builder)
  {
       showDialog(
         barrierDismissible: false,
        context: navigatorKey.currentState.overlay.context,
        builder: (bc) => SpinKitDoubleBounce(color: Colors.white));

  }
  hideDialogue()
  {
    navigatorKey.currentState.pop();
  }
}