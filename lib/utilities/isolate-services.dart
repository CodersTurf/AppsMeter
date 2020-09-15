import 'package:AppsMeter/services/datausage_service.dart';
import 'package:AppsMeter/services/installed_apps.dart';
import 'package:AppsMeter/services/localstorage_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';

loadServicesForIsolates() {
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => InstalledAppsService());
  locator.registerLazySingleton(() => DataUsageService());
}
