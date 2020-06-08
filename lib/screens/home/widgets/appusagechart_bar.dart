import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';

class AppUsageChartBar extends StatefulWidget {
  final List<AppUsageModel> initialData;
  AppUsageChartBar(this.initialData);
  @override
  State<StatefulWidget> createState() => BarChartSample3State(initialData);
   
}

class BarChartSample3State extends State<AppUsageChartBar> {
  final List<AppUsageModel> usageData;
  List<Color> barColors=[
    Colors.red[600],
    Colors.orange[400],
    Colors.pink[300],
    Colors.brown[600],
    Colors.yellow[300],
    Colors.purple[500],
    Colors.cyan[800],
    Colors.indigo[600],    
    Colors.blue,
    Colors.green[500],
    Colors.teal

  ];
  List<BarChartGroupData> barData=new List<BarChartGroupData>();
  BarChartSample3State(this.usageData);
  @override
  void initState() {
    num index=0;
    usageData.forEach((obj)
    {
      barData.add(BarChartGroupData(
                  x: 0,
                  barRods: [BarChartRodData(y: obj.usageSeconds, color: barColors[index++])],
                  showingTooltipIndicators: [0]));
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Card(
        
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.blue,
        child:Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch,children: <Widget>[
          BarChart(
          BarChartData(
            backgroundColor: Colors.red,
            alignment:BarChartAlignment.spaceEvenly,
            maxY: 24,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.y<1?(rod.y*60).toStringAsFixed(1)+ 'min':rod.y.toStringAsFixed(2)+ 'hr',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                rotateAngle: 300,
                textStyle: TextStyle(
                    color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  return usageData[value.toInt()].appName;                  
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups:barData,
          ),
        )]),
      
    );
  }
}