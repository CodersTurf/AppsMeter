import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/services/localstorage_service.dart';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'datalayer/repositories/usagedatarepo.dart';

class BootStrapper {
  static void initializeDIs() {
    locator.registerSingleton<UsageDataRepo>(UsageDataRepo());
    locator.registerLazySingleton(() => NavigationService());
    locator.registerLazySingleton(() => LocalStorageService());
    locator.registerLazySingleton(() => InstalledAppsService());
    locator.registerLazySingleton(() => DataUsageService());
    
  }
}
