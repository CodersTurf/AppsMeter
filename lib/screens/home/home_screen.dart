import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:AppsMeter/widgets/curve_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:AppsMeter/datalayer/models/AppPieChartModel.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';

import 'package:AppsMeter/widgets/apppie_chart_legend.dart';

import 'package:AppsMeter/widgets/apps_piechart.dart';

import 'home_bloc.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';

class HomeScreen extends StatefulWidget {
  Widget leadingAppBarIcon;
  HomeScreen(this.leadingAppBarIcon);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NavigationService navService = locator<NavigationService>();
  final HomeBloc homeBloc = new HomeBloc();
  double appBArHeight = 180;
  List<AppUsageModel> apps;
  final List<String> dailyHeaders = getDailyHeaders();
  _HomeScreenState() {
    getData(_selectedDay);
  }

  getData(String selectedDay) async {
    var usageData = await homeBloc.getUsedAppsForDay(selectedDay);
    apps = usageData[0];
    var usage = getSummaryTextFromSeconds(usageData[1]);
    headerText = headerText+"- $usage";
    setState(() {});
  }

  String headerText="Today's usage";
  String _selectedDay = '0';
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
            Container(),
            getHeader(),
            apps==null?SpinKitDoubleBounce(color: Colors.white): Positioned(
                top: appBArHeight - 90,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Container(
                        height:
                            MediaQuery.of(context).size.height - appBArHeight,
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: TopApps(apps))))
          ]);
  }

  getHeader() {
    return CustomHeader(appBArHeight, headerText, widget.leadingAppBarIcon);
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
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        color: Colors.grey[800].withOpacity(0.8),
        child: SingleChildScrollView(
            child: apps.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.grey[700]))),
                            padding: EdgeInsets.all(15),
                            child: Row(children: <Widget>[
                              Text('Top Used Apps',
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 18)),
                              SizedBox(
                                width: 10,
                              ),
                              Tooltip(
                                preferBelow: false,
                                message: 'Usage time > 4mins',
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.orange,
                                  size: 23,
                                ),
                              )
                            ])),
                        Padding(padding: EdgeInsets.all(10)),
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                children:
                                    List<Widget>.generate(apps.length, (index) {
                                  return AppPieChartLegend(
                                      pieChartColors[index],
                                      apps[index].appName);
                                }))),
                        AppPieChart(getChartData())
                      ])
                : Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(50),
                    child: Center(
                        child: Text(
                      'Data not available',
                      style: TextStyle(fontSize: 17, color: Colors.pink),
                    )),
                  )));
  }
}
