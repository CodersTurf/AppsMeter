import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/widgets/totalusagesummary.dart';

import 'appicon.dart';

// class TopUsedApps extends StatelessWidget {
//   final List<AppUsageModel> apps;
//   final Function(AppUsageModel) onTap;
//   TopUsedApps(this.apps, [this.onTap = null]);
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//         constraints: BoxConstraints(minHeight: 100),
//         child: Container(
//             //color: Colors.grey[900],
//             // child: Padding(
//             //padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//             child: Center(child: Column(children: getAppUsage(apps)))));
//   }

//   getAppUsage(List<AppUsageModel> apps) {
//     List<Widget> widgets = new List<Widget>();

//     for (var index = 0; index < apps.length; index++) {
//       widgets.add(GestureDetector(
//           onTap: () {
//             onTap(apps[index]);
//           },
//           child: AppDetails(apps[index])));
//     }
//     return widgets;
//   }
// }

class AppDetails extends StatelessWidget {
  final AppUsageModel app;
  AppDetails(this.app, this.onTap);
  Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey[300],
                //offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                spreadRadius: 2.0),
          ],
        ),
        margin: EdgeInsets.all(8),
        child: Material(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
                splashColor: Colors.purple,
                onTap: () {
                  onTap(app);
                },
                child: Center(
                    child: ListTile(
                  //dense: true,
                  contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                  leading: Image.memory(
                    app.decodedImage,
                    fit: BoxFit.contain,
                    height: 52,
                  ),

                  title: Text(
                    app.appName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        getSummaryTextFromSeconds(app.usageSeconds),
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      )),
                  trailing: TotalUsageSummary('', app.totalPercentUSed, 3, 50,
                      getColorCodeForSingleAppUsage(app.usageSeconds)),
                )))));
    //}
  }
}
