import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';



class TotalUsageSummary extends StatelessWidget {
  final String displayText;
  final double percent;
  final double arcWidth;
  final double arcRadius;
  final Color progressColor;
  final String header;
  TotalUsageSummary(this.displayText, this.percent,this.arcWidth,this.arcRadius,this.progressColor,[this.header=""]);
  @override
  Widget build(BuildContext context) {
    return 
       CircularPercentIndicator(
        header:header.length>0? SizedBox(height: 60, child:
        Center(child: 
        Text(header, style: TextStyle(fontSize: 18))
        )):null,
       
      startAngle: 270.0, radius: this.arcRadius, arcType: ArcType.FULL,
      backgroundColor: Colors.transparent,
      arcBackgroundColor: Colors.grey[500], progressColor: this.progressColor,
      lineWidth:this.arcWidth, animation: true, percent: percent,
      center: new Text(
        displayText,
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue),
      ),
      // footer: new Text(
      //   "Hours used today",
      //   style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      // ),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
