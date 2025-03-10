import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../toast.dart';

class GeneralMethods {
  static var username = "".obs;
  static var userId = "".obs;
  static var mobileNo = "".obs;
  static var clientId = "".obs;
  static var clientName = "".obs;
  static var companyId = "".obs;
  static var warehouseId = "".obs;
  static var roleId = "".obs;

  static var receiversName = "".obs;
  static var receiversMobileNumber = "".obs;

  final loginController = Get.find<LoginController>();

  Future<void> initConnectivity() async {
    loginController.noInternetCount.value = 0;

    debugPrint(
        "${loginController.connectionStatus.value}-------------------------------------");

    loginController.connectivitySubscription = loginController
        .connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> resultList) {
      updateConnectionStatus(resultList[0]);
    });

    List<ConnectivityResult> result = [ConnectivityResult.none];
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await loginController.connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      debugPrint(" my connectivity error ============= =======  ");
    }

    debugPrint("RESULT $result");
    return updateConnectionStatus(result[0]);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    debugPrint(
        "update connection method called ---------------- status -> $result");
    debugPrint(loginController.connectionStatus.value);
    switch (result) {
      case ConnectivityResult.wifi:
        {
          loginController.connectionStatus.value = result.toString();

          break;
        }
      case ConnectivityResult.mobile:
        {
          loginController.connectionStatus.value = result.toString();
          break;
        }
      case ConnectivityResult.none:
        {
          loginController.connectionStatus.value = result.toString();

          if (loginController.noInternetCount.value == 0 &&
              !loginController.listenFlag) {
            MyToast.myShowToast("Please Check Your Internet Connectivity");
            loginController.listenFlag = false;
            loginController.noInternetCount.value++;
          }
          loginController.listenFlag = false;
          loginController.noInternetCount.value++;
          break;
        }

      default:
        loginController.connectionStatus.value = 'Failed to get connectivity.';
        break;
    }
  }

  askLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      loginController.locationPermission.value = "Denied";
      MyToast.myShowToast("Location Permission Required");
      await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      loginController.locationPermission.value = "Denied";
      MyToast.myShowToast("Location Permission Denied Forever");
      await Geolocator.requestPermission();
    } else {
      loginController.locationPermission.value = "Allowed";
      try {
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        loginController.latitude.value = currentPosition.latitude;
        loginController.longitude.value = currentPosition.longitude;

        debugPrint(
            "Current lat long - ${loginController.latitude.value} , ${loginController.longitude.value}");

        List<Placemark> placeMarkList = await placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude);

        Placemark placeMark = placeMarkList[0];

        debugPrint("Current address is $placeMark");
      } catch (e) {
        debugPrint("Error caught while fetching current location : $e");
      }
    }
  }
}
