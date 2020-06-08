import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
//import 'package:app_usage/app_usage.dart';

class DataUsageService {
  String usageData;
  // AppUsage appUsage;
  final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();
  DataUsageService() {
    // appUsage = new AppUsage();
  }
  Future<bool> checkIfPermissionGranted() async {
    var events = await UsageStats.queryEvents(
        DateTime.now().subtract(Duration(hours: 12)), DateTime.now());
    if (events.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<AppUsageModel>> getAppUsage(DateTime startDate, DateTime endDate,
      [String appPackage = '']) async {
    try {
    
      //just to show permission for app_usage
      //else it wont work..
      //var ak = await appUsage.fetchUsage(DateTime.now(), DateTime.now());
      List<AppUsageModel> appModels = new List<AppUsageModel>();
      // return appModels;
      var events = await UsageStats.queryEvents(startDate, endDate);
     
      var eventStats = events;
      if (appPackage.length > 0) {
        eventStats = events.where((obj) {
          return obj.packageName == appPackage;
        }).toList();
      }
      var apps = eventStats
          .map((obj) {
            return obj.packageName;
          })
          .toSet()
          .toList();
      var eventsD = eventStats
          .map((obj) {
            return obj.eventType;
          })
          .toSet()
          .toList();

      Map<String, List<List<int>>> appIntervals =
          new Map<String, List<List<int>>>();
      apps.forEach((app) {
        appIntervals[app] = List<List<int>>();
      });
      eventStats.forEach((event) {
        //if it is device shut down..
        if (event.eventType == '26') {
          appIntervals.forEach((key, value) {
            value.forEach((val) {
              if (val.length == 1) {
                //add the sutdown time..
                val.add(int.parse(event.timeStamp));
              }
            });
          });
        }
        var appInterval = appIntervals[event.packageName];
        if (event.eventType == '1') {
          appInterval.add(List<int>());
          appInterval[appInterval.length - 1].add(int.parse(event.timeStamp));
        }
        if (event.eventType == '2') {
          if (appInterval.length > 0 &&
              appInterval[appInterval.length - 1].length == 1) {
            //if only it has start time..
            appInterval[appInterval.length - 1].add(int.parse(event.timeStamp));
          }
        }
      });

      for (var index = 0; index < appIntervals.keys.length; index++) {
        var key = appIntervals.keys.toList()[index];
        var val = appIntervals[key];

        var packageDetails = await installedAppsService.getAppDetails(key);
        if (packageDetails != null) {
          var app = AppUsageModel(packageDetails.appName, 0,
              packageDetails.decodedImage, packageDetails.appPackage);
          double usedTime = 0;
          val.forEach((interval) {
            if (interval.length == 2) {
              usedTime += interval[1] - interval[0];
            }
          });
          app.usageSeconds = usedTime / 1000;
          appModels.add(app);
        }
      }
      return appModels;
    } catch (exception) {
      throw Exception("Error occured in fetching usage stats");
    }
  }
}
