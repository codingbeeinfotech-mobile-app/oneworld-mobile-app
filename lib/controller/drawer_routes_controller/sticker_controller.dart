import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/model/request_model/print_validate_tracking_number_request.dart';
import 'package:abhilaya/model/response_model/print_validate_tracking_number_response.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class StickerController extends GetxController {
  AudioPlayer player = AudioPlayer();
  Rx<TextEditingController> printTrackingNumber = TextEditingController().obs;
  var scannedTrackingNumber = "".obs;
  var isTrackingNumberScanned = false.obs;
  List<AvailablePrinter> availablePrinters =
      List<AvailablePrinter>.empty(growable: true).obs;
  var isBluetoothConnected = false.obs;

  var validatePrintTrackingNumberResponse =
      Rx<ValidatePrintTrackingNumberResponse?>(null);

  callValidateTrackingNumberApi(String trackingNumber) async {
    debugPrint("Validating Tracking Number");

    if (trackingNumber.startsWith("OWLB")) {
      ValidatePrintTrackingNumberRequest validatePrintTrackingNumberRequest =
          ValidatePrintTrackingNumberRequest(trackingNo: trackingNumber.trim());

      debugPrint("Requesting");
      var response = await CallMasterApi.postApiCall(
          ApiUrl.baseUrl3 + ApiUrl.validatePrintTrackingNumber,
          validatePrintTrackingNumberRequest,
          "");
      debugPrint("Request Received");
      if (response != null) {
        validatePrintTrackingNumberResponse.value =
            ValidatePrintTrackingNumberResponse.fromJson(response);
        debugPrint("Validate API Fetched");
        if (validatePrintTrackingNumberResponse.value!.flag == 1) {
          try {
            await player.setAsset('assets/sounds/validated.mp3');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio");
          }
          isTrackingNumberScanned.value = true;
          scannedTrackingNumber.value = trackingNumber;
        } else {
          try {
            await player.setAsset('assets/sounds/warning.ogg');
            player.play();
          } catch (e) {
            debugPrint("Error while playing audio");
          }
          MyToast.myShowToast("Invalid Tracking Number");
          isTrackingNumberScanned.value = false;
        }
        debugPrint(validatePrintTrackingNumberResponse.toString());
      } else {
        isTrackingNumberScanned.value = false;
        debugPrint("API Response is null");
        MyToast.myShowToast("Internal Server Error \n Please Try Again Later");
      }
    } else {
      try {
        await player.setAsset('assets/sounds/warning.ogg');
        player.play();
      } catch (e) {
        debugPrint("Error while playing audio");
      }
      isTrackingNumberScanned.value = false;
      MyToast.myShowToast("Invalid Tracking Number");
    }
    printTrackingNumber.value.clear();
  }

  List<ScanResult> availableDevices =
      List<ScanResult>.empty(growable: true).obs;
  var isPermissionGranted = false.obs;
  var selectedIndex = -1.obs;
  var isPrinterConnected = false.obs;
  var connectionStatus = BluetoothConnectionState.disconnected.obs;
  Rxn<BluetoothCharacteristic> characteristic = Rxn<BluetoothCharacteristic>();
  // BluetoothCharacteristic? characteristic;
}

class AvailablePrinter {
  final String name;
  final String ipAddress;
  final bool isWifi;

  AvailablePrinter({
    required this.name,
    required this.ipAddress,
    this.isWifi = false,
  });
}
