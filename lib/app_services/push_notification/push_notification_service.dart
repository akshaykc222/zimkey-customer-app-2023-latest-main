import 'dart:convert';

import 'package:customer/navigation/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  BigPictureStyleInformation? bigPictureStyleInformation;
  final navigatorKey= GlobalKey<NavigatorState>();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Handling a background message ${message.messageId}');
  }


  void handleLocalMessages(NotificationResponse? message){
    if(message==null) return;
    navigatorKey.currentState?.pushNamed(RouteGenerator.homeScreen);
  }


  late AndroidNotificationChannel channel;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  init() async {
    await Firebase.initializeApp();
    final messaging = FirebaseMessaging.instance;
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications',// title
      importance: Importance.high,description:'High Importance Description', // description

    );
    NotificationSettings notificationSettings =
    await messaging.requestPermission(alert: true, badge: true, provisional: false, sound: true);
    String? fcmToken = await messaging.getToken();

    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      const iOS = DarwinInitializationSettings();
      const android = AndroidInitializationSettings('launch_background');
      const initializationSettings = InitializationSettings(android: android, iOS: iOS);
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (notificationResponse) {
          switch (notificationResponse.notificationResponseType) {
            case NotificationResponseType.selectedNotification:
              break;
            case NotificationResponseType.selectedNotificationAction:
              break;
          }
        },
      );
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

        RemoteNotification? notification = message.notification;
        var data = message.data;
        if (message.notification?.android?.imageUrl != null) {
          final http.Response response =
          await http.get(Uri.parse(message.notification!.android!.imageUrl!));
          bigPictureStyleInformation = BigPictureStyleInformation(
              ByteArrayAndroidBitmap.fromBase64String(
                  base64Encode(response.bodyBytes)));
        }
        if(notification !=null){
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  playSound: true,
                  icon: 'launch_background',
                  styleInformation: bigPictureStyleInformation,
                ),
                iOS: const DarwinNotificationDetails()
            ),
          );

        }
      });
    }

  }
}
