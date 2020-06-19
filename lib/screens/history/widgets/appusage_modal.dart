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
        dialogueHeight = MediaQuery.of(context).size.height-150;
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
    data.sort((obj1,obj2){
      return obj2.usage.compareTo(obj1.usage);
    });
    minDay = data[0].date;
    maxUseDay = data[data.length-1].date;
    minUsage = data[0].usage;
    maxUsage = data[data.length-1].usage;
  }

  Widget getMinMaxRow(String label, DateTime dt,double val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      Row(children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 17, color: Colors.pink),
        ),
        Text(
          val.toString()+' minutes',
          style: TextStyle(fontSize: 14, color: Colors.white70),
        )
      ]),
      SizedBox(height: 3,),
       Text(
          weekDays[dt.weekday] +
              ' , ' +
              dt.day.toString() +
              ' ' +
              yearMonths[dt.month],
          style: TextStyle(fontSize: 14, color: Colors.white54)),
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
                    Container(
                        height: 55,
                        color: Colors.grey[800],
                        child: Row(children: <Widget>[
                          SizedBox(width: 10),
                          CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.white10,
                            child: Container(
                                margin: EdgeInsets.all(10),
                                child: Image.memory(
                                  widget.app.decodedImage,
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 40,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(capitalizeText(widget.app.appName),
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18)),
                          Expanded(
                             child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                      padding: EdgeInsets.all(9),
                                      child: CircleAvatar(
                                          backgroundColor: Colors.grey[700],
                                          radius: 13,
                                         
                                              child: Icon(Icons.close,
                                                  color: Colors.white54,
                                                  size: 18))))))
                        ])),
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
                            maxUseDay =
                                snapshot.data[snapshot.data.length - 1].date;
                            minDay = snapshot.data[0].date;
                            return Container(
                                child: Card(
                                    color: Colors.transparent,
                                    child: Column(children: <Widget>[
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color:
                                                          Colors.grey[700]))),
                                          height: 60,
                                          padding: EdgeInsets.all(10),
                                          //width: double.infinity,
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(widget.headerText,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 18)))),
                                      Container(
                                          height: 210,
                                          child: UsageChart(snapshot.data,
                                              widget.selectedDateRange, 'mns'))
                                    ])));
                          } else {
                            return SpinKitDoubleBounce(color: Colors.white);
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      getMinMaxRow('Max usage - ', minDay,minUsage),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        height: 1,decoration: BoxDecoration(
                                       
                                        border: Border(bottom: BorderSide(color: Colors.grey[700],width:1)),
                                      ),),
                                      
                                      getMinMaxRow('Min usage - ', maxUseDay,maxUsage)
                                    ]));
                          } else {
                            return SizedBox(height: 10);
                          }
                        })
                  ]),
                )))));
  }
}
