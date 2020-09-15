import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/services/localstorage_service.dart';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';

class BootStrapper {
  static void initializeDIs() {
    locator.registerLazySingleton(() => NavigationService());
    locator.registerLazySingleton(() => LocalStorageService());
    locator.registerLazySingleton(() => InstalledAppsService());
    locator.registerLazySingleton(() => DataUsageService());
  }
}
