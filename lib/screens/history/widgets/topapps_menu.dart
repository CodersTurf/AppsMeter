import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/widgets/appicon.dart';

class TopAppsMenu extends StatelessWidget {
  final List<AppUsageModel> apps;
  final Function(String package) onTap;
  TopAppsMenu(this.apps, [this.onTap = null]);
  @override
  Widget build(BuildContext context) {
    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: List<Widget>.generate(apps.length, (index) {
        var key = apps[index].appName;
        var text = apps[index].appName;
        return GestureDetector(
            onTap: () {
              onTap(key);
            },
            child: Container(
                width: 130.0,
               
                child: 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    apps[index].decodedImage!=null?  Image.memory(
                        apps[index].decodedImage,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ):Text('A'),
                     Flexible(child: Text(text,overflow: TextOverflow.ellipsis))
                    ],
                  )
                ));
      }),
    );
  }
}
