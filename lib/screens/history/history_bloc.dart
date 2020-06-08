import 'package:AppsMeter/datalayer/models/appdatapoint_model.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:rxdart/rxdart.dart';

class HistoryBloc {
  BehaviorSubject<List<AppDataPoint>> _appDataPointsAllApps =
      new BehaviorSubject<List<AppDataPoint>>();
  BehaviorSubject<List<AppDataPoint>> _singleAppDataPoints =
      new BehaviorSubject<List<AppDataPoint>>();
  BehaviorSubject<bool> _loader = BehaviorSubject.seeded(true);
  Observable<bool> get showLoaderObservable => _loader.stream;
  BehaviorSubject<List<AppUsageModel>> _topAppsUsed =
      new BehaviorSubject<List<AppUsageModel>>();
  Observable<List<AppUsageModel>> get topAppsUsedObservable =>
      _topAppsUsed.stream;

  final DataUsageService usageDataRepo = locator<DataUsageService>();
  int totalReqCompleted = 0;
  Observable<List<AppDataPoint>> get appDataPointsAllAppsObservable =>
      _appDataPointsAllApps.stream;
  Observable<List<AppDataPoint>> get singleAppDataPointObservable =>
      _singleAppDataPoints.stream;
  final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();

  Future<AppUsageModel> makeAppUsageObject(
      String packageName, double usage, double percentUsed) async {
    var packageDetails = await installedAppsService.getAppDetails(packageName);
    AppUsageModel appUsage = AppUsageModel(packageDetails.appName, usage,
        packageDetails.decodedImage, packageName);
    appUsage.totalPercentUSed = percentUsed;
    return appUsage;
  }

  checkAndHideLoader() {
    if (totalReqCompleted == 2) {
      _loader.add(false);
    }
  }

  getTopUsedApps(String range) async {
    List<AppUsageModel> apps = new List<AppUsageModel>();

    var numOfDays = dayCount[range];
    var endDate = DateTime.now();
    var startDate = DateTime(endDate.year, endDate.month, endDate.day);
    for (var index = 0; index < numOfDays; index++) {
      var appData = await usageDataRepo.getAppUsage(startDate, endDate);
      endDate = startDate;
      var startDateExact = startDate.subtract(Duration(days: 1));
      startDate = DateTime(
          startDateExact.year, startDateExact.month, startDateExact.day);
      appData.forEach((obj) {
        if (obj.usageSeconds > 120) {
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
    apps.sort((app1, app2) { 
      return app2.usageSeconds.compareTo(app1.usageSeconds);
    });
    apps.forEach((element) {
       
        element.totalPercentUSed =
            getPercentOfHoursUsed(element.usageSeconds, numOfDays: 1);
      
    });
    totalReqCompleted++;
    checkAndHideLoader();
    addTopAppsToStream(apps);
  }

  addTopAppsToStream(apps) {
    if (_topAppsUsed.isClosed) {
      return;
    }
    _topAppsUsed.add(apps);
  }

  getAppDataPoints(String range, [String package = '']) async {
    List<AppDataPoint> dataPoints = new List<AppDataPoint>();
    var numOfDays = dayCount[range];
    var endDate = DateTime.now();
    var startDate = DateTime(endDate.year, endDate.month, endDate.day);
    for (var index = 0; index < numOfDays; index++) {
      double total = 0;
      var appData =
          await usageDataRepo.getAppUsage(startDate, endDate, package);
      endDate = startDate;
      var startDateExact = startDate.subtract(Duration(days: 1));
      startDate = DateTime(
          startDateExact.year, startDateExact.month, startDateExact.day);
      appData.forEach((obj) {
        total += obj.usageSeconds;
      });
      dataPoints.add(AppDataPoint(
          package == ''
              ? convertSecondToHours(total)
              : convertSecondToMinutes(total),
          endDate));
    }

    totalReqCompleted++;
    checkAndHideLoader();
    if (package == '') {
      _appDataPointsAllApps.add(dataPoints);
    } else {
      _singleAppDataPoints.add(dataPoints);
    }
  }

  dispose() {
    _appDataPointsAllApps.close();
    _topAppsUsed.close();
    _singleAppDataPoints.close();
    _loader.close();
  }
}
