import 'dart:async';
import 'dart:convert';

import 'package:abhilaya/model/request_model/login_request.dart';
import 'package:abhilaya/model/response_model/login_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/master_api/api_call.dart';
import '../../api/master_api/api_url.dart';
import '../../utils/general/general_methods.dart';
import '../../utils/general/shared_preferences_keys.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> username = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;
  Rx<FocusNode> passwordFocusNode = FocusNode().obs;
  Rx<FocusNode> usernameFocusNode = FocusNode().obs;
  LoginResponseModel? loginResponse;
  var locationPermission = "".obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  RxString address = ''.obs;
  RxString fcmToken = ''.obs;

  Future<void> callLoginApi() async {

    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    SharedPreferences? _preferences=await SharedPreferences.getInstance();

    _firebaseMessaging.getToken().then((token)   {
      print("fcm token is12=-=- $token");
      _preferences.setString(Strings.fcmToken,token!);
      fcmToken.value = token!;

    });


    _preferences.getString(Strings.fcmToken,);

    LoginRequestModel req = LoginRequestModel(
      loginId: username.value.text.trim(),
      password: password.value.text.trim(),
      fcmToken: _preferences.getString(Strings.fcmToken,) ??fcmToken.value,
    );

    var tokenResponse =
        await CallMasterApi.tokenApi(ApiUrl.baseUrl2 + ApiUrl.loginToken);

    debugPrint(
        'Login ${ApiUrl.baseUrl2 + ApiUrl.loginToken} tokenResponse fetch response: $tokenResponse');

    if (tokenResponse != null) {
      String token = tokenResponse.accessToken;
      await SharedPreferences.getInstance().then((prefs) async {
        await prefs.setString(Strings.token, token);
      });
      var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl2 + ApiUrl.login,
        req,
        token,
      );

      debugPrint(
          'Login Response: ${ApiUrl.baseUrl2 + ApiUrl.login} ${response}');

      if (response != null) {
        loginResponse = LoginResponseModel.fromJson(response);
        await _saveDetails(loginResponse!);
        debugPrint('Login response saved: $loginResponse');
      } else {
        debugPrint('Login Response fetch failed');
      }
    } else {
      debugPrint("Token Response is null");
    }
  }

  _saveDetails(LoginResponseModel response) async {
    debugPrint("save details=-=- ${jsonEncode(response.toJson())}");
    await SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString(Strings.clientName, response.cLIENTNAME);
      await prefs.setString(Strings.clientId, response.cLIENTID);
      await prefs.setString(Strings.companyId, response.cOMPANYID);
      await prefs.setString(Strings.flagMsg, response.fLAGMSG);
      await prefs.setString(Strings.isLogin, response.isLogin);
      await prefs.setString(Strings.mobileNo, response.mOBILENO);
      await prefs.setString(Strings.roleId, response.rOLEID);
      await prefs.setString(Strings.userId, response.uSERID);
      await prefs.setString(Strings.userName, response.uSERNAME);
      await prefs.setString(Strings.wareHouseId, response.wAREHOUSEID);
      await prefs.setString(Strings.password, password.value.text);
      await prefs.setString(Strings.userTypeId, response.userTypeId.toString());
    });

    GeneralMethods.clientName.value = response.cLIENTNAME;
    GeneralMethods.clientId.value = response.cLIENTID;
    GeneralMethods.companyId.value = response.cOMPANYID;
    GeneralMethods.mobileNo.value = response.mOBILENO;
    GeneralMethods.roleId.value = response.rOLEID;
    GeneralMethods.username.value = response.uSERNAME;
    GeneralMethods.userId.value = response.uSERID;
    GeneralMethods.warehouseId.value = response.wAREHOUSEID;
  }

  isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    var userid = prefs.getString(Strings.userId);
    if (userid != null) {
      await _getUserDetails(prefs);
      return true;
    }

    return false;
  }

  _getUserDetails(SharedPreferences prefs) async {
    loginResponse = LoginResponseModel(
      uSERNAME: prefs.getString(Strings.userName) ?? "",
      uSERID: prefs.getString(Strings.userId) ?? "",
      mOBILENO: prefs.getString(Strings.mobileNo) ?? "",
      cLIENTID: prefs.getString(Strings.clientId) ?? "",
      cLIENTNAME: prefs.getString(Strings.clientName) ?? "",
      cOMPANYID: prefs.getString(Strings.companyId) ?? "",
      wAREHOUSEID: prefs.getString(Strings.wareHouseId) ?? "",
      rOLEID: prefs.getString(Strings.roleId) ?? "",
      fLAGMSG: prefs.getString(Strings.flagMsg) ?? "",
      isLogin: prefs.getString(Strings.isLogin) ?? "",
      fcmToken: prefs.getString(Strings.fcmToken) ?? "",
      userTypeId: int.parse(prefs.getString(Strings.userTypeId) ?? ""),
    );
    password.value.text = prefs.getString(Strings.password) ?? "";
    username.value.text = prefs.getString(Strings.userName) ?? "";
    print(loginResponse?.toJson());

    GeneralMethods.clientName.value = loginResponse!.cLIENTNAME;
    GeneralMethods.clientId.value = loginResponse!.cLIENTID;
    GeneralMethods.companyId.value = loginResponse!.cOMPANYID;
    GeneralMethods.mobileNo.value = loginResponse!.mOBILENO;
    GeneralMethods.roleId.value = loginResponse!.rOLEID;
    GeneralMethods.username.value = loginResponse!.uSERNAME;
    GeneralMethods.userId.value = loginResponse!.uSERID;
    GeneralMethods.warehouseId.value = loginResponse!.wAREHOUSEID;

    debugPrint("General methods saved ${GeneralMethods.clientName.value}");
  }

  ///Connectivity Vars
  var noInternetCount = 0.obs;
  var connectionStatus = 'ConnectivityResult.none'.obs;
  var isSnackBarShow = false.obs;
  var listenFlag = false;
  final Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
}
