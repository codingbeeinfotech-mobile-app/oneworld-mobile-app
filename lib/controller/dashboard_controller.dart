import 'dart:async';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/notification_controller.dart';
import 'package:abhilaya/model/request_model/dashboard_request.dart';
import 'package:abhilaya/model/request_model/driver_status_request.dart';
import 'package:abhilaya/model/request_model/duty_status_request.dart';
import 'package:abhilaya/model/response_model/dashboard_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/request_model/notification_request.dart';
import '../model/response_model/driver_status_response.dart';
import '../model/response_model/duty_status_response.dart';
import '../model/response_model/notification_response.dart';
import 'notification_plugin.dart';

class DashboardController extends GetxController {
  Timer? timer;
  Rx<Duration> time = Duration(seconds: 0).obs;
  var loginController = Get.find<LoginController>();
  var isOnDuty = false.obs;
  var isLocationFetched = false.obs;
  var isDutyFetched = false.obs;
  var loading = true.obs;
  // DashboardResponse? dashboardResponse;
  FocusNode dutySwitchFocusNode = FocusNode();
  var dashboardResponse = Rx<DashboardResponse?>(null);
  var dutyStatusResponse = Rx<DutyStatusResponse?>(null);
  var driverStatusResponse = Rx<DriverStatusResponse?>(null);
  Rx<Duration> workingTime = Rx<Duration>(const Duration());

