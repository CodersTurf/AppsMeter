import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      //private constructor.. with _ can be called from inside only for initialization
  LocalNotificationManager._internal(){
    
  }
  cancelAllNotifications() async
  {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  //since its static, can be called only once in class initialization..
  static final LocalNotificationManager instance = LocalNotificationManager._internal();
  factory LocalNotificationManager() => instance;
  Future<void> createNotificationChannel() async {
    var androidNotificationChannel = AndroidNotificationChannel(
      'appsmeter_default', // channel ID
      'Appsmeter default channel', // channel name
      'Appsmeter channel for receiving public notifications', //channel description
      importance: Importance.High,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }
}
