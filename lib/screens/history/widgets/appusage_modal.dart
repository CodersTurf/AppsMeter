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
  _AppUsageModalState();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Container(
            height: 70,
            color: Colors.grey[900],
            child: Row(children: <Widget>[              
              SizedBox(width: 10),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white10,
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Image.memory(
                      widget.app.decodedImage,
                      fit: BoxFit.cover,
                      height: 30,
                      width: 30,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Text(capitalizeText(widget.app.appName),
                  style: TextStyle(color: Colors.pink, fontSize: 20)),
                  Expanded(child:Align(alignment: Alignment.centerRight,child:Padding(padding: EdgeInsets.all(9),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    radius: 13,
                    child:GestureDetector(
                      onTap:(){
                        Navigator.of(context).pop();
                      } ,
                      child: Icon(Icons.close,color:Colors.white54,size:18))))))
            ])),
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
            stream: widget.appBloc.singleAppDataPointObservable,
            builder: (context, AsyncSnapshot<List<AppDataPoint>> snapshot) {
              if (snapshot.data != null &&
                  snapshot.connectionState == ConnectionState.active) {
                return Container(
                    child: Card(
                        color: Colors.transparent,
                        child: Column(children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[700]))),
                              height: 60,
                              padding: EdgeInsets.all(10),
                              //width: double.infinity,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(widget.headerText,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18)))),
                          Container(
                              height: 230,
                              child: UsageChart(
                                  snapshot.data, widget.selectedDateRange,'mns'))
                        ])));
              } else {
                return SpinKitDoubleBounce(color: Colors.white);
              }
            })
      ]),
    );
  }
}
