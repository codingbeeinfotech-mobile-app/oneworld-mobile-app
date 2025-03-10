import 'dart:convert';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/model/request_model/npr_getVendorList_req.dart';
import 'package:abhilaya/model/request_model/submit_npr_requ.dart';
import 'package:abhilaya/model/request_model/vendor_data_req.dart';
import 'package:abhilaya/model/response_model/vendor_data_res.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/request_model/reason_list_request.dart';
import '../../model/response_model/npr_getVendorList_res.dart';
import '../../model/response_model/reason_list_response.dart';
import '../../utils/general/alert_boxes.dart';
import '../auth_controller/login_controller.dart';

class NprShipmentsController extends GetxController {
  var loginController = Get.find<LoginController>();
  var selectedVendor = "Select Vendor".obs;
  var selectedVendorId = 0.obs;
  bool isLoading = false;
  var vendorListResponse = Rx<GetVendorListResponse?>(null);
  List<VendorList> allVendorList = List<VendorList>.empty(growable: true).obs;

  var particularVendorData = Rx<GetVendorDataResponse?>(null);
  var pickUpLocationMap = <String, List<VendorData>>{}.obs;
  List<String> pickupLocations = List<String>.empty(growable: true).obs;
  var selectedPickupLocation = "Pickup Location".obs;
  var pickupLocationQuantity = 0.obs;

  var reasonListResponse = Rx<ReasonListResponse?>(null);
  List<ReasonInformation> nprReasonList =
      List<ReasonInformation>.empty(growable: true).obs;
  var selectedNprReason = "Select NPR".obs;
  var selectedNprReasonId = 0.obs;
  var allowVisibility = false.obs;

  callVendorListApi() async {
    allVendorList.clear();
    allVendorList.add(
        VendorList(vendorId: 1, vendorCode: "1", vendorName: "Select Vendor"));
    GetVendorListRequest request = GetVendorListRequest(
        clientId: 1, clientName: "One_World", companyId: 2);

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl5 + ApiUrl.getVendorList, request, "");

