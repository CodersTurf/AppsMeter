// import 'package:AppsMeter/datalayer/models/AppPieChartModel.dart';
// import 'package:AppsMeter/datalayer/models/appusage_model.dart';
// import 'package:AppsMeter/utilities/constants.dart';
// import 'package:AppsMeter/utilities/helper.dart';
// import 'package:AppsMeter/widgets/apppie_chart_legend.dart';
// import 'package:AppsMeter/widgets/apps_piechart.dart';
// import 'package:flutter/material.dart';

// class TopApps extends StatelessWidget {
//   final List<AppUsageModel> apps;
//   TopApps(this.apps);
//   getChartData() {
//     var data = List<AppPieChartModel>.generate(apps.length, (index) {
//       var app = apps[index];
//       return AppPieChartModel(
//           app.appName,
//           "",
//           getSummaryTextFromSeconds(app.usageSeconds, pieChartText: true),
//           app.usageSeconds,
//           pieChartColors[index]);
//     });
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         elevation: 1,
//         // color: Colors.grey[800].withOpacity(0.8),
//         child: Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     colors: [Colors.transparent, Colors.grey[900]],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter)),
//             //  color: Colors.grey[800].withOpacity(0.8),
//             child: SingleChildScrollView(
//                 child: apps.length > 0
//                     ? Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                             Container(
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                         bottom: BorderSide(
//                                             width: 0.5,
//                                             color: Colors.grey[700]))),
//                                 padding: EdgeInsets.all(15),
//                                 child: Row(children: <Widget>[
//                                   Text('Top Used Apps',
//                                       style: TextStyle(
//                                           color: Colors.black12, fontSize: 18)),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Tooltip(
//                                     preferBelow: false,
//                                     message: 'Usage time > 4mins',
//                                     child: Icon(
//                                       Icons.info_outline,
//                                       color: Colors.orange,
//                                       size: 23,
//                                     ),
//                                   )
//                                 ])),
//                             Padding(padding: EdgeInsets.all(10)),
//                             Container(
//                                 padding: EdgeInsets.all(10),
//                                 child: Wrap(
//                                     alignment: WrapAlignment.start,
//                                     children: List<Widget>.generate(apps.length,
//                                         (index) {
//                                       return AppPieChartLegend(
//                                           pieChartColors[index],
//                                           apps[index].appName);
//                                     }))),
//                             AppPieChart(getChartData())
//                           ])
//                     : Container(
//                         alignment: Alignment.topCenter,
//                         padding: EdgeInsets.all(50),
//                         child: Center(
//                             child: Text(
//                           'Data not available',
//                           style: TextStyle(fontSize: 17, color: Colors.pink),
//                         )),
//                       ))));
//   }
// }
