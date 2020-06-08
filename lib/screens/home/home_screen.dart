import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:AppsMeter/bloc/appusage_bloc.dart';
import 'package:AppsMeter/datalayer/models/AppPieChartModel.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/screens/home/widgets/daily_summary.dart';
import 'package:AppsMeter/widgets/apppie_chart_legend.dart';

import 'package:AppsMeter/widgets/apps_piechart.dart';
import 'package:AppsMeter/widgets/bottombar.dart';
import 'home_bloc.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NavigationService navService = locator<NavigationService>();
  final HomeBloc homeBloc = new HomeBloc();
  final AppUsageBloc appBloc = new AppUsageBloc();
  final List<String> dailyHeaders = getDailyHeaders();
  _HomeScreenState() {
    getData(_selectedDay);
  }
  getData(String selectedDay) async {
    await appBloc.getUsedAppsForDay(selectedDay);

    homeBloc.stopLoader();
  }

  String _selectedDay = '0';
  getTabs() {
    return List<Tab>.generate(dailyHeaders.length, (index) {
      return Tab(
          child: Text(dailyHeaders[index], style: TextStyle(fontSize: 18)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: dailyHeaders.length,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Colors.pink,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Daily Usage', style: TextStyle(color: Colors.pink)),
                  // Your widgets here
                ],
              ),
              bottom: TabBar(
                unselectedLabelColor: Colors.white38,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    border: Border.all(width: 0, color: Colors.transparent)),
                tabs: getTabs(),
                onTap: (index) {
                  getData(index.toString());
                },
              )),
          body: StreamBuilder(
              stream: homeBloc.showLoaderObservable,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    !snapshot.data) {
                  return LayoutBuilder(builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return Column(children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          color: Colors.grey[800],
                          height: viewportConstraints.maxHeight - 15,
                          child: SingleChildScrollView(
                              child: Center(
                                  child: Column(children: <Widget>[
                            new StreamBuilder(
                                stream: appBloc.topAppsUsedObservable,
                                builder: (context,
                                    AsyncSnapshot<List<AppUsageModel>>
                                        snapshot) {
                                  if (snapshot.data != null &&
                                      snapshot.connectionState ==
                                          ConnectionState.active) {
                                    double usedTime = 0;
                                    snapshot.data.forEach((obj) {
                                      usedTime += obj.usageSeconds;
                                    });
                                    return Container(
                                        child: Card(
                                            color: Colors.grey[900],
                                            child: DailySummary(
                                                usedTime, "Total usage")));
                                  } else {
                                    return Container();
                                  }
                                }),
                            new StreamBuilder(
                                stream: appBloc.topAppsUsedObservable,
                                builder: (context,
                                    AsyncSnapshot<List<AppUsageModel>>
                                        snapshot) {
                                  if (snapshot.data != null &&
                                      snapshot.connectionState ==
                                          ConnectionState.active) {
                                    return new TopApps(snapshot.data);
                                  } else {
                                    return Container();
                                  }
                                }),
                          ]))))
                    ]);
                  });
                } else {
                  return SpinKitDoubleBounce(color: Colors.white);
                }
              }),
        ));
  }

  dispose() {
    super.dispose();
    homeBloc.dispose();
  }
}

class TopApps extends StatelessWidget {
  final List<AppUsageModel> apps;
  TopApps(this.apps);
  getChartData() {
    var data = List<AppPieChartModel>.generate(apps.length, (index) {
      var app = apps[index];
      return AppPieChartModel(
          app.appName,
          "",
          getSummaryTextFromSeconds(app.usageSeconds, pieChartText: true),
          app.usageSeconds,
          pieChartColors[index]);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            elevation: 4,
            color: Colors.grey[900],
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.5, color: Colors.grey[700]))),
                      padding: EdgeInsets.all(15),
                      child: Text('Top Used Apps',
                          style: TextStyle(color: Colors.blue, fontSize: 17))),
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          children: List<Widget>.generate(apps.length, (index) {
                            return AppPieChartLegend(
                                pieChartColors[index], apps[index].appName);
                          }))),
                  AppPieChart(getChartData())
                ])));
  }
}
