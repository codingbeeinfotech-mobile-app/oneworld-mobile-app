import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/request_model/bulk_pickup_submit_request.dart';
import 'package:abhilaya/model/request_model/pickup_trackingnumber_validattion_request.dart';
import 'package:abhilaya/model/response_model/bulk_pickup_response.dart';
import 'package:abhilaya/model/response_model/bulk_pickup_submit_response.dart';
import 'package:abhilaya/model/signup_model/user_model.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class NDRDeliveryController extends GetxController {
  var loginController = Get.find<LoginController>();
  var selectedUser = "Select User".obs;

  Rx<TextEditingController> trackingNumberController =
      TextEditingController().obs;
  AudioPlayer player = AudioPlayer();
  var userSearchController = TextEditingController();
  var scannedTrackingNumber = "".obs;
  var isTrackingNumberValid = false.obs;
  Rx<FocusNode> employerIdFocusNode = FocusNode().obs;
  List scannedBulkProductsList =
      List<TrackingNumberData>.empty(growable: true).obs;
  List<String> scannedProductTrackingNumberList =
      List<String>.empty(growable: true).obs;
  var ndrDeliveryResponse = Rx<ValidateTrackingResponse?>(null);
  var userList = RxList<UserDatum>();
  bool isLoading = false;
  Rx<Uint8List?> receiversSignatureImageByte = Uint8List(0).obs;
  var receiversSignatureBase64 = "".obs;
  Rx<File?> receiversSignatureSelectedImage = File('').obs;
  Rx<Uint8List?> podImageByte = Uint8List(0).obs;
  Rx<File?> podSelectedImage = File('').obs;
  var podBase64Url = "".obs;
  callGetUserList() async {
    try {
      // Fetch response from the API
      var response = await CallMasterApi.getApiCall(
          ApiUrl.baseUrl4WithS + ApiUrl.getUserList, "");

      // If the response is a list (as indicated by your error)
      if (response != null && response is List) {
        log("Response received: $response");

        // Assuming response is a List of maps, you can map it to your UserModel
        // If response contains a "data" field, decode it as a map
        UserModel userModel = UserModel.fromJson({"data": response});

        // Assign the list of Datum objects to userList
        userList.assignAll(userModel.data);

        log("User list: $userList");
      } else {
        debugPrint("Response is not a list or is null");
        MyToast.myShowToast("Something went wrong");
      }
    } catch (e) {
      debugPrint("Error in callGetUserList: $e");
      MyToast.myShowToast("Failed to fetch user list");
    }
  }

  validateTrackingNumber(String trackingNumber) async {
    bool flag = false;

    ValidatePickupTrackingNoRequest req = ValidatePickupTrackingNoRequest(
      companyId: int.parse(loginController.loginResponse!.cOMPANYID),
      clientName: null,
      trackingNumber: trackingNumberController.value.text,
      clientId: null,
      warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID),
      userId: int.parse(loginController.loginResponse!.uSERID),
    );

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4WithS + ApiUrl.isNdrTrackingNoValid, req, "");
    print("Response: $response");
    ValidateTrackingResponse res = ValidateTrackingResponse.fromJson(response);
    ndrDeliveryResponse.value = ValidateTrackingResponse.fromJson(response);

// Ensure the response has valid data
    if (res.result!.flag == true && res.data != null) {
      print("object sgsgsgs");

      print("object valdgdftrgidsdfsgated $trackingNumber }");

      // Check the tracking number or master number
      if ((trackingNumber ==
          (ndrDeliveryResponse.value!.data!.trackingNumber))) {
        print(
            "objects dfgdsrhgtvalidated $scannedBulkProductsList $trackingNumber");
        flag = true;
        bool isAlreadyScanned = scannedBulkProductsList.any(
          (item) => item.trackingNumber == trackingNumber,
        );
        // Check if the item is already scanned
        if (!isAlreadyScanned) {
          scannedBulkProductsList.add(ndrDeliveryResponse.value!.data);

          scannedProductTrackingNumberList.add(trackingNumber);
          isTrackingNumberValid.value = true;
          scannedTrackingNumber.value = trackingNumber;

          // Play validation sound
          try {
            print("object validated");
            isLoading = false;
            await player.setAsset('assets/sounds/validated.mp3');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio: $e");
          }
        } else {
          MyToast.myShowToast("Already Scanned");

          // Play warning sound
          try {
            print("object warning");
            isLoading = false;
            await player.setAsset('assets/sounds/warning.ogg');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio: $e");
          }
        }
      }
    }
    isLoading = false;
// If no valid match is found
    if (!flag) {
      try {
        print("object warningwarning");
        isLoading = false;
        await player.setAsset('assets/sounds/warning.ogg');
        player.play();
      } catch (e) {
        debugPrint("Error while playing audio: $e");
      }
      MyToast.myShowToast("Invalid Tracking Number");
    }
    isLoading = false;
// Clear the tracking number input
    trackingNumberController.value.clear();
  }

  var bulkPickUpSubmitResponse = Rx<BulkPickUpSubmitResponse?>(null);
  void convertByteToBase64(Rx<Uint8List?> byteList, Rx<String> base64Url) {
    if (byteList.value != null) {
      String base64String = base64Encode(byteList.value!);
      base64Url.value = base64String;
      debugPrint('Base64 String: $base64String');
    } else {
      debugPrint('Byte list is null');
    }
  }

  callNDRDeliverySubmitApi(
    BuildContext context,
  ) async {
    Dialogs.signUpLoading(context);

    if (podImageByte.value!.isNotEmpty) {
      convertByteToBase64(podImageByte, podBase64Url);
    }

    List<SubmitNdrDeliveryParam> paramRequestList =
        List<SubmitNdrDeliveryParam>.empty(growable: true).obs;

    for (int i = 0; i < scannedBulkProductsList.length; i++) {
      SubmitNdrDeliveryParam temp = SubmitNdrDeliveryParam(
          odnId: scannedBulkProductsList[i].odnId,
          employeeId: selectedUser.value,
          signature: receiversSignatureBase64.value,
          picture: podBase64Url.value,
          latitude: 0,
          longitude: 0);

      paramRequestList.add(temp);
    }

    SubmitNdrDelivery request = SubmitNdrDelivery(param: paramRequestList);

    debugPrint("callNDRDeliverySubmitApi request ${jsonEncode(request.toJson())}");

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.submitNdrDelivery, request, "");
    if (response != null) {
      debugPrint("Submit Response Fetched $request $response");
      bulkPickUpSubmitResponse.value =
          BulkPickUpSubmitResponse.fromJson(response);
      if (bulkPickUpSubmitResponse.value!.flag == true) {
        // MyToast.myShowToast('Submitted Successfully');

        MyToast.myShowToast(
            bulkPickUpSubmitResponse.value!.flagMessage.toString());

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

      } else {
        Navigator.pop(context);
        MyToast.myShowToast(
            bulkPickUpSubmitResponse.value!.flagMessage.toString());
      }
      debugPrint("$bulkPickUpSubmitResponse");
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      MyToast.myShowToast("An error has occurred.");
    }
  }
}
