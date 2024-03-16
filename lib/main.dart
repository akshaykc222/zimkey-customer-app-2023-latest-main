import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_services/push_notification/notification.dart';
import 'data/observer/app_bloc_observer.dart';
import 'firebase_options.dart';
import 'utils/object_factory.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Firebase.apps.isEmpty) {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print(e);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationService().init();
  // }
  // registerNotification();
  await initHiveForFlutter();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  ObjectFactory().setPrefs(sharedPreferences);
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late AndroidNotificationChannel channel;
BigPictureStyleInformation? bigPictureStyleInformation;

void registerNotification() async {
  final messaging = FirebaseMessaging.instance;

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    description: 'High Importance Description', // description
  );
  NotificationSettings notificationSettings = await messaging.requestPermission(
      alert: true, badge: true, provisional: false, sound: true);
  String? fcmToken = await messaging.getToken();
  print(fcmToken);
  if (notificationSettings.authorizationStatus ==
      AuthorizationStatus.authorized) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('launch_background');
    const initializationSettings =
        InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print("dldvldklndlnvkdnvk");
            break;
          case NotificationResponseType.selectedNotificationAction:
            break;
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      var data = message.data;
      print("received notification");
      if (message.notification?.android?.imageUrl != null) {
        final http.Response response =
            await http.get(Uri.parse(message.notification!.android!.imageUrl!));
        bigPictureStyleInformation = BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
                base64Encode(response.bodyBytes)));
      }
      if (notification != null) {
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
              iOS: const DarwinNotificationDetails()),
        );
      }
    });
  }
}
