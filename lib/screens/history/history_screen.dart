import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
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
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final NavigationService navService = locator<NavigationService>();
  String _selectedDateRange = appUsageRange.keys.toList()[0];
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

  // showTopApps(AppUsageModel app) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       clipBehavior: Clip.antiAliasWithSaveLayer,
  //       elevation: 8,
  //       builder: (bc) => AppUsageSheet(_selectedDateRange, app));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.show_chart,
              color: Colors.pink,
            ),
            SizedBox(
              width: 10,
            ),
            Text('One Week Usage', style: TextStyle(color: Colors.pink)),
            // Your widgets here
          ],
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Container(
            height: viewportConstraints.maxHeight,
            padding: EdgeInsets.all(0),
            child: StreamBuilder(
                stream: _historyBloc.showLoaderObservable,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      !snapshot.data) {
                    return getMainBody();
                  } else {
                    return SpinKitDoubleBounce(color: Colors.white);
                  }
                }));
      }),
    );
  }

  getMainBody() {
    return SingleChildScrollView(
        child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
          child: Card(
              color: Colors.grey[900],
              //elevation: 4,
              child: StreamBuilder(
                  stream: _historyBloc.appDataPointsAllAppsObservable,
                  builder:
                      (context, AsyncSnapshot<List<AppDataPoint>> snapshot) {
                    if (snapshot.data != null &&
                        snapshot.connectionState == ConnectionState.active) {
                      double totalTime = 0;
                      snapshot.data.forEach((obj) {
                        totalTime += obj.usage;
                      });
                      totalTime = roundtoTwoDigit(totalTime);
                      totalUsageText = "Total usage - $totalTime hrs";
                      return Container(
                          color: Colors.grey[900],
                          child: Column(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[700]))),
                              padding: EdgeInsets.all(15),
                              width: double.infinity,
                              child: Text(
                                totalUsageText,
                                style:
                                    TextStyle(fontSize: 17, color: Colors.blue),
                              ),
                            ),
                            Container(
                                height: 250,
                                child: UsageChart(
                                    snapshot.data, _selectedDateRange, 'hrs'))
                          ]));
                    } else {
                      return SizedBox();
                    }
                  }))),
      SizedBox(
        height: 20,
      ),
      Container(
          child: new StreamBuilder(
              stream: _historyBloc.topAppsUsedObservable,
              builder: (context, AsyncSnapshot<List<AppUsageModel>> snapshot) {
                if (snapshot.data != null &&
                    snapshot.connectionState == ConnectionState.active) {
                  return TopUsedApps(snapshot.data, showAppUsageModal);
                } else {
                  return SizedBox();
                }
              }))
    ])));
  }
}
