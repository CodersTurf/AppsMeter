import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/widgets/totalusagesummary.dart';

class DailySummary extends StatelessWidget {
  final double usageSeconds;
  final String headerText;
  DailySummary(this.usageSeconds, this.headerText);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        // decoration: BoxDecoration(gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //       colors: [Colors.blue, Colors.red]),),
        child: Row(children: <Widget>[
          Card(
              color: Colors.grey[900],
              elevation: 9,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15)),
                  ),
              child:Padding(padding: EdgeInsets.all(10),child: TotalUsageSummary(
                  getSummaryTextFromSeconds(usageSeconds),
                  getPercentOfHoursUsed(usageSeconds),
                  10,
                  110,
                  getColorCodeForAllAppUsage(usageSeconds),
                  ""))),
                  SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            Text(
              headerText,
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            SizedBox(height: 7,),
            Text(getSummaryTextFromSeconds(usageSeconds),            
              style: TextStyle(color: Colors.white60, fontSize: 15))
          ])
        ]));
  }
}
