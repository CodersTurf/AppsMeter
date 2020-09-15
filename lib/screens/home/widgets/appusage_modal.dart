import 'package:AppsMeter/screens/home/home_bloc.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';

import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/widgets/usage_chart.dart';

class AppUsageScreen extends StatefulWidget {
  String selectedDateRange;
  AppUsageModel app;
  String headerText;
  final HomeBloc homeBloc = new HomeBloc();
  AppUsageScreen(this.app) {
    //  this.app=widget.app;
    //  this.selectedDateRange=widget.selectedDateRange;
    homeBloc.getWeeklyAppDataPoints(app.appPackage);
    headerText =
        'Weekly Usage - ' + getSummaryTextFromSeconds(app.usageSeconds);
  }
  @override
  _AppUsageModalState createState() => _AppUsageModalState();
}

class _AppUsageModalState extends State<AppUsageScreen> {
  //_AppUsageSheetState(this.selectedDateRange, this.app) {
  _AppUsageModalState() {}
  double dialogueHeight = 0;
  double dialogueWidth = 0;
  double minUsage = 0;
  double maxUsage = 0;
  DateTime maxUseDay;
  DateTime minDay;
  getMinMaxDay(List<AppDataPoint> data) {
    data.sort((obj1, obj2) {
      return obj2.usage.compareTo(obj1.usage);
    });
    minDay = data[0].date;
    maxUseDay = data[data.length - 1].date;
    minUsage = data[0].usage;
    maxUsage = data[data.length - 1].usage;
  }

  Widget getMinMaxRow(String label, DateTime dt, double val, Icon icon) {
    var totalUsage = val > 60
        ? convertSecondToHours(val * 60).toString() + ' hrs'
        : val.toString() + ' mns';
    return Card(
        child: ListTile(
            //dense: true,
            // contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            title: Text(
              label,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  weekDays[dt.weekday] +
                      ' , ' +
                      dt.day.toString() +
                      ' ' +
                      yearMonths[dt.month],
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                )),
            trailing: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 28),
                child: Text(totalUsage,
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)))));
  }

  getHeader() {
    return Container(
        height: 60,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(children: <Widget>[
              Text(
                widget.headerText,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: EdgeInsets.all(3),
                              child: CircleAvatar(
                                  backgroundColor:
                                      Colors.grey[900].withOpacity(0.4),
                                  radius: 12,
                                  child: Icon(Icons.close,
                                      color: Colors.white54, size: 17))))))
            ])),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.pink[500], Colors.pink[900]],
        )));
  }

  getChart(data) {
    return Container(
        height: 150,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.pink[500], Colors.pink[900]],
        )),
        child: UsageChart(data, 'mns'));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
                color: Colors.grey[900],
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height - 200,
                child: Material(
                    child: Container(
                  child: Column(children: <Widget>[
                    StreamBuilder(
                        stream: widget.homeBloc.dataPointSingleApps,
                        builder: (context,
                            AsyncSnapshot<List<AppDataPoint>> snapshot) {
                          if (snapshot.data != null &&
                              snapshot.data.length > 0 &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            maxUseDay =
                                snapshot.data[snapshot.data.length - 1].date;
                            minDay = snapshot.data[0].date;
                            return Container(
                                // child: Card(
                                //     color: Colors.transparent,
                                child: Column(children: <Widget>[
                              getHeader(),
                              getChart(snapshot.data)
                            ]));
                          } else {
                            return Container(
                                padding: EdgeInsets.all(20),
                                child:
                                    SpinKitDoubleBounce(color: Colors.white));
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    getUsageMessage()
                  ]),
                )))));
  }

  getUsageMessage() {
    return StreamBuilder(
        stream: widget.homeBloc.dataPointSingleApps,
        builder: (context, AsyncSnapshot<List<AppDataPoint>> snapshot) {
          if (snapshot.data != null &&
              snapshot.data.length > 0 &&
              snapshot.connectionState == ConnectionState.active) {
            getMinMaxDay(snapshot.data);
            return Container(
                height: 200,
                padding: EdgeInsets.all(7),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      getMinMaxRow('Max usage ', minDay, minUsage,
                          Icon(Icons.thumb_down, color: Colors.pink, size: 25)),
                      getMinMaxRow(
                          'Min usage ',
                          maxUseDay,
                          maxUsage,
                          Icon(
                            Icons.thumb_up,
                            color: Colors.purple,
                            size: 25,
                          ))
                    ]));
          } else {
            return SizedBox(height: 10);
          }
        });
  }
}
