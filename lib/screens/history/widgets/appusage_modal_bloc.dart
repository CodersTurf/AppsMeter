// import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
// import 'package:AppsMeter/datalayer/models/appusage_model.dart';
// import 'package:AppsMeter/datalayer/repositories/usagedatarepo.dart';
// import 'package:AppsMeter/services/installed_apps.dart';
// import 'package:AppsMeter/utilities/constants.dart';
// import 'package:AppsMeter/utilities/helper.dart';
// import 'package:AppsMeter/utilities/servicelocator.dart';
// import 'package:rxdart/rxdart.dart';

// class AppUsageSheetBloc {
//   BehaviorSubject<List<AppUsageModel>> _topAppsUsed =
//       new BehaviorSubject<List<AppUsageModel>>();
//   BehaviorSubject<List<AppDataPoint>> _appDataPoints =
//       new BehaviorSubject<List<AppDataPoint>>();
//   final UsageDataRepo usageDataRepo = locator<UsageDataRepo>();
// final InstalledAppsService installedAppsService = locator<InstalledAppsService>();
//   Observable<List<AppUsageModel>> get topAppsUsedObservable =>
//       _topAppsUsed.stream;

//   Observable<List<AppDataPoint>> get appDataPointsObservable =>
//       _appDataPoints.stream;
//   getTopApps(String selectedDateRange) async {
//     List<AppUsageModel> topAppsUsed = new List<AppUsageModel>();
//     Map<String, double> appUsed = new Map<String, double>();
//     List<dynamic> dateRange =
//         getDateRangeForPastDays(dayCount[selectedDateRange]);
//     appUsed = await usageDataRepo.getAppUsage(dateRange[0], dateRange[1]);
//     if (appUsed != null) {
//       AppUsageModel otherAppUSage = new AppUsageModel(othersApp, 0, null);
//       var keys = appUsed.keys;
//       for (var key in keys) {
//         var timeUsed = appUsed[key];
//         if (timeUsed > 0) {
//           if (timeUsed > 120) {
//             AppUsageModel appUsage = await makeAppUsageObject(key, timeUsed);
//             topAppsUsed.add(appUsage);
//           } else {
//             otherAppUSage.usageSeconds += timeUsed;
//           }
//         }
//       }
//       topAppsUsed.sort((app1, app2) {
//         return app1.usageSeconds.compareTo(app2.usageSeconds);
//       });
//       //others should always be in bottom..
//       if (otherAppUSage.usageSeconds > 0) {
//         topAppsUsed.add(otherAppUSage);
//       }
//       _topAppsUsed.add(topAppsUsed);
//     }
//   }

//   getAppDataPoints(String range, String appPackageName) async {
//     List<AppDataPoint> dataPoints = new List<AppDataPoint>();
//     var numOfDays = dayCount[range];
//     var endDate = DateTime.now();
//     var startDate = DateTime(endDate.year, endDate.month, endDate.day);
//     for (var index = 0; index < numOfDays; index++) {
//       double total = 0;
//       var appData = await usageDataRepo.getAppUsage(startDate, endDate,appPackageName);
//       endDate = startDate;
//       var startDateExact = startDate.subtract(Duration(days: 1));
//       startDate = DateTime(
//           startDateExact.year, startDateExact.month, startDateExact.day);
//       appData.forEach((key, value) {
//         total += value;
//       });
//       dataPoints.add(AppDataPoint(convertSecondToHours(total), endDate));
//     }

//     _appDataPoints.add(dataPoints);
//   }

//   Future<AppUsageModel> makeAppUsageObject(
//       String packageName, double usage) async {
//     var packageDetails = await installedAppsService.getAppDetails(packageName);
//     AppUsageModel appUsage = AppUsageModel(packageDetails.appName, usage,
//         packageDetails.decodedImage, packageName);
//     return appUsage;
//   }

//   dispose() {
//     _topAppsUsed.close();
//     _appDataPoints.close();
//   }
// }
