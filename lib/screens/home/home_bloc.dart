import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/utilities/constants.dart';
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';

class HomeBloc {
  final DataUsageService usageDataRepo = locator<DataUsageService>();
  final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();

  Future<void> format(String val1, double val) async {}

  Future<AppUsageModel> makeAppUsageObject(
      String packageName, double usage) async {
    var packageDetails = await installedAppsService.getAppDetails(packageName);
    AppUsageModel appUsage = AppUsageModel(
        packageDetails.appName, usage, packageDetails.decodedImage);
    return appUsage;
  }

  getUsedAppsForDay(String historyDays) async {
    double totalUsage=0;
    List<dynamic> dateRange = getTodaysDateRange(int.parse(historyDays));
    List<AppUsageModel> apps = new List<AppUsageModel>();
    var allApps = await usageDataRepo.getAppUsage(dateRange[0], dateRange[1]);
    allApps.forEach((obj) {
      totalUsage+=obj.usageSeconds;
      if (obj.usageSeconds > 240 && apps.length < numberOfDisplayApps) {
        apps.add(obj);
      }
    });
    apps.sort((app1, app2) {
      return app2.usageSeconds.compareTo(app1.usageSeconds);
    });
    return [apps,totalUsage];
  }

  dispose() {}
}
