import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/model/request_model/change_password_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/response_model/change_password_response.dart';
import '../../utils/general/shared_preferences_keys.dart';
import '../../utils/toast.dart';
import 'login_controller.dart';
import 'logout_controller.dart';

class ChangePasswordController extends GetxController {
  final _loginController = Get.find<LoginController>();
  var logOutController = Get.find<LogoutController>();
  // final LoginController _loginController = LoginController();

  Rx<TextEditingController> oldPassword = TextEditingController().obs;
  Rx<TextEditingController> newPassword = TextEditingController().obs;
  Rx<TextEditingController> confirmNewPassword = TextEditingController().obs;

  Rx<FocusNode> oldPasswordFocusNode = FocusNode().obs;
  Rx<FocusNode> newPasswordFocusNode = FocusNode().obs;
  Rx<FocusNode> confirmPasswordFocusNode = FocusNode().obs;

  onSave(BuildContext context) async {
    if (oldPassword.value.text.isEmpty) {
      oldPasswordFocusNode.value.requestFocus();
      MyToast.myShowToast("Old Password cannot be empty");
      return;
    } else if (newPassword.value.text.isEmpty) {
      newPasswordFocusNode.value.requestFocus();
      MyToast.myShowToast("New Password cannot be empty");
      return;
    } else if (confirmNewPassword.value.text.isEmpty) {
      confirmPasswordFocusNode.value.requestFocus();
      MyToast.myShowToast("Confirm Password cannot be empty");
      return;
    } else if (oldPassword.value.text != _loginController.password.value.text) {
      oldPasswordFocusNode.value.requestFocus();
      MyToast.myShowToast("Password Incorrect");
      return;
    } else if (oldPassword.value.text == newPassword.value.text) {
      newPasswordFocusNode.value.requestFocus();
      MyToast.myShowToast("New Password cannot be same as Old Password");
    } else if (newPassword.value.text != confirmNewPassword.value.text) {
      confirmPasswordFocusNode.value.requestFocus();
      MyToast.myShowToast("Password Does Not Match");
      return;
    }
    await callChangePasswordApi(context);
    return true;
  }

  callChangePasswordApi(BuildContext context) async {
    ChangePasswordRequest req = ChangePasswordRequest(
      userName: _loginController.username.value.text.trim(),
      oldPassword: _loginController.password.value.text.trim(),
      newPassword: newPassword.value.text.trim(),
      // clientId: _loginController.loginResponse!.cLIENTID,
      clientId: "8",
      clientName: _loginController.loginResponse!.cLIENTNAME.trim(),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await CallMasterApi.postApiCallBasicAuth(
        ApiUrl.baseUrl + ApiUrl.changePassword, req);
    if (response != null) {
      // print(response);
      ChangePasswordResponse resp = ChangePasswordResponse.fromJson(response);
      if (resp.resultFlag == "1") {
        await prefs.setString(Strings.password, newPassword.value.text);
        _loginController.password.value.text = newPassword.value.text;
        MyToast.myShowToast("Change Password Successful");
        await logOutController.callLogoutApi(context);
        // Get.offAll(const Dashboard());
      }
    } else {
      Navigator.pop(context);
      MyToast.myShowToast("Change Password Failed");
    }
  }
}
