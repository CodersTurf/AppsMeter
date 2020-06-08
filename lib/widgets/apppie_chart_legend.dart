import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AppsMeter/utilities/helper.dart';

class AppPieChartLegend extends StatelessWidget {
  String text;
  Color color;
  AppPieChartLegend(this.color, this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: new BoxDecoration(
               color:Colors.grey[800],
              borderRadius: new BorderRadius.circular(40
              )
            ),
      padding: EdgeInsets.fromLTRB(4, 0,0,0),
      height:30,
     // clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.fromLTRB(0,0,3,5),
     
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      CircleAvatar(radius: 7,backgroundColor: color,),
      Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0)),
      Text(capitalizeText(text),
          style: TextStyle(fontSize: 16, color: Colors.white)),
      Padding(padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
    ]));
  }
}
