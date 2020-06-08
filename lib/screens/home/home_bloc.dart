import 'package:AppsMeter/datalayer/models/appusage_model.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {

  BehaviorSubject<String> _headerMenuChanged = new BehaviorSubject<String>();
  BehaviorSubject<bool> _loader =BehaviorSubject.seeded(true);
 final InstalledAppsService installedAppsService =
      locator<InstalledAppsService>();
   
  Observable<String> get headerMenuObservable => _headerMenuChanged.stream;
  Observable<bool> get showLoaderObservable => _loader.stream;
  changeHeaderMenu(String index) {
    _headerMenuChanged.add(index);
  }
 
  stopLoader() {
    _loader.add(false);
    
  }

  Future<void> format(String val1, double val) async {}

  Future<AppUsageModel> makeAppUsageObject(
      String packageName, double usage) async {
    var packageDetails = await installedAppsService.getAppDetails(packageName);
    AppUsageModel appUsage = AppUsageModel(
        packageDetails.appName, usage, packageDetails.decodedImage);
    return appUsage;
  }

  dispose() {
    _headerMenuChanged.close();
    _loader.close();
  }
}
