// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:AppsMeter/screens/history/history_screen.dart';
// import 'package:AppsMeter/screens/home/home_screen.dart';
// import 'package:AppsMeter/screens/settings/settings_screen.dart';

// class CustomBottomBar extends StatefulWidget {
//   @override
//   _CustomBottomBarState createState() => _CustomBottomBarState();
// }

// class _CustomBottomBarState extends State<CustomBottomBar> {
//   int currentIndex = 0;
//   void onTabBar(index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }
//   getWidgets(index)
//   {
//     switch(index)
//     {
//       case 0: return HomeScreen(); break;
//       case 1: return HistoryScreen(); break;
//       case 2: return SettingScreen(); break;
//     }
//   }
//   //List<Widget> widgets = [HomeScreen(), HistoryScreen(),SettingScreen()];
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(   
         
//       backgroundColor: Theme.of(context).backgroundColor,
//       body:SafeArea( child: getWidgets(currentIndex)),
//       bottomNavigationBar: BottomNavigationBar(   
//         selectedItemColor: Colors.blue,    
//         currentIndex: currentIndex,        
//         items: [
//           BottomNavigationBarItem(
//             icon: new Icon(Icons.home),
//             title: new Text('Home'),
//           ),
//           BottomNavigationBarItem(
//             icon: new Icon(Icons.show_chart),
//             title: new Text('History'),
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.settings), title: Text('Settings'))
//         ],
//         onTap: onTabBar,
//       ),
//     );
//   }
// }
