import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:AppsMeter/widgets/curve_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/screens/history/widgets/appusage_modal.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';

import 'package:AppsMeter/widgets/topusedapps.dart';
import 'package:AppsMeter/widgets/usage_chart.dart';

import 'history_bloc.dart';

class HistoryScreen extends StatefulWidget {
  Widget leadingAppBarIcon;
  HistoryScreen(this.leadingAppBarIcon);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final NavigationService navService = locator<NavigationService>();
  String _selectedDateRange = appUsageRange.keys.toList()[0];
  double headerHeight = 70;
  double chartHeight = 210;
  double topAppsHeader = 60;
  double appBArHeight = 180;
  String headerText = 'One Week Usage';
  String totalUsageText = '';
  List<AppDataPoint> appDataPoint = new List<AppDataPoint>();
  HistoryBloc _historyBloc = new HistoryBloc();

  _HistoryScreenState() {
    getTopAppsUsed();
    getUsageData();
  }

  @override
  void dispose() {
    _historyBloc.dispose();
    super.dispose();
  }

  showAppUsageModal(AppUsageModel app) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AppUsageScreen(_selectedDateRange, app));
  }

  getUsageData() {
    _historyBloc.getAppDataPoints(_selectedDateRange);
  }

  getTopAppsUsed() {
    _historyBloc.getTopUsedApps(_selectedDateRange);
  }

  getHeader() {
    return CustomHeader(appBArHeight, headerText, widget.leadingAppBarIcon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(0), child: getMainBody());
    // } else {
    //   return SpinKitDoubleBounce(color: Colors.white);
    // }
    //Z  );
  }

  getMainBody() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.grey[800], Colors.grey[900]],
          )),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.grey[900], Colors.pink[800]],
                )),
                //elevation: 4,
                child: StreamBuilder(
                    stream: _historyBloc.appDataPointsAllAppsObservable,
                    builder:
                        (context, AsyncSnapshot<List<AppDataPoint>> snapshot) {
                      if (snapshot.data != null &&
                          snapshot.data.length > 0 &&
                          snapshot.connectionState == ConnectionState.active) {
                        double totalTime = 0;
                        snapshot.data.forEach((obj) {
                          totalTime += obj.usage;
                        });
                        totalTime = roundtoTwoDigit(totalTime);
                        totalUsageText = "One Week Usage - $totalTime hrs";
                        return Container(
                            child: Column(children: <Widget>[
                          Container(
                            height: headerHeight,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.3, color: Colors.grey[900]))),
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              totalUsageText,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              height: chartHeight,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Colors.grey[700]))),
                              child: UsageChart(
                                  snapshot.data, _selectedDateRange, 'hrs'))
                        ]));
                      } else {
                        return Container(
                            height: chartHeight + headerHeight,
                            child: Container(
                              alignment: Alignment.topCenter,
                                height: headerHeight,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.3,
                                            color: Colors.grey[900]))),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                child: Text(
                                  "One Week Usage",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [Colors.grey[900], Colors.pink[800]],
                            )));
                      }
                    })),
            Container(
                height: topAppsHeader,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[600]))),
                child: ListTile(
                    title: Text(
                  'Top Used Apps',
                  style: TextStyle(color: Colors.pink, fontSize: 18),
                ))),
            Container(
                height: viewportConstraints.maxHeight -
                    (topAppsHeader + chartHeight + headerHeight),
                child: SingleChildScrollView(
                    child: new StreamBuilder(
                        stream: _historyBloc.topAppsUsedObservable,
                        builder: (context,
                            AsyncSnapshot<List<AppUsageModel>> snapshot) {
                          if (snapshot.data != null &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            return TopUsedApps(
                                snapshot.data, showAppUsageModal);
                          } else {
                            return Center(
                              child: SpinKitDoubleBounce(color: Colors.white),
                            );
                          }
                        })))
          ]));
    });
  }
}
