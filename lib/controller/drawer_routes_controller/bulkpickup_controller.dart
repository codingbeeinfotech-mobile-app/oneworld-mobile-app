import 'dart:convert';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/request_model/bulk_pickup_request.dart';
import 'package:abhilaya/model/request_model/bulk_pickup_submit_request.dart';
import 'package:abhilaya/model/request_model/pickup_trackingnumber_validattion_request.dart';
import 'package:abhilaya/model/response_model/bulk_pickup_response.dart';
import 'package:abhilaya/model/response_model/bulk_pickup_submit_response.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class BulkPickUpController extends GetxController {
  var loginController = Get.find<LoginController>();
  Rx<TextEditingController> trackingNumberController =
      TextEditingController().obs;
  AudioPlayer player = AudioPlayer();
  var scannedTrackingNumber = "".obs;
  var isTrackingNumberValid = false.obs;
  List<TrackingNumberList> scannedBulkProductsList =
      List<TrackingNumberList>.empty(growable: true).obs;
  List<String> scannedProductTrackingNumberList =
      List<String>.empty(growable: true).obs;
  var bulkPickupResponse = Rx<BulkPickupResponse?>(null);
  bool isLoading = false;
  callBulkPickupApi() async {
    BulkPickupRequest req = BulkPickupRequest(
        trackingNumber: trackingNumberController.value.text,
        // clientId: int.parse(loginController.loginResponse!.cLIENTID),
        // clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID));

    // var response = await CallMasterApi.postApiCall(ApiUrl.baseUrl4+ApiUrl.getBulkPickup, req, "");
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4WithS + ApiUrl.getBulkPickup, req, "");

    if (response != null) {
      debugPrint("response received $response");
      bulkPickupResponse.value = BulkPickupResponse.fromJson(response);
    } else {
      debugPrint("Bulk Pickup Response = null");
      MyToast.myShowToast("Something went wrong");
    }
  }

  validateTrackingNumber(String trackingNumber) async {
    bool flag = false;

    ValidatePickupTrackingNoRequest req = ValidatePickupTrackingNoRequest(
      companyId: int.parse(loginController.loginResponse!.cOMPANYID),
      clientName: null,
      trackingNumber: trackingNumberController.value.text,
      clientId: null,
      warehouseId: null,
      userId: null,
    );

    var response = await CallMasterApi.postApiCall(
      ApiUrl.baseUrl4WithS + ApiUrl.isTrackingNumberValidForBulkPickup,
      req,
      "",
    );

    print("Response: $response");

    BulkPickupResponse res = BulkPickupResponse.fromJson(response);
    bulkPickupResponse.value = BulkPickupResponse.fromJson(response);

    // Ensure the response has valid data
    if (res.flag == true && res.data != null&&res.data!.trackingNumberList.isNotEmpty) {
      print("Valid response received.");
      for (TrackingNumberList trackingNumberList
          in res.data!.trackingNumberList) {
        print(
            "Processing tracking number: ${trackingNumberList.trackingNumber}");

        // Check if the tracking number is already scanned
        bool isAlreadyScanned = scannedBulkProductsList.any(
          (item) => item.trackingNumber == trackingNumberList.trackingNumber,
        );

        if (!isAlreadyScanned) {
          // Add to the scanned lists
          scannedBulkProductsList.add(trackingNumberList);
          scannedProductTrackingNumberList
              .add(trackingNumberList.trackingNumber!);
          isTrackingNumberValid.value = true;

          // Play validation sound
          try {
            print(
                "Validated tracking number: ${trackingNumberList.trackingNumber}");
            isLoading = false;
            await player.setAsset('assets/sounds/validated.mp3');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio: $e");
          }
        } else {
          MyToast.myShowToast(
              "Tracking number ${trackingNumberList.trackingNumber} is already scanned.");

          // Play warning sound
          try {
            await player.setAsset('assets/sounds/warning.ogg');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio: $e");
          }
        }
      }
      flag = true; // Mark as flag true since valid data was found
    }

    if (!flag) {
      // Handle invalid case
      try {
        await player.setAsset('assets/sounds/warning.ogg');
        player.play();
      } catch (e) {
        debugPrint("Error while playing audio: $e");
      }
      MyToast.myShowToast("Invalid Tracking Number");
    }

    // Clear the tracking number input
    trackingNumberController.value.clear();
    isLoading = false;
  }

  var bulkPickUpSubmitResponse = Rx<BulkPickUpSubmitResponse?>(null);
  // I/flutter (19667): BulkPickup request {"DefaultParam":{"ClientId":1,"ClientName":"One world","UserId":1003,"RoleId":1},"Param":[{"OdnId":396492,"TrackingNoStatus":"1"}]}
  // I/flutter (19667): API call response.statusCode: 200
  // I/flutter (19667): Submit Response Fetched
  // I/flutter (19667): true, Pickup Location NameXC Sewree ,
  // I/flutter (19667): app version api call
  // I/flutter (19667): API call response.statusCode: 200
  // I/flutter (19667): App version --1.0.0
  callBulkPickUpSubmitApi() async {
    DefaultParam defaultParamRequest = DefaultParam(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        userId: int.parse(loginController.loginResponse!.uSERID),
        roleId: loginController.loginResponse!.rOLEID.isEmpty
            ? 1
            : int.parse(loginController.loginResponse!.rOLEID));
    List<Param> paramRequestList = List<Param>.empty(growable: true).obs;

    for (int i = 0; i < scannedBulkProductsList.length; i++) {
      Param temp =
          Param(odnId: scannedBulkProductsList[i].odnId, trackingNoStatus: "1");
      paramRequestList.add(temp);
    }

    BulkPickUpSubmitRequest request = BulkPickUpSubmitRequest(
        defaultParam: defaultParamRequest, param: paramRequestList);

    debugPrint("BulkPickup request ${jsonEncode(request.toJson())}");

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.hubOrderSubmit, request, "");
    if (response != null) {
      debugPrint("Submit Response Fetched");
      bulkPickUpSubmitResponse.value =
          BulkPickUpSubmitResponse.fromJson(response);
      MyToast.myShowToast("Successfully Picked Up");
      isTrackingNumberValid.value = false;
      scannedBulkProductsList.clear();
      scannedProductTrackingNumberList.clear();
          debugPrint("$bulkPickUpSubmitResponse");
    }
  }
}
