import 'dart:convert';
import 'dart:typed_data';
import 'package:alphabet/screens/home/homepage_navigator.dart';
import 'package:alphabet/screens/view_news.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

final AndroidNotificationChannel androidChannel =
    const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.high,
);

// Setup Firebase for push notifications and permissions
Future<void> setupPushNotifications() async {
  final fcm = FirebaseMessaging.instance;

  await fcm.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  final token = await fcm.getToken();
  print("FCM Token: $token");
  fcm.subscribeToTopic("ALL");

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  initNotifications();
  initLocalNotification();
}

// Initialization of local notifications
Future<void> initLocalNotification() async {
  const AndroidInitializationSettings android =
      AndroidInitializationSettings('@drawable/ic_launcher');
  const DarwinInitializationSettings iOS = DarwinInitializationSettings();
  const InitializationSettings settings =
      InitializationSettings(android: android, iOS: iOS);

  await _localNotifications.initialize(settings,
      onDidReceiveNotificationResponse: (payload) {
    final message = RemoteMessage.fromMap(jsonDecode(payload as String));
    handleMessage(message);
  });

  final platform = _localNotifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await platform?.createNotificationChannel(androidChannel);
}

// Function to handle background messages
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background Message: ${message.notification?.title}');
}

// Function for handling notifications
void handleMessage(RemoteMessage? message) {
  if (message == null) return;

  final data = message.data;
  Get.to(() => HomepageNavigator());
  Get.to(() => ViewNewsScreen(url: data["news_url"]));
}

// Function to show notification with image
Future<void> _showNotificationWithImage(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  final imageUrl = message.data['image_url'];
  print('Notification Title: ${notification.title}');
  print('Notification Body: ${notification.body}');
  print('Image URL: $imageUrl');

  Uint8List? bigPicture;
  if (imageUrl != null) {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        bigPicture = response.bodyBytes;
      } else {
        print('Failed to fetch image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notification image: $e');
    }
  }

  BigPictureStyleInformation bigPictureStyle;
  if (bigPicture != null) {
    bigPictureStyle = BigPictureStyleInformation(
      ByteArrayAndroidBitmap(bigPicture),
      contentTitle: notification.title,
      summaryText: notification.body,
    );
  } else {
    bigPictureStyle = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap('@drawable/ic_launcher'), // Fallback image
      contentTitle: notification.title,
      summaryText: notification.body,
    );
  }

  _localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        androidChannel.id,
        androidChannel.name,
        channelDescription: androidChannel.description,
        importance: Importance.high,
        styleInformation: bigPictureStyle,
      ),
    ),
    payload: jsonEncode(message.toMap()),
  );
}

// Firebase Messaging Initialization
Future<void> initNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onMessage.listen((message) {
    _showNotificationWithImage(message);
  });
}
