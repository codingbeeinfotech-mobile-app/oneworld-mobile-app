import 'dart:convert';

import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/request_model/logout_request.dart';
import 'package:abhilaya/model/response_model/logout_response.dart';
import 'package:abhilaya/view/auth/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/master_api/api_call.dart';
import '../../api/master_api/api_url.dart';
import '../../utils/general/alert_boxes.dart';
import '../../utils/general/shared_preferences_keys.dart';
import '../../utils/toast.dart';

class LogoutController extends GetxController {
  var logOutResponse = Rx<LogOutResponse?>(null);

  callLogoutApi(BuildContext context) async {
    Dialogs.lottieLoading(context, "assets/lottiee/abhi_loading.json");
    LoginController loginController = Get.find<LoginController>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    LogOutRequest logOutRequest = LogOutRequest(
      userName: loginController.username.value.text.trim(),
      userPassword: loginController.password.value.text.trim(),
      fcmToken:    prefs.getString(Strings.fcmToken,)!,
      userid: prefs.getString(Strings.userId),
    );

    debugPrint("Request ${jsonEncode(logOutRequest.toJson())}");
    var response = await CallMasterApi.postApiCallBasicAuth(
        ApiUrl.baseUrl2 + ApiUrl.logout, logOutRequest);
    debugPrint(" response--$response");

    if (response != null) {
      logOutResponse.value = LogOutResponse.fromJson(response);

      if (logOutResponse.value!.flag == "1") {
        await prefs.clear();
        loginController.loginResponse = null;
        loginController.password.value.clear();
        loginController.username.value.clear();
        MyToast.myShowToast("LogOut Successful");
        Navigator.pop(context);
        Get.offAll(const LoginPage());
        // return true;
      } else {
        Navigator.pop(context);
        debugPrint("Logout failed");
        MyToast.myShowToast("LogOut Failed");
        // Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      MyToast.myShowToast("LogOut Failed");
      debugPrint('Logout Response fetch failed');
    }
    // return false;
  }
}
