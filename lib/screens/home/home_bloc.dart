import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:flutter/foundation.dart';

import 'package:rxdart/rxdart.dart';

formatDataPoints(Map<String, dynamic> inputs) {
  var total = 0.0;
  inputs['appData'].forEach((obj) {
    total += obj.usageSeconds;
  });
  return AppDataPoint(
      inputs['package'] == ''
          ? convertSecondToHours(total)
          : convertSecondToMinutes(total),
      inputs['endDate']);
}

class HomeBloc {
  List<AppUsageModel> allApps;
  final DataUsageService usageDataRepo = locator<DataUsageService>();
  final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();
  BehaviorSubject<List<AppUsageModel>> _topAppsUsed =
      new BehaviorSubject<List<AppUsageModel>>();
  BehaviorSubject<List<AppDataPoint>> _appDataPointsAllApps =
      BehaviorSubject.seeded([]);
  BehaviorSubject<String> _totalUsage = BehaviorSubject.seeded('');

  BehaviorSubject<List<AppDataPoint>> _singleAppDataPoints =
      BehaviorSubject.seeded([]);

  BehaviorSubject<String> _sortType = BehaviorSubject.seeded("USAGE");
  BehaviorSubject<String> _viewType = BehaviorSubject.seeded("DAILY");
  Observable<List<AppUsageModel>> get topAppsUsedObservable =>
      _topAppsUsed.stream;
  Observable<String> get totalUsedObservable => _totalUsage.stream;
  Observable<String> get sortTypeObservable => _sortType.stream;
  Observable<String> get viewTypeObservable => _viewType.stream;
  Observable<List<AppDataPoint>> get dataPointAllApps =>
      _appDataPointsAllApps.stream;
  Observable<List<AppDataPoint>> get dataPointSingleApps =>
      _singleAppDataPoints.stream;
  Future<void> format(String val1, double val) async {}

  Future<AppUsageModel> makeAppUsageObject(
      String packageName, double usage) async {
    var packageDetails = await installedAppsService.getAppDetails(packageName);
    AppUsageModel appUsage = AppUsageModel(
        packageDetails.appName, usage, packageDetails.decodedImage);
    return appUsage;
  }

  sortApps(String sortBy, bool isIncreasing) {
    if (sortBy == 'NAME') {
      allApps.sort((app1, app2) {
        return isIncreasing
            ? app1.appName.compareTo(app2.appName)
            : app2.appName.compareTo(app1.appName);
      });
    } else {
      allApps.sort((app1, app2) {
        return isIncreasing
            ? app1.usageSeconds.compareTo(app2.usageSeconds)
            : app2.usageSeconds.compareTo(app1.usageSeconds);
      });
    }

    _topAppsUsed.add(allApps);
  }

  changeViewType(String viewType) {
    _viewType.add(viewType);
    var numDays = viewType == 'DAILY' ? 1 : 7;
    if (viewType == 'DAILY') {
      getUsedApps(numDays);
    } else {
      Future.delayed(Duration(milliseconds: 300), () {
        getWeeklyAppDataPoints();
      });
      getUsedApps(numDays);
    }
  }

  getWeeklyAppDataPoints([String package = '']) async {
    List<AppDataPoint> dataPoints = new List<AppDataPoint>();
    var numOfDays = 7;
    var endDate = DateTime.now();
    var startDate = DateTime(endDate.year, endDate.month, endDate.day);
    for (var index = 0; index < numOfDays; index++) {
      var appData =
          await usageDataRepo.getAppUsage(startDate, endDate, package);
      endDate = startDate;
      var startDateExact = startDate.subtract(Duration(days: 1));
      startDate = DateTime(
          startDateExact.year, startDateExact.month, startDateExact.day);
      Map<String, dynamic> inputs = new Map();
      inputs['appData'] = appData;

      inputs['endDate'] = endDate;
      inputs['package'] = package;
      var dataPoint = formatDataPoints(inputs);
      dataPoints.add(dataPoint);
    }

    if (package == '') {
      _appDataPointsAllApps.add(dataPoints);
    } else {
      _singleAppDataPoints.add(dataPoints);
    }
  }

  getUsedApps(int numOfDays) async {
    _topAppsUsed.value = null;
    List<AppUsageModel> apps = new List<AppUsageModel>();
    double totalUsed = 0;
    var endDate = DateTime.now();
    var startDate = DateTime(endDate.year, endDate.month, endDate.day);
    for (var index = 0; index < numOfDays; index++) {
      var appData = await usageDataRepo.getAppUsage(startDate, endDate);
      endDate = startDate;
      var startDateExact = startDate.subtract(Duration(days: 1));
      startDate = DateTime(
          startDateExact.year, startDateExact.month, startDateExact.day);
      appData.forEach((obj) {
        if (obj.usageSeconds > 0) {
          totalUsed += obj.usageSeconds;
          var app =
              apps.where((ap) => ap.appPackage == obj.appPackage).toList();
          if (app == null || app.length == 0) {
            apps.add(obj);
          } else {
            app[0].usageSeconds += obj.usageSeconds;
          }
        }
      });
    }
    if (totalUsed > 60) {
      _totalUsage.add(convertSecondToHours(totalUsed).toString() + ' hours');
    } else {
      _totalUsage
          .add(convertSecondToMinutes(totalUsed).toString() + ' minutes');
    }
    apps.sort((app1, app2) {
      return app2.usageSeconds.compareTo(app1.usageSeconds);
    });
    apps.forEach((element) {
      element.totalPercentUSed =
          getPercentOfHoursUsed(element.usageSeconds, numOfDays: numOfDays);
    });
    allApps = apps;
    if (!_topAppsUsed.isClosed) {
      _topAppsUsed.add(apps);
    }
  }

  changeSorting(sortType, bool isIincreasing) {
    _sortType.add(sortType);
    return Future.delayed(
        Duration(seconds: 0), sortApps(sortType, isIincreasing));
  }

  dispose() {
    _topAppsUsed.close();
    _viewType.close();
    _sortType.close();
  }
}
