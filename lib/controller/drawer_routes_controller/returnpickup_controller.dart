import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/request_model/return_pickup_request.dart';
import 'package:abhilaya/model/request_model/return_pickup_submit_request.dart';
import 'package:abhilaya/model/request_model/validate_return_request.dart';
import 'package:abhilaya/model/response_model/validate_return_response.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../model/response_model/ndr_response.dart';
import '../../model/response_model/qc_failed_reason_respone.dart';
import '../../model/response_model/return_pickup_response.dart';
import '../../model/response_model/return_pickup_submit_response.dart';

class ReturnPickupController extends GetxController {
  var isReturnPickupImage = false.obs;
  AudioPlayer player = AudioPlayer();
  var loginController = Get.find<LoginController>();
  Rx<TextEditingController> searchTrackingNumber = TextEditingController().obs;
  Rx<FocusNode> searchTrackingNumberFocusNode = FocusNode().obs;
  var returnPickupResponse = Rx<ReturnPickupResponse?>(null);
  var selectedReturnProductPickupAddress = "".obs;
  Rx<FocusNode> selectedReturnProductPickupAddressFocusNode = FocusNode().obs;
  var selectedReturnProductTrackingNumber = "".obs;
  var returnPickupSubmitResponse = Rx<ReturnPickupSubmitResponse?>(null);

  List<Datum> returnPickupProductList = List<Datum>.empty(growable: true).obs;

  List<String> returnPickupLocationList =
      List<String>.empty(growable: true).obs;

  var validatePickupResponse = Rx<ValidatePickupResponse?>(null);
  var temp = Rx<Data?>(null);
  var isProductImageAvailable = false.obs;

  Rx<TextEditingController> scannedBarcode = TextEditingController().obs;
  Rx<FocusNode> scannedBarcodeFocusNode = FocusNode().obs;
  var selectedNpr = "Please Select NPR".obs;
  Rx<FocusNode> selectedNdrFocusNode = FocusNode().obs;
  List<NDRListResponse> ndrAPIResponseList =
      List<NDRListResponse>.empty(growable: true).obs;
  List<String> ndrResponseList = List<String>.empty(growable: true).obs;
  var selectedNdrCodeValue = "0".obs;
  Rx<Uint8List?> productImageByte = Uint8List(0).obs;
  Rx<File?> productSelectedImageByte = File('').obs;

  List<Uint8List> productImageList = List<Uint8List>.empty(growable: true).obs;
  List<Int8List?> productImageIntList =
      List<Int8List>.empty(growable: true).obs;
  List<String> productImageBase64List = List<String>.empty(growable: true).obs;

  Map<String, List<String>> map = {};
  var qcCheckValue = "0".obs;
  var selectedQcCheck = "Select QC".obs;

  Rx<FocusNode> selectedQcCheckFocusNode = FocusNode().obs;

  // var qcFailedReasonResponse = Rx<QcFailReasonResponse?>(null);
  List<QcFailReasonResponse> qcFailedReasonResponse =
      List<QcFailReasonResponse>.empty(growable: true).obs;

  var selectedQcFailedReason = "Select QC Reason".obs;
  Rx<FocusNode> selectedQcFailedReasonFocusNode = FocusNode().obs;
  List<String> qcFailedReasonList = List<String>.empty(growable: true).obs;

  var selectedQcFailedReasonValue = "0".obs;
  var isQcPassed = false.obs;

