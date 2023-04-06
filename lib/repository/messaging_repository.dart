import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingRepository {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> getPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String?> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }
}
