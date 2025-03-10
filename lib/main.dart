import 'dart:io';

import 'package:abhilaya/controller/auth_controller/change_password_controller.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/auth_controller/logout_controller.dart';
import 'package:abhilaya/controller/auth_controller/signup_controller.dart';
import 'package:abhilaya/controller/dashboard_routes_controller/delivery_location_controller.dart';
import 'package:abhilaya/controller/dashboard_routes_controller/undelivered_loaction_controller.dart';
import 'package:abhilaya/controller/drawer_routes_controller/bulkpickup_controller.dart';
import 'package:abhilaya/controller/drawer_routes_controller/ndr_delivery_controller.dart';
import 'package:abhilaya/controller/drawer_routes_controller/returnpickup_controller.dart';
import 'package:abhilaya/controller/drawer_routes_controller/sticker_controller.dart';
import 'package:abhilaya/controller/force_update_controller.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/drawer_routes/insurance_details_controller.dart';
import 'package:abhilaya/view/splash/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/dashboard_controller.dart';
import 'controller/drawer_routes_controller/nprShipment_controller.dart';
import 'controller/notification_controller.dart';
import 'firebase_options.dart';
import 'utils/general/shared_preferences_keys.dart';

Future<void> main() async {
  await ScreenUtil.ensureScreenSize();

  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences? _preferences = await SharedPreferences.getInstance();
  FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance; // Change here
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  _firebaseMessaging.getToken().then((token) {
    print("fcm token is=-=- $token");

    _preferences.setString(Strings.fcmToken, token!);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  configureFirebaseMessaging();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.deepOrange.shade500, // navigation bar color
    statusBarColor: Colors.black, // status bar color
  ));
  Get.put(LoginController());
  Get.put(ForceUpdateController());
  Get.put(LogoutController());
  Get.put(ChangePasswordController());
  Get.put(NDRDeliveryController());
  Get.put(SignupController());
  Get.put(DashboardController());
  Get.put(NavigationController());
  Get.put(NotificationController());
  Get.put(NprShipmentsController());
  Get.put(DeliveryLocationController());
  Get.put(UndeliveredLocationController());
  Get.put(BulkPickUpController());
  Get.put(ReturnPickupController());
  Get.put(StickerController());
  Get.put(InsuranceDetailsController());

  /// Run app
  runApp(
    /// Device preview for all devices
    DevicePreview(
      enabled: false,
      builder: (context) => (

          /// ProviderScope for state management
          const MyApp()),
    ),
  );
}

void configureFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    print("Received message in foreground: ${message.notification?.title}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notification clicked: ${message.notification?.title}");
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    configureFirebaseMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFF9B55),
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ScreenUtilInit(
      designSize: const Size(360, 812),
      child: GetMaterialApp(
        supportedLocales: const [Locale('en', 'GB')], // Use GB locale for dd/MM/yyyy
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Abhilaya',
        theme: ThemeData(
          useMaterial3: false,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.deepOrange.shade500),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
