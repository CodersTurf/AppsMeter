import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      //cwkD5521Qq-Z1BIHtYuMnZ:APA91bHfAeNTuTZl4oMrFWx1MW2h3czSz0SIQmJyXnD3Ezp4BHENiHUu_KuI8UbI3Uuf2JKhY0Ru3LtHvpk7trI2dEkiZoZS_zfINcx7o9LHQjGJ_uv9xAb2bSoABPNkFJDZBphRm3Z4

      _initialized = true;
    }
  }
}
