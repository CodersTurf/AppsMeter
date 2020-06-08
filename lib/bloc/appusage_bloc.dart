import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/services/localstorage_service.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:rxdart/rxdart.dart';

class AppUsageBloc {
  BehaviorSubject<List<AppUsageModel>> _topAppsUsed =
      new BehaviorSubject<List<AppUsageModel>>();
  final DataUsageService usageDataRepo = locator<DataUsageService>();
  final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();
  final LocalStorageService storageService = locator<LocalStorageService>();
  Observable<List<AppUsageModel>> get topAppsUsedObservable =>
      _topAppsUsed.stream;

  getUsedAppsForDay(String historyDays) async {
       List<dynamic> dateRange = getTodaysDateRange(int.parse(historyDays));
    List<AppUsageModel> apps = new List<AppUsageModel>();
    var allApps = await usageDataRepo.getAppUsage(dateRange[0], dateRange[1]);
    allApps.forEach((obj) {
      if (obj.usageSeconds > 120 &&apps.length<numberOfDisplayApps) {
        apps.add(obj);
      }
    });
     apps.sort((app1, app2) {
        return app2.usageSeconds.compareTo(app1.usageSeconds);
      });
    _topAppsUsed.add(apps);

  }

  Future<void> format(String val1, double val) async {}

  Future<AppUsageModel> makeAppUsageObject(
      String packageName, double usage) async {
    var packageDetails = await installedAppsService.getAppDetails(packageName);
    if (packageDetails != null) {
      AppUsageModel appUsage = AppUsageModel(
          packageDetails.appName, usage, packageDetails.decodedImage);
      return appUsage;
    } else {
      return null;
    }
  }

  // getUsageSummary(UsageDateRange range) async {
  //   double totalUsed = 0;
  //   List<dynamic> dateRange = getDateRange(range);
  //   var appUsed = await usageDataRepo.getAppUsage(dateRange[0], dateRange[1]);
  //   if (appUsed != null) {
  //     appUsed.forEach((key, value) {
  //       totalUsed += value;
  //     });
  //   }
  //   _appUsageSummary.add(totalUsed);
  // }

  dispose() {
    _topAppsUsed.close();
  }
}
