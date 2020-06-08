// import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
// import 'package:circle_bottom_navigation/widgets/tab_data.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:AppsMeter/services/navigation_service.dart';
// import 'package:AppsMeter/utilities/constants.dart';
// import 'package:AppsMeter/utilities/servicelocator.dart';

// class BottomNavBar {
//   //int selectedIndex = 0;
//   static NavigationService navService = locator<NavigationService>();
//   // BottomNavBar(String selectedNav) {
//   //   if (selectedNav != null) {
//   //     this.selectedIndex = bottomNavBars.indexOf(selectedNav);
//   //   }
//   // }

//   static Widget getNavBar(int initialIndex) {
//     return CircleBottomNavigation(
//         initialSelection: initialIndex,
//         barBackgroundColor: Colors.grey[900],
//         tabs: [
//           TabData(icon: Icons.home, iconSize: 25, title: bottomNavBars[0]),
//           TabData(icon: Icons.history, iconSize: 25, title: bottomNavBars[1]),
//           TabData(
//               icon: Icons.notifications, iconSize: 25, title: bottomNavBars[2])
//         ],
//         onTabChangedListener: (index) =>
//             navService.navigateTo(bottomNavBars[index]));
//   }
// }
// //     //  return BottomNavigationBar(
// //     //     selectedItemColor: Colors.pink,
// //     //     currentIndex: bottomNavBars.indexOf(selectedNav),
// //     //     items: [
// //     //       BottomNavigationBarItem(
// //     //         icon: new Icon(Icons.home),
// //     //         title: new Text(bottomNavBars[0]),
// //     //       ),
// //     //       BottomNavigationBarItem(
// //     //         icon: new Icon(Icons.history),
// //     //         title: new Text(bottomNavBars[1]),
// //     //       ),
// //     //        BottomNavigationBarItem(
// //     //         icon: new Icon(Icons.notifications),
// //     //         title: new Text(bottomNavBars[2]),
// //     //       )
// //     //     ],
// //     //     onTap: (index){
// //     //       navService.navigateTo(bottomNavBars[index]);
// //     //     },
// //     //   );
// //   }
// // }
// // //
