import 'package:AppsMeter/screens/default_screen.dart';
import 'package:AppsMeter/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:AppsMeter/bootstrapper.dart';
import 'package:AppsMeter/config.dart';
import 'package:AppsMeter/routegenerator.dart';
import 'package:AppsMeter/screens/permission/permission_error.dart';
import 'package:AppsMeter/services/localstorage_service.dart';
import 'package:AppsMeter/services/navigation_service.dart';
import 'package:AppsMeter/utilities/servicelocator.dart';
import 'package:usage_stats/usage_stats.dart';

void main() {
  BootStrapper.initializeDIs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int appUsagePerm = 0;
  var storageService = locator<LocalStorageService>();
  Future<void> checkForUpdate() async {
    var isLocalUpdateExist = await storageService.getBoolValue('InAppUpdate');
    if (isLocalUpdateExist == true) {
      performUpdate();
    } else {
      InAppUpdate.checkForUpdate().then((info) {
        if (info?.updateAvailable == true) {
          downloadUpdate();
        }
      }).catchError((e) => showError);
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkAppPerm();
    }
  }

  showAppUsagePermWarning() {}
  checkAppPerm() async {
    var perm = await UsageStats.checkUsagePermission();
    if (perm) {
      appUsagePerm = 1;
    } else {
      if (appUsagePerm == 0) {
        await askPermission();
      }
    }
    setState(() {});
  }

  askPermission() async {
    appUsagePerm = -1;
    await UsageStats.grantUsagePermission();
  }

  downloadUpdate() {
    InAppUpdate.startFlexibleUpdate().then((value) {
      storageService.saveKeyPairBoolValue('InAppUpdate', true);
      performUpdate();
    }).catchError((e) => showError);
  }

  performUpdate() {
    InAppUpdate.completeFlexibleUpdate()
        .then((value) =>
            storageService.saveKeyPairBoolValue('InAppUpdate', false))
        .catchError((e) => showError);
  }

  showError(ex) {
    Future.delayed(Duration(seconds: 15), () {
      locator<NavigationService>().navigateTo('Error', ex.error);
    });
  }

  Widget getScreen() {
    if (appUsagePerm == 1) {
      return DefaultScreen();
    } else if (appUsagePerm == -1) {
      appUsagePerm = 0;
      return PermissionError();
    }
    return DefaultScreen();
  }

  @override
  void initState() {
    super.initState();
    checkAppPerm();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Config.appMode != 'debug') {
        checkForUpdate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppsMeter',
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(
        brightness: Brightness.dark,

        accentColor: Colors.white,
        dividerColor: Colors.black12,
        accentIconTheme: IconThemeData(color: Colors.black),
        // primarySwatch: Colors.purple,
      ),
      home: getScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
