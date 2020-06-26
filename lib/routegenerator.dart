import 'package:AppsMeter/screens/default_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case 'Default':
        return MaterialPageRoute(
          builder: (_) => DefaultScreen(),
        );
        break; 

      case 'Error':
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(args);
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      );
    });
  }
}
