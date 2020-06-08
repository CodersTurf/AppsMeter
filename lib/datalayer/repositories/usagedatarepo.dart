
import 'package:usage_stats/usage_stats.dart';

class UsageDataRepo {
  String usageData;
 
  UsageDataRepo() {
    
  }

  // Future<Map<String, double>> getToApps(DateTime startDate, DateTime endDate,
  //     [String appPackage = '']) async {
  //   try {
  //     var apps =
  //         await UsageStats.queryAndAggregateUsageStats(startDate, endDate);
  //     List<UsageInfo> appInfos = new List<UsageInfo>();
  //     apps.forEach((key, value) {
  //       appInfos.add(value);
  //     });
  //     appInfos.sort();
  //   } catch (ex) {
  //     throw ('Error occurred');
  //   }
  // }

  Future<Map<String, double>> getAppUsage(DateTime startDate, DateTime endDate,
      [String appPackage = '']) async {
    try {
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
        if (event.eventType == '23' || event.eventType == '2') {
          if (appInterval.length > 0 &&
              appInterval[appInterval.length - 1].length == 1) {
            //if only it has start time..
            appInterval[appInterval.length - 1].add(int.parse(event.timeStamp));
          }
        }
      });
      Map<String, double> appUsage = new Map<String, double>();
      appIntervals.forEach((key, val) {
        double usedTime = 0;
        var eventsLength = val.length;
        var index = 0;
        val.forEach((interval) {
          index++;
          if (interval.length == 2) {
            usedTime += interval[1] - interval[0];
          } else if (index == eventsLength) {
            usedTime += endDate.millisecondsSinceEpoch - interval[0];
          }
        });
        appUsage[key] = usedTime / 1000;
      });
      return appUsage;
    } catch (exception) {
      throw Exception("Error occured in fetching usage stats");
    }
  }


}
