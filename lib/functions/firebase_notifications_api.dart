@pragma('vm:entry-point')
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _localNotifications = FlutterLocalNotificationsPlugin();

//this function is used for handleing background notifications for Android,
Future<void> handleBackgroudMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('PayLoad: ${message.data}');
}

final androidchannel = const AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: 'This channel is used for important notification ',
    importance: Importance.defaultImportance);
// Function for Sending to selected page from notifications
void handleMessage(RemoteMessage? message) {
  if (message == null) {
    return;
  }
}

Future initLocalNotification() async {
  const android = AndroidInitializationSettings('@drawable/ic_launcher');
  const iOS = DarwinInitializationSettings();
  const settings = InitializationSettings(android: android, iOS: iOS);
  await _localNotifications.initialize(settings,
      onDidReceiveNotificationResponse: (payload) {
    final message = RemoteMessage.fromMap(jsonDecode(payload as String));
    handleMessage(message);
  });
  final platform = _localNotifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await platform?.createNotificationChannel(androidchannel);
}

Future initNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroudMessage);
  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) {
      return;
    }

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidchannel.id,
          androidchannel.name,
          channelDescription: androidchannel.description,
        ),
      ),
      payload: jsonEncode(message.toMap()),
    );
  });
}

//function for firebase and asking for persmission of notifications,
void setupPushNotifications() async {
  final fcm = FirebaseMessaging.instance;

  await fcm.requestPermission();
  final token = await fcm.getToken();
  print("Token : $token");

  fcm.subscribeToTopic("ALL");

  FirebaseMessaging.onBackgroundMessage(handleBackgroudMessage);
  initNotifications();
  initLocalNotification();
}