    if (response != null) {
      if (response['Flag'] == 1) {
        vendorListResponse.value = GetVendorListResponse.fromJson(response);

        for (int i = 0; i < vendorListResponse.value!.data.length; i++) {
          allVendorList.add(vendorListResponse.value!.data[i]);
        }
        pickupLocations.add("Pickup Location");
        // debugPrint(allVendorList.toString());
      } else {
        String msg = response['Flag_Msg'];
        MyToast.myShowToast(msg);
      }
    } else {
      debugPrint("get vendor list response = null");
      MyToast.myShowToast("Something went wrong");
    }
  }

  callParticularVendorDataApi() async {
    particularVendorData.value = null;
    pickUpLocationMap.clear();

    DateTime currentDetails = DateTime.now();
    GetVendorDataRequest request = GetVendorDataRequest(
        clientId: 1,
        clientName: "One_World",
        companyId: 2,
        vendorId: selectedVendorId.value,
        date: formatDate(currentDetails));
    // date: "2023-11-10");
    debugPrint(
        "json getVendorData request ${ApiUrl.baseUrl5 + ApiUrl.getVendorData}}");

//https://52.172.145.215:4430/API/TMS/GetVendorData
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl5 + ApiUrl.getVendorData, request, "");
    debugPrint(
        "json getVendorData request ${ApiUrl.baseUrl5 + ApiUrl.getVendorData} $response ${jsonEncode(request.toJson())}");

    if (response != null) {
      if (response['Flag'] == 1) {
        particularVendorData.value = GetVendorDataResponse.fromJson(response);

        for (int i = 0; i < particularVendorData.value!.data.length; i++) {
          String location = particularVendorData
              .value!.data[i].pickupLocationAddress.capitalize!;
          if (pickUpLocationMap.containsKey(location)) {
            pickUpLocationMap[location]!
                .add(particularVendorData.value!.data[i]);
          } else {
            pickUpLocationMap[location] = [particularVendorData.value!.data[i]];
          }
        }
        debugPrint(pickUpLocationMap.length.toString());

        debugPrint("Map goes like $pickUpLocationMap");
        fetchDataFromMap();
      } else {
        String flag = response['Flag_Msg'].toString();
        MyToast.myShowToast(flag);
      }
    } else {
      debugPrint("Vendor data response = null");
      MyToast.myShowToast("Something went wrong");
    }
  }

  fetchDataFromMap() {
    pickupLocations.clear();
    pickupLocations.add("Pickup Location");
    for (var entries in pickUpLocationMap.keys) {
      pickupLocations.add(entries);
    }

    debugPrint("Locations: ${pickupLocations.toString()}");

    if (pickupLocations.length == 1) {
      allowVisibility.value = false;
      pickupLocationQuantity.value = 0;
    }
  }

  fetchPickupLocation() {
    pickupLocationQuantity.value =
        pickUpLocationMap[selectedPickupLocation.value]!.length;
    debugPrint("quantity : ${pickupLocationQuantity.value}");
    allowVisibility.value = true;
    if (pickupLocationQuantity.value == 0) {
      allowVisibility.value = false;
    }
  }

  callGetNprReasonApi() async {
    nprReasonList.clear();
    ReasonInformation defaultReason =
        ReasonInformation(codeId: 0, codeDescription: "Select NPR");

    nprReasonList.add(defaultReason);

    ReasonListRequest reasonListRequest = ReasonListRequest(codeTypeId: "114");

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl5 + ApiUrl.getReasonList, reasonListRequest, "");
    if (response != null) {
      if (response['Flag'] == 1) {
        reasonListResponse.value = ReasonListResponse.fromJson(response);
        // debugPrint("reason response ${reasonListResponse.toString()}");

        for (int i = 0; i < reasonListResponse.value!.data.length; i++) {
          nprReasonList.add(reasonListResponse.value!.data[i]);
        }
      } else {
        String msg = response['Flag_Msg'];
        MyToast.myShowToast(msg);
      }
    } else {
      debugPrint("reason response = null");
    }
  }

  callSubmitNprApi(BuildContext context) async {
    Dialogs.signUpLoading(context);

    DefaultParam defaultParam = DefaultParam(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        userId: int.parse(loginController.loginResponse!.uSERID),
        roleId: loginController.loginResponse!.rOLEID.isEmpty
            ? 1
            : int.parse(loginController.loginResponse!.rOLEID));

    List<Param> param = [];

    var list = pickUpLocationMap[selectedPickupLocation.value];

    for (int i = 0; i < list!.length; i++) {
      Param tempParam = Param(
          odnId: int.parse(list[i].odnId),
          nonPickedUpReasonId: selectedNprReasonId.value,
          codeTypeId: "114");

      param.add(tempParam);
    }

    SubmitNprRequest request =
        SubmitNprRequest(defaultParam: defaultParam, param: param);

    // debugPrint("length : ${param.length}");
    debugPrint("request json ${jsonEncode(request.toJson())}");

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl5 + ApiUrl.submitNprShipments, request, "");

    if (response != null) {
      if (response['Flag'] == 1) {
        String msg = response['Flag_Msg'];
        MyToast.myShowToast(msg);
        print("here");
        Navigator.pop(context);
        selectedNprReason = "Select NPR".obs;
        allowVisibility.value = false;
        selectedVendor = "Select Vendor".obs;
        pickupLocations.clear();
        pickupLocations.add("Pickup Location");
        selectedPickupLocation = "Pickup Location".obs;
      } else {
        Navigator.pop(context);
        print("or here ");
        String msg = response['Flag_Msg'];
        MyToast.myShowToast(msg);
      }
    } else {
      debugPrint("Submit response = null");
      Navigator.pop(context);

    }
  }

  clearValues() {
    allowVisibility.value = false;
    allVendorList.clear();
    pickupLocations.clear();
    nprReasonList.clear();
    selectedVendorId.value = 0;
    selectedVendor.value = "Select Vendor";
    selectedNprReasonId.value = 0;
    selectedPickupLocation.value = "Pickup Location";
    selectedNprReason.value = "Select NPR";
  }

  String formatDate(DateTime now) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }
}