  callReturnPickupApi() async {
    ReturnPickupRequest request = ReturnPickupRequest(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        userId: int.parse(loginController.loginResponse!.uSERID),
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID));

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4WithS + ApiUrl.getPickingOdnReturnByLocation,
        request,
        "");
    // ApiUrl.baseUrl4 + ApiUrl.getPickingOdnReturnByLocation, request, "");
    if (response != null) {
      returnPickupResponse.value = ReturnPickupResponse.fromJson(response);
    }
    map.clear();

    for (int i = 0; i < returnPickupResponse.value!.data.length; i++) {
      String currentPickupLocation =
          returnPickupResponse.value!.data[i].pickupLocation.toString();

      String trackingNumber =
          returnPickupResponse.value!.data[i].trackingNumber.toString();

      if (map.containsKey(currentPickupLocation)) {
        map[currentPickupLocation]!.add(trackingNumber);
      } else {
        map[currentPickupLocation] = [trackingNumber];
      }
      returnPickupProductList.add(returnPickupResponse.value!.data[i]);

      returnPickupLocationList
          .add(returnPickupResponse.value!.data[i].pickupLocation.toString());

      // var isDuplicate = returnPickupProductList.any((data) => data.pickupLocation == currentPickupLocation );
      //
      // if(!isDuplicate) {
      //   returnPickupProductList.add(returnPickupResponse.value!.data[i]);
      // }
    }
    // print("map is ${map}");
  }

  callValidateReturnPickupApi(String trackingNumber) async {
    ValidatePickupRequest request = ValidatePickupRequest(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        trackingNumber: trackingNumber.trim(),
        userId: int.parse(loginController.loginResponse!.uSERID),
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID));
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.isOdnReturnPickingTrackingNoValid,
        request,
        "");

    isQcPassed.value = false;
    if (response != null) {
      validatePickupResponse.value = ValidatePickupResponse.fromJson(response);

      if (validatePickupResponse.value!.result!.flag == true) {
        MyToast.myShowToast("Valid Tracking Number");
        try {
          await player.setAsset('assets/sounds/validated.mp3');
          player.play();
        } catch (e) {
          debugPrint("Error while playing audio");
        }
        temp.value = validatePickupResponse.value!.data;

        // selectedReturnProductPickupAddress.value = temp.value!.pickupLocation!;
        qcCheckValue.value = temp.value!.qualityCheck!;

        if (temp.value!.qualityCheck!.toLowerCase() == "pass" ||
            temp.value!.qualityCheck == "Pass" ||
            temp.value!.qualityCheck == "PASS" ||
            temp.value!.qualityCheck!.toLowerCase() == "yes" ||
            temp.value!.qualityCheck == "Yes" ||
            temp.value!.qualityCheck == "YES") {
          isQcPassed.value = true;
        } else {
          isQcPassed.value = false;
        }

        if (temp.value!.productImage != null ||
            temp.value!.productImage.toString().isNotEmpty) {
          isProductImageAvailable.value = true;
        } else {
          isProductImageAvailable.value = false;
        }
      } else {
        try {
          await player.setAsset('assets/sounds/warning.ogg');
          player.play();
        } catch (e) {
          debugPrint("Error while playing audio");
        }
        MyToast.myShowToast("Invalid Tracking Number");
      }
    }
  }

  callNDRListApi() async {
    var response = await CallMasterApi.postApiCallWithoutToken(
        ApiUrl.baseUrl4 + ApiUrl.returnPickupNdrList);
    if (response != null) {
      for (int i = 0; i < response.length; i++) {
        ndrAPIResponseList.add(NDRListResponse.fromJson(response[i]));
      }
      getResponseFromNdrList();
    }
  }

  getResponseFromNdrList() {
    ndrResponseList.add("Please Select NPR");
    for (int i = 0; i < ndrAPIResponseList.length; i++) {
      ndrResponseList.add(ndrAPIResponseList[i].name!);
    }
  }

  getNdrReasonValue(String reason) {
    if (reason == "Please Select NPR") {
      selectedNdrCodeValue.value = "0";
    } else {
      var temp =
          ndrAPIResponseList.firstWhere((element) => element.name == reason);
      selectedNdrCodeValue.value = temp.value!;
    }
  }

  callQcFailedReasonApi() async {
    var response = await CallMasterApi.postApiCallWithoutToken(
        ApiUrl.baseUrl4 + ApiUrl.getOdnQualityCheckFailedReason);
    if (response != null) {
      for (int i = 0; i < response.length; i++) {
        qcFailedReasonResponse.add(QcFailReasonResponse.fromJson(response[i]));
      }
      qcFailedReasonList.add("Select QC Reason");
      for (int i = 0; i < qcFailedReasonResponse.length; i++) {
        qcFailedReasonList.add(qcFailedReasonResponse[i].name.toString());
      }
    }
  }

  getQcFailReasonValue(String reason) {
    if (reason == "Select QC Reason") {
      selectedQcFailedReasonValue.value = "0";
    } else {
      var tempArr = qcFailedReasonResponse
          .firstWhere((element) => element.name == reason);
      selectedQcFailedReasonValue.value = tempArr.value!;
    }
  }

  callSubmitReturnPickupApi(BuildContext context) async {
    Dialogs.lottieLoading(context, 'assets/lottiee/verification.json');

    DefaultParam defaultParam = DefaultParam(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        userId: int.parse(loginController.loginResponse!.uSERID));

    List<ProductImageList> productList =
        List<ProductImageList>.empty(growable: true);

    for (int i = 0; i < productImageBase64List.length; i++) {
      ProductImageList imageList =
          ProductImageList(image: productImageBase64List[i].toString());

      productList.add(imageList);
    }

    Param param = Param(
        nonPickupReasonId: selectedNdrCodeValue.value == "0"
            ? 0
            : int.parse(selectedNdrCodeValue.value),
        odnId: temp.value!.odnId ?? 0,
        productImageList: productList,
        qualityCheck: temp.value!.qualityCheck ?? "",
        qualityCheckFailedReasonId:
            isQcPassed.value ? int.parse(selectedQcFailedReasonValue.value) : 0,
        trackingNoStatus: "1",
        barcode: scannedBarcode.value.text ?? "");

    List<Param> paramList = List<Param>.empty(growable: true);
    paramList.add(param);

    ReturnPickupSubmitRequest request =
        ReturnPickupSubmitRequest(defaultParam: defaultParam, param: paramList);

    debugPrint("Return Pickup Request Json ${jsonEncode(request.toJson())}");
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.odnReturnSubmitPick, request, "");

    if (response != null) {
      returnPickupSubmitResponse.value =
          ReturnPickupSubmitResponse.fromJson(response);
      if (returnPickupSubmitResponse.value!.flag == true) {
        if (selectedNpr.value == "Please Select NPR" &&
            selectedNdrCodeValue.value == "0") {
          MyToast.myShowToast(
              returnPickupSubmitResponse.value!.flagMessage.toString());
        } else {
          MyToast.myShowToast("Submit Successfully");
        }
        debugPrint("Return Shipment Submitted");

        // Navigator.pop(context);
        Get.offAll(  BottomNavBar());
      } else {
        debugPrint("Return Shipment Submitted Failed");
        Navigator.pop(context);
        MyToast.myShowToast(
            returnPickupSubmitResponse.value!.flagMessage.toString());
      }
    }
  }
}