  callDashboardApi() async {
    DashboardRequest req = DashboardRequest(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        driverId: int.parse(loginController.loginResponse!.uSERID),
        vendorId: "",
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID));

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.dashboard, req, "");
    if (response != null) {
      debugPrint(
          "Dashboard Response ${loginController.loginResponse!.cLIENTID} ${loginController.loginResponse!.wAREHOUSEID} ${loginController.loginResponse!.cLIENTNAME} ${loginController.loginResponse!.cOMPANYID} ${loginController.loginResponse!.uSERID}");
      dashboardResponse.value = DashboardResponse.fromJson(response);
      print("ashboard Response Received ${dashboardResponse}");
    }
  }

  callDutyStatusApi() async {
    double isourseLat = 28.599189;
    double isourseLong = 77.0360246;
    DateTime currentDetails = DateTime.now();
    debugPrint("Current time ${formatTime(currentDetails)}");
    debugPrint("Current Date ${formatDate(currentDetails)}");
    debugPrint("Duty Status ${isOnDuty.value ? "1" : "0"}");
    int status = isOnDuty.value ? 1 : 0;
    debugPrint("Sent Duty Status $status ");
    DutyStatusRequest dutyStatusRequest = DutyStatusRequest(  driverId: int.parse(loginController.loginResponse!.uSERID),
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID),
        entryDate: formatDate(currentDetails),
        entryTime: formatTime(currentDetails),
        latitude: loginController.latitude.value == 0.0
            ? isourseLat
            : loginController.latitude.value ,
        longitude: loginController.longitude.value == 0.0
            ? isourseLong
            : loginController.longitude.value ,
        dutyStatus: status,
         isActivity: "",
      );

    debugPrint("Sent json ${dutyStatusRequest.toString()}");
    debugPrint(
        "Calling getDutyStatus at ${ApiUrl.baseUrl4 + ApiUrl.getDutyStatus}");

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.getDutyStatus, dutyStatusRequest, "");

    if (response != null) {
      dutyStatusResponse.value = DutyStatusResponse.fromJson(response);

      if (dutyStatusResponse.value!.result!.flag == true) {
        debugPrint("Duty Status Received");
        debugPrint("Duty Response ${dutyStatusResponse.toString()}");
        isDutyFetched.value = true;
      } else {
        isDutyFetched.value = false;
        isOnDuty.value = false;
      }
    } else {
      isOnDuty.value = false;
      // isOnDuty.value = true;
      debugPrint("Duty Status Response = null");
    }
  }

  callDriverStatusApi() async {
    double isourseLat = 28.599189;
    double isourseLong = 77.0360246;

    DateTime currentDetails = DateTime.now();
    DriverStatusRequest driverStatusRequest = DriverStatusRequest(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        driverId: int.parse(loginController.loginResponse!.uSERID),
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID));

    debugPrint("Calling getDriverStatus");
    String token =
        "iDSJdgv8G6r36KlgMe-zCwKvfnSnuBRSrwl13WAKlvc1JdnOQv7JzcVKIj8nOSouekBtITkKFF345ara-_xDX1jB6Od1ZkxV46XcU8LQ4KxOvLdtDGy82jbPNifhK0JWS_HA0Xbm0_va1seg8Q9VrI9FUdF6Mn54AecAH69xYhk5eM_oOrwyq_e3_4q8Pzjz9qN5cSKSbYmjGxbDcSeDPp-_lGBXxHrJ5hP7gvrs32ezyG6c-fHVhh0baEh-PPS_8IOUxuL2HIiSNbZ222IV7VJU2TuFECowohA13mA9Zn5S7Wtsxwd5ZMentMhZTCBz0IPJVaaRp-ZdfdEpKkFfNdgfTVHR09Wi_v3kETy2cQp93pleaJfeV_AoQTSAh4UU6dZnMr2oAjzFWvByMjusQZjnm78k5aZ0KwMU_T7GXtfwVJLL9zCscribJdLZ3Egi-yDnjqxdPpkMPt80S4P_yGsS7BumX8LcCsnv2nP78h0uvdOFnYqCftHIvn3NiLx8";
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.getDriverStatus, driverStatusRequest, '');
    debugPrint(
        "Called getDriverStatus ${ApiUrl.baseUrl4 + ApiUrl.getDriverStatus} $response");
    if (response != null) {
      driverStatusResponse.value = DriverStatusResponse.fromJson(response);

      if (driverStatusResponse.value!.result!.flag == true) {
        if (driverStatusResponse.value!.result!.currentStatus!.toLowerCase() ==
            "on") {
          isOnDuty.value = true;
        }

        Datum fakeDriverResponse = Datum(
            duty: "Off",
            driverId: loginController.loginResponse!.uSERNAME,
            driverName: loginController.loginResponse!.uSERNAME,
            totalTime: "0:00:00",
            entryDate: formatDate(currentDetails),
            entryTime: formatTime(currentDetails),
            latitude: isourseLat,
            longitude: isourseLong);

        var offTemp = driverStatusResponse.value!.data.firstWhere(
            (element) => element.duty!.toLowerCase() == "off",
            orElse: () => fakeDriverResponse);
        // isOnDuty.value = driverStatusResponse.value!.result!.currentStatus!.toLowerCase() == "on"? true: false;
        var temp = driverStatusResponse.value!.data.firstWhere(
            (element) => element.duty!.toLowerCase() == "on",
            orElse: () => fakeDriverResponse);

        if (temp == fakeDriverResponse) {
          if (offTemp != fakeDriverResponse) {
            debugPrint("Off Data found");
            temp = offTemp;
          } else {
            debugPrint("On Off Data not found, take fake response");
            temp = fakeDriverResponse;
          }
        }
        getWorkingTime(temp.totalTime!);
        debugPrint("Time Fetched $temp");
      } else {
        isOnDuty.value = false;
      }
    } else {
      isOnDuty.value = false;
      debugPrint("Driver Status Response = null");
    }
  }


  int convertDoubleToInt(double value) {
    String valueStr = value.toString();
    valueStr = valueStr.replaceAll('.', '');
    int result = int.parse(valueStr);

    return result;
  }

  String formatTime(DateTime now) {
    DateFormat formatter = DateFormat('HH:mm:ss'); // Customize your format
    return formatter.format(now);
  }

  String formatDate(DateTime now) {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(now);
  }

  void getWorkingTime(String totalTimeString) {
    List<String> parts = totalTimeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    workingTime.value =
        Duration(hours: hours, minutes: minutes, seconds: seconds);

    // print("new timess ${timer.toString()}");
  }

  var isChecked = false.obs;

  void toggleCheckbox(bool? value) async {
    isChecked.value = value ?? false;
    NotificationPlugin notificationPlugin = NotificationPlugin();
    await notificationPlugin.init();
    if (isChecked.value) {
      startTimer();
      await notificationPlugin.showNotification();
    } else {
      await notificationPlugin.clear();
      stopTimer();
    }
  }

  void startTimer() {
    if (timer != null) {
      debugPrint("Timer going on..");
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      workingTime.value = Duration(seconds: workingTime.value.inSeconds + 1);
    });
  }

  void stopTimer() {
    timer?.cancel();
    workingTime.value = const Duration();
  }
}
