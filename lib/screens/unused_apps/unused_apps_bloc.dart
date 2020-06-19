import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
 
import 'package:AppsMeter/utilities/helper.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:rxdart/rxdart.dart';
class UnUsedAppBloc {
  BehaviorSubject<List<AppUsageModel>> _unUsedApps =
      new BehaviorSubject<List<AppUsageModel>>();
  Observable<List<AppUsageModel>> get unusedAppsObservable =>
      _unUsedApps.stream;
  final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();
  final DataUsageService usageDataRepo = locator<DataUsageService>();
  unInstallApp(String package) async
  {
    await installedAppsService.unInstallApp(package);
  }
  getUnUsedApps() async {
    List<AppUsageModel> apps ;
    var dateRange = getDateRangeForPastDays(7);
    apps = await usageDataRepo.getUnUsedApps(dateRange[0], dateRange[1]);
    apps.sort((app1, app2) {
      return app2.usageSeconds.compareTo(app1.usageSeconds);
    });
    return apps;
  }

  dispose() {
    _unUsedApps.close();
  }
}
