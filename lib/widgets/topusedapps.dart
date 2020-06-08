import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/widgets/totalusagesummary.dart';

import 'appicon.dart';

class TopUsedApps extends StatelessWidget {
  final List<AppUsageModel> apps;
  final Function(AppUsageModel) onTap;
  TopUsedApps(this.apps, [this.onTap = null]);
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: Card(
            color: Colors.grey[900],
            // child: Padding(
            //padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Center(child: Column(children: getAppUsage(apps)))));
  }

  getAppUsage(List<AppUsageModel> apps) {
    List<Widget> widgets = new List<Widget>();
    widgets.add(Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey[700]))),
        child: ListTile(
          title: Text(
            'Top Used Apps',
            style: TextStyle(color: Colors.blue),
          ),
        )));
    for (var index = 0; index < apps.length; index++) {
      widgets.add(GestureDetector(
          onTap: () {
            onTap(apps[index]);
          },
          child: AppDetails(apps[index])));
    }
    return widgets;
  }
}

class AppDetails extends StatelessWidget {
  final AppUsageModel app;
  AppDetails(this.app);
  getBoxDecoration() {
    return BoxDecoration(
        border:
            Border(bottom: BorderSide(width: 1.0, color: Colors.grey[700])));
  }

  @override
  Widget build(BuildContext context) {
    if (app.appName == othersApp) {
      return DecoratedBox(
          decoration: getBoxDecoration(),
          child: ListTile(
            //dense: true,
            contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            // leading: new AppIcon(app.decodedImage),
            title: Text(app.appName,style: TextStyle(color: Colors.white24),),
            subtitle: Text(getSummaryTextFromSeconds(app.usageSeconds)),
            trailing: TotalUsageSummary('', app.totalPercentUSed, 3, 50,
                getColorCodeForSingleAppUsage(app.usageSeconds)),
          ));
    } else {
      return DecoratedBox(
          decoration: getBoxDecoration(),
          child: ListTile(
            //dense: true,
            contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            leading: new AppIcon(app.decodedImage),
            title: Text(app.appName),
            subtitle: Text(getSummaryTextFromSeconds(app.usageSeconds)),
            trailing: TotalUsageSummary('', app.totalPercentUSed, 3, 50,
                getColorCodeForSingleAppUsage(app.usageSeconds)),
          ));
    }
  }
}
