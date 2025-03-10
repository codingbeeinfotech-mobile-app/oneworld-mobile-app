import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'dart:io';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/request_model/notification_request.dart';
import 'package:abhilaya/model/response_model/notification_response.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var loginController = Get.find<LoginController>();
  var notificationResponse = Rx<NotificationModel?>(null);


  callNotification() async {
    NotificationRequest req = NotificationRequest(
      companyId: int.parse(loginController.loginResponse!.cOMPANYID),
      driverId: int.parse(loginController.loginResponse!.uSERID),
      warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID),
    );

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.getNotificationDataById, req, "");

    print("notificationResponse Response Received ${ApiUrl.baseUrl4 + ApiUrl.getNotificationDataById}");
    print("notificationResponse Response Received $response");

    if (response != null && response is List) {
      notificationResponse.value = NotificationModel.fromJson(response);
      print("Notification List Loaded Successfully");
    } else {
      print("Invalid response format");
    }
  }
}
