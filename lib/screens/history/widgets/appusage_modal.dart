import 'package:AppsMeter/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/screens/history/history_bloc.dart';

import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/widgets/usage_chart.dart';

class AppUsageScreen extends StatefulWidget {
  String selectedDateRange;
  AppUsageModel app;
  String headerText;
  HistoryBloc appBloc = new HistoryBloc();
  AppUsageScreen(this.selectedDateRange, this.app) {
    //  this.app=widget.app;
    //  this.selectedDateRange=widget.selectedDateRange;
    appBloc.getAppDataPoints(selectedDateRange, app.appPackage);
    headerText = 'Total Usage - ' + getSummaryTextFromSeconds(app.usageSeconds);
  }
  @override
  _AppUsageModalState createState() => _AppUsageModalState();
}

class _AppUsageModalState extends State<AppUsageScreen> {
  //_AppUsageSheetState(this.selectedDateRange, this.app) {
  _AppUsageModalState() {
    Future.delayed(Duration(milliseconds: 1), () {
      setState(() {
        dialogueHeight = MediaQuery.of(context).size.height - 150;
        dialogueWidth = MediaQuery.of(context).size.width - 30;
      });
    });
  }
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

  Widget getMinMaxRow(String label, DateTime dt, double val,Icon icon) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(children: <Widget>[
            Text(
              label,
              style: TextStyle(fontSize: 18, color: Colors.orange[900]),
            ),
            icon,
          ]),
          SizedBox(
            height: 4,
          ),
          Text(
            val.toString() + ' minutes',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
              weekDays[dt.weekday] +
                  ' , ' +
                  dt.day.toString() +
                  ' ' +
                  yearMonths[dt.month],
              style: TextStyle(fontSize: 15, color: Colors.white60)),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: AnimatedContainer(
                curve: Curves.easeInOutCirc,
                duration: Duration(milliseconds: 150),
                color: Colors.grey[900],
                width: dialogueWidth,
                height: dialogueHeight,
                child: Material(
                    child: Container(
                  child: Column(children: <Widget>[
                    StreamBuilder(
                        stream: widget.appBloc.singleAppDataPointObservable,
                        builder: (context,
                            AsyncSnapshot<List<AppDataPoint>> snapshot) {
                          if (snapshot.data != null &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            maxUseDay =
                                snapshot.data[snapshot.data.length - 1].date;
                            minDay = snapshot.data[0].date;
                            return Container(
                                // child: Card(
                                //     color: Colors.transparent,
                                child: Column(children: <Widget>[
                              Container(
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(children: <Widget>[
                                        Text(
                                          widget.headerText,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(9),
                                                        child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.grey[900]
                                                                    .withOpacity(
                                                                        0.6),
                                                            radius: 12,
                                                            child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white54,
                                                                size: 17))))))
                                      ])),
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[900],
                                      Colors.pink[800]
                                    ],
                                  ))),
                              Container(
                                  height: 190,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[900],
                                      Colors.pink[800]
                                    ],
                                  )),
                                  child: UsageChart(snapshot.data,
                                      widget.selectedDateRange, 'mns'))
                            ]));
                          } else {
                            return Padding(
                                padding: EdgeInsets.all(20),
                                child:
                                    SpinKitDoubleBounce(color: Colors.white));
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                        stream: widget.appBloc.singleAppDataPointObservable,
                        builder: (context,
                            AsyncSnapshot<List<AppDataPoint>> snapshot) {
                          if (snapshot.data != null &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            getMinMaxDay(snapshot.data);
                            return Container(
                                padding: EdgeInsets.all(7),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      getMinMaxRow(
                                          'Max usage ', minDay, minUsage,Icon(Icons.keyboard_arrow_up,color: Colors.red,size:30)),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        height: 1,
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[800],
                                                  width: 1)),
                                        ),
                                      ),
                                      getMinMaxRow(
                                          'Min usage ', maxUseDay, maxUsage,Icon(Icons.keyboard_arrow_down,
                                          color: Colors.green,size: 30,))
                                    ]));
                          } else {
                            return SizedBox(height: 10);
                          }
                        })
                  ]),
                )))));
  }
}
