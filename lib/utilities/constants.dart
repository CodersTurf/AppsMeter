import 'dart:ui';

import 'package:flutter/material.dart';

const String othersApp='Others';
const int numberOfDisplayApps=11;
const List<String> bottomNavBars=['Home','History','Notifications'];
const double headerBarHeight=40;
const double headerHeight=60;
const Map<String,String> appUsageRange={"oneWeek":"One week",
"twoWeek":"Two weeks",
"oneMonth":"One month"};
const Map<String,int> dayCount={"oneWeek":7,
"twoWeek":14,
"oneMonth":31};
Map<int,String> weekDays={1:'Monday',2:'Tuesday',3:'Wednesday',4:'Thursday',5:'Friday',6:'Saturday',7:'Sunday'};
Map<int,String> yearMonths={1:'January',2:'February',3:'March',4:'April',5:'May',6:'June',7:'July',
8:'August',9:'September',10:'October',11:'November',12:'December'};
List<Color> pieChartColors=[Colors.red,Colors.orange[700],Colors.pink[500],
Colors.brown,Colors.yellow[600], Colors.purple[500], Colors.blueAccent,Colors.green[500],Colors.cyan,
Colors.green[900],Colors.pink[100]];
enum UsageDateRange{
  today,
  oneWeek,
  twoWeek,
  oneMonth
}
