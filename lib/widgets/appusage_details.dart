// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:AppsMeter/datalayer/models/appusage_model.dart';
// import 'package:AppsMeter/utilities/helper.dart';
// import 'package:AppsMeter/widgets/totalusagesummary.dart';

// import 'appicon.dart';

// class AppDetails extends StatelessWidget {
//   final AppUsageModel app;
//   AppDetails(this.app);
//   getBoxDecoration() {
//     return BoxDecoration(
//         border:
//             Border(bottom: BorderSide(width: 1.0, color: Colors.grey[700])));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (app.appIconByteArray != null && app.appIconByteArray.length > 0) {
//       return DecoratedBox(
//           decoration: getBoxDecoration(),
//           child: ListTile(
//             //dense: true,
//             contentPadding: EdgeInsets.fromLTRB(8, 5, 8, 5),
//             leading: new AppIcon(app.appIconByteArray),
//             title: Text(app.appName),
//             subtitle: Text(getSummaryTextFromSeconds(app.usageSeconds)),
//             trailing: TotalUsageSummary(
//                 '',
//                 getPercentOfHoursUsed(app.totalPercentUSed),
//                 3,
//                 50,
//                 getColorCodeForSingleAppUsage(app.usageSeconds)),
//           ));
//     } else {
//       return Text('Invalid');
//     }
//   }
// }
