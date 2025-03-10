import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'dart:io';

class NotificationPlugin {
  //
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  IOSFlutterLocalNotificationsPlugin? flutterIosLocalNotificationsPlugin;
  var initializationSettings;

  NotificationPlugin() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    // initializationSettingsIos = IOs
    initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin?.initialize(initializationSettings);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: false,
      badge: true,
      sound: true,
    );
  }

  Future<void> showNotification() async {
    var androidChannelSpecifics = const AndroidNotificationDetails(
      '0',
      'CHANNEL_NAME',
      category: AndroidNotificationCategory.locationSharing,
      channelDescription: "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      indeterminate: true,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
      playSound: true,
      // timeoutAfter: 5000,
      icon: '@mipmap/ic_launcher',
      autoCancel: false,
      visibility: NotificationVisibility.public,

      ongoing: true,

      styleInformation: DefaultStyleInformation(true, true),
    );
    // var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
    NotificationDetails(android: androidChannelSpecifics);
    List<ActiveNotification>? notifications =
    await flutterLocalNotificationsPlugin?.getActiveNotifications();
    if (notifications
        ?.where((element) => element.id == 0 && element.channelId == '0')
        .isEmpty ??
        false) {
      await flutterLocalNotificationsPlugin?.show(
        0,
        'Abhilaya',
        "Abhilaya is using your device's location", //null
        platformChannelSpecifics,
        payload: 'New Payload',
      );
    }
  }

  clear() async {
    List<ActiveNotification>? notifications =
    await flutterLocalNotificationsPlugin?.getActiveNotifications();
    if (notifications
        ?.where((element) => element.id == 0 && element.channelId == '0')
        .isEmpty ??
        false) {
      await flutterLocalNotificationsPlugin?.cancel(0);
    }
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}