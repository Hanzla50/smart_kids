import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      // Handle message and trigger UI or show a notification banner
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from background: ${message.notification?.title}');
      // Handle background notification actions
    });
    
    // Get FCM token for sending notifications
    String? token = await _firebaseMessaging.getToken();
    print("Firebase Messaging Token: $token");
  }
}
