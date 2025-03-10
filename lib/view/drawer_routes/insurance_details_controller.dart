import 'dart:convert';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/request_model/insurance_details_request.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/response_model/insurance_details_response.dart';

class InsuranceDetailsController extends GetxController {
  // final Rx<PDFDocument ?> pdfDocument = Rx<PDFDocument?>(null);
  var loginController = Get.find<LoginController>();

  var insurancePdfResponse = Rx<InsurancePdfResponse?>(null);

  callGetInsurancePdf() async {
    InsurancePdfRequest insurancePdfRequest = InsurancePdfRequest(
        // clientId: loginController.loginResponse!.cLIENTID,
        clientId: "8",
        clientName: loginController.loginResponse!.cLIENTNAME,
        contactNumberOfDriver: loginController.loginResponse!.mOBILENO,
        driverId: loginController.loginResponse!.uSERID);
    debugPrint("PDF Response ${jsonEncode(insurancePdfRequest.toJson())}");
    var response = await CallMasterApi.postApiCallBasicAuth(
        ApiUrl.baseUrl + ApiUrl.getInsuranceDetails, insurancePdfRequest);

    if (response != null) {
      insurancePdfResponse.value = InsurancePdfResponse.fromJson(response);
      debugPrint("Pdf Response Received ${insurancePdfResponse.toString()}");
    } else {
      debugPrint("PDF Response is null");
      MyToast.myShowToast("Can't get the files at the moment");
    }
  }
}
