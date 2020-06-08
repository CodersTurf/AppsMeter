import 'package:device_apps/device_apps.dart';
import 'package:AppsMeter/datalayer/models/appdetails_model.dart';

class InstalledAppsService {
  List<AppDetailsModel> apps = new List<AppDetailsModel>();
  Future<List<AppDetailsModel>> getAllInstalledApps() async {
    if (apps.length == 0) {
      var allApps = await DeviceApps.getInstalledApplications(includeSystemApps: true,
          onlyAppsWithLaunchIntent: true, includeAppIcons: true);
      for (var index = 0; index < allApps.length; index++) {
        ApplicationWithIcon app = allApps[index];
        apps.add(AppDetailsModel(app.appName, app.icon, app.packageName));
      }
    } else {
      apps = await Future.delayed(Duration(seconds: 0), () {
        return apps;
      });
    }
    return apps;
  }
  Future<AppDetailsModel> getAppDetails(String package) async {
    var apps = await getAllInstalledApps();
    var sApps = apps.where((obj) {
      return obj.appPackage == package;
    }).toList();
    if (sApps != null && sApps.length > 0) {
      if (sApps[0].appName.contains('PUBG')) {
        var i = 1;
      }
      return sApps[0];
    } else {
      return null;
    }
  }
}
