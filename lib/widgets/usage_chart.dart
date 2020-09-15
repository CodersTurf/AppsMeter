import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
import 'package:AppsMeter/utilities/constants.dart';

class UsageChart extends StatelessWidget {
  DateTime fromDate;
  String label;
  BezierChartScale scale;
  final toDate = DateTime.now();
  final List<AppDataPoint> usageData;
  List<DataPoint<DateTime>> dataPoints;
  UsageChart(this.usageData, this.label) {
    scale = BezierChartScale.WEEKLY;

    dataPoints = List<DataPoint<DateTime>>.generate(usageData.length, (index) {
      var appData = usageData[index];
      return new DataPoint(value: appData.usage, xAxis: appData.date);
    });
    fromDate = dataPoints[dataPoints.length - 1].xAxis;
  }
  @override
  Widget build(BuildContext context) {
    return BezierChart(
        // footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
        //   final newFormat = intl.DateFormat('dd/MMM', "bg_BG");
        //   return newFormat.format(value);
        // },
        // bubbleLabelDateTimeBuilder:
        //     (DateTime value, BezierChartScale scaleType) {
        //   return "22";
        // },
        // bubbleLabelValueBuilder: (data) {
        //   return 'test123';
        // },
        fromDate: fromDate,
        bezierChartScale: scale,
        toDate: toDate,
        selectedDate: toDate,
        series: [
          BezierLine(
            lineColor: Colors.white,
            label: label,
            onMissingValue: (dateTime) {
              return 0;
            },
            data: dataPoints,
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.white,
          showVerticalIndicator: true,
          showDataPoints: true,
          // displayYAxis: true,
          stepsYAxis: 1,
          verticalIndicatorFixedPosition: false,
          // backgroundColor: Colors.red,
          // footerHeight: 40.0,
          //backgroundColor: Colors.grey[900],
          // footerHeight: 30.0,
        ));
  }
}
