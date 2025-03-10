import 'dart:convert';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/request_model/pickup_trackingnumber_validattion_request.dart';
import 'package:abhilaya/model/request_model/submit_ndr_request.dart';
import 'package:abhilaya/model/request_model/undeliveredLocationRequest.dart';
import 'package:abhilaya/model/response_model/pickup_trackingnumber_validate_response.dart';
import 'package:abhilaya/model/response_model/submit_ndr_response.dart';
import 'package:abhilaya/model/response_model/undeliveredLocationResponse.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../utils/toast.dart';

class UndeliveredLocationController extends GetxController {
  AudioPlayer player = AudioPlayer();
  var loginController = Get.find<LoginController>();
  var ndrByLocationResponse = Rx<NdrByLocationResponse?>(null);
  List<String> ndrLocationList = List<String>.empty(growable: true).obs;
  var scannedTrackingNumber = "".obs;
  var validatePickupTrackingNoResponse =
      Rx<ValidatePickupTrackingNoResponse?>(null);
  List<Data> scannedNdrDeliveries = List<Data>.empty(growable: true).obs;
  var selectedNdrLocation = "Select NDR Location".obs;
  Rx<TextEditingController> trackingNumberController =
      TextEditingController().obs;
  Rx<FocusNode> trackingNumberFocusNode = FocusNode().obs;
  var isTrackingNumberValid = false.obs;
  var submitNdrResponse = Rx<SubmitNdrResponse?>(null);

  callNdrLocationAPI() async {
    NdrByLocationRequest request = NdrByLocationRequest(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        userId: int.parse(loginController.loginResponse!.uSERID),
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID));
    // var response = await CallMasterApi.postApiCall(ApiUrl.baseUrl4+ApiUrl.getNdrByLocation, request, "");
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4WithS + ApiUrl.getNdrByLocation, request, "");

    if (response != null) {
      ndrByLocationResponse.value = NdrByLocationResponse.fromJson(response);
      ndrLocationList.add("Select NDR Location");
      for (int i = 0; i < ndrByLocationResponse.value!.data.length; i++) {
        ndrLocationList.add(ndrByLocationResponse
            .value!.data[i].transporterLocation
            .toString());
      }
    } else {
      debugPrint("Location response = null");
      MyToast.myShowToast("Something went wrong");
    }
  }

  callValidatePickUpTrackingNumberApi(String trackingNumber) async {
    ValidatePickupTrackingNoRequest trackingNoRequest =
        ValidatePickupTrackingNoRequest(
      userId: int.parse(loginController.loginResponse!.uSERID),
      clientId: int.parse(loginController.loginResponse!.cLIENTID),
      clientName: loginController.loginResponse!.cLIENTNAME,
      companyId: int.parse(loginController.loginResponse!.cOMPANYID),
      warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID),
      trackingNumber: trackingNumber.trim(),
    );

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.isNdrTrackingNoValid, trackingNoRequest, "");

    if (response != null) {
      validatePickupTrackingNoResponse.value =
          ValidatePickupTrackingNoResponse.fromJson(response);
      if (validatePickupTrackingNoResponse.value!.result!.flag == true &&
          validatePickupTrackingNoResponse.value!.data!.transporterLocation
                  .toString()
                  .toLowerCase() ==
              selectedNdrLocation.value.toLowerCase()) {
        isTrackingNumberValid.value = true;
        var isDuplicate = scannedNdrDeliveries
            .any((data) => data.trackingNumber == trackingNumber);

        if (isDuplicate) {
          try {
            await player.setAsset('assets/sounds/warning.ogg');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio");
          }
          MyToast.myShowToast("Already Scanned");
        } else {
          try {
            await player.setAsset('assets/sounds/validated.mp3');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio");
          }
          scannedNdrDeliveries
              .add(validatePickupTrackingNoResponse.value!.data!);
        }
        trackingNumberController.value.clear();
      } else {
        try {
          await player.setAsset('assets/sounds/warning.ogg');
          player.play();
        } catch (e) {
          debugPrint("Error while playing audio");
        }
        MyToast.myShowToast("Invalid Tracking Number");
        trackingNumberController.value.clear();
      }
    }
  }

  callSubmitNdrApi() async {
    DefaultParam defaultParam = DefaultParam(
        clientId: loginController.loginResponse!.cLIENTID,
        clientName: loginController.loginResponse!.cLIENTNAME);

    List<Param> paramList = List<Param>.empty(growable: true).obs;

    for (int i = 0; i < scannedNdrDeliveries.length; i++) {
      Param param = Param(
          employeeId: "",
          odnId: scannedNdrDeliveries[i].odnId.toString().trim(),
          picture: "",
          receiverName: "",
          receiverPhoneNo: "",
          signature: "");

      paramList.add(param);
    }
    SubmitNdrRequest submitNdrRequest =
        SubmitNdrRequest(defaultParam: defaultParam, param: paramList);

    debugPrint(jsonEncode(submitNdrRequest.toJson()));
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.submitNdrDelivery, submitNdrRequest, "");

    if (response != null) {
      submitNdrResponse.value = SubmitNdrResponse.fromJson(response);
      if (submitNdrResponse.value!.flag == true) {
        MyToast.myShowToast(submitNdrResponse.value!.flagMessage.toString());
        Get.offAll(  BottomNavBar());
      } else {
        MyToast.myShowToast("Error Occurred");
      }
    } else {
      debugPrint("Error while calling Submit API");
    }
  }
}
