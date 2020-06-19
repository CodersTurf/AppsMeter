import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:AppsMeter/datalayer/models/appdetails_model.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

class InstalledAppsService {
  List<AppDetailsModel> apps = new List<AppDetailsModel>();
  List<AppDetailsModel> installedAppspps = new List<AppDetailsModel>();
  Future<List<AppDetailsModel>> getAllApps() async {
    if (apps.length == 0) {
      var allApps = await DeviceApps.getInstalledApplications(
          includeSystemApps: true,
          onlyAppsWithLaunchIntent: true,
          includeAppIcons: true);
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

  Future<List<AppDetailsModel>> getInstalledApps() async {
    if (installedAppspps.length == 0) {
      var allApps = await DeviceApps.getInstalledApplications(
          includeSystemApps: false,
          onlyAppsWithLaunchIntent: true,
          includeAppIcons: true);
      for (var index = 0; index < allApps.length; index++) {
        ApplicationWithIcon app = allApps[index];
        installedAppspps.add(AppDetailsModel(app.appName, app.icon, app.packageName));
      }
    } else {
      installedAppspps = await Future.delayed(Duration(seconds: 0), () {
        return installedAppspps;
      });
    }
    return installedAppspps;
  }

  Future<AppDetailsModel> getAppDetails(String package,
      [bool onlyInstalledApp = false]) async {
    AppDetailsModel app;
    if(package=="com.application.zomato")
    {
      var i=1;
    }
    if (onlyInstalledApp) {
      bool isAppInstalled = await DeviceApps.isAppInstalled(package);
      if (!isAppInstalled) {
        return null;
      }
    }
    var apps = onlyInstalledApp ? await getInstalledApps() : await getAllApps();
    var sApps = apps.where((obj) {
      return obj.appPackage == package;
    }).toList();
    if (sApps != null && sApps.length > 0) {
      return sApps[0];
    }

    return app;
  }

  Future<dynamic> unInstallApp(String appPackage) async {
    var completer = new Completer();
    try {
    android_intent.Intent()
        ..setAction(android_action.Action.ACTION_DELETE)
        ..setData(Uri.parse("package:$appPackage"))
        ..startActivity().then((data) {
         completer.complete(true);
        }, onError: (e) {
           completer.complete(false);
        });
    } catch (err) {
      throw err;
    }
    return completer.future;
  }
}
