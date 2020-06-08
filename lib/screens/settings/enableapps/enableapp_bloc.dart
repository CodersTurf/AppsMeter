import 'package:flutter/foundation.dart';
import 'package:AppsMeter/datalayer/models/appdetails_model.dart';
import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/datalayer/repositories/usagedatarepo.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:AppsMeter/services/localstorage_service.dart';
import 'package:rxdart/rxdart.dart';

List<AppDetailsModel> format(Map data) {
  List<AppDetailsModel> allApps = data['allApps'];
  List<String> disabledApps = data['disabledApps'];
  allApps.sort((app1, app2) {
    return app1.appName.compareTo(app2.appName);
  });
  allApps.forEach((obj) {
    if (disabledApps.contains(obj.appPackage)) {
      obj.active = false;
    }
  });
  return allApps;
}

class EnableAppBloc {
  List<String> disabledApps;
  final LocalStorageService storageService = locator<LocalStorageService>();
  
  final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();
  BehaviorSubject<List<AppDetailsModel>> _allApps =
      new BehaviorSubject<List<AppDetailsModel>>();
  BehaviorSubject<bool> _loader = BehaviorSubject.seeded(true);

  final UsageDataRepo usageDataRepo = locator<UsageDataRepo>();
  Observable<List<AppDetailsModel>> get allAppsObservable => _allApps.stream;
  Observable<bool> get showLoaderObservable => _loader.stream;

  stopLoader() {
    _loader.add(false);
  }

  showLoader() {
    _loader.add(true);
  }

  addRemoveApp(String app, bool isEnabled) async {
    if (isEnabled) {
      disabledApps.removeAt(disabledApps.indexOf(app));
    } else {
      disabledApps.add(app);
    }
    storageService.saveValue('disabledApps', disabledApps);
  }

  getAllApps() async {
    disabledApps = await storageService.getValue('disabledApps');
    var allApps = await installedAppsService.getAllInstalledApps();
    Map map = Map();
    map['allApps'] = allApps;
    map['disabledApps'] = disabledApps;
    var apps = await compute(format, map);
    _allApps.sink.add(apps);
  }

  Future<AppUsageModel> makeAppUsageObject(
      String packageName, double usage) async {
    var packageDetails = await installedAppsService.getAppDetails(packageName);
    AppUsageModel appUsage = AppUsageModel(
        packageDetails.appName, usage, packageDetails.decodedImage);
    return appUsage;
  }

  dispose() {
    _allApps.close();
    _loader.close();
  }
}
