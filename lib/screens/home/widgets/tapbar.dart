import 'package:AppsMeter/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTabBar extends StatefulWidget {
  Function onTapped;
  HomeTabBar(this.onTapped);
  @override
  _HomeTabBarState createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  int _selectedDay = 0;

  List<String> getDailyHeaders() {
    var headers = ['Today', 'Yesterday'];
    for (var i = 0; i < 5; i++) {
      var day =
          weekDays[DateTime.now().subtract(Duration(days: i + 2)).weekday];
      headers.add(day);
    }
    return headers;
  }

  @override
  Widget build(BuildContext context) {
    var dailyHeaders = getDailyHeaders();
    return ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: List<Widget>.generate(dailyHeaders.length, (index) {
          return GestureDetector(
              child: Container(
                  color: Colors.grey[900],
                  padding: EdgeInsets.all(10),
                  child: Text(dailyHeaders[index],
                      style: _selectedDay == index
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.white
                                  )
                          : TextStyle(
                              fontSize: 16,
                              color: _selectedDay == index
                                  ? Colors.white
                                  : Colors.white60))),
              onTap: () {
                _selectedDay = index;
                widget.onTapped(index.toString());
                setState(() {});
              });
        }));
  }
}
