import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:abhilaya/model/request_model/pincode_details_request.dart';
import 'package:abhilaya/model/request_model/signup_submit_request.dart';
import 'package:abhilaya/model/signup_model/driver_detail_model.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/auth/select_onBoarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../api/master_api/api_call.dart';
import '../../api/master_api/api_url.dart';
import '../../model/request_model/master_request.dart';
import '../../model/response_model/master_response.dart';
import '../../model/response_model/pincode_details_response.dart';
import '../../model/response_model/signup_submit_response.dart';
import '../../model/signup_model/registration_req.dart';
import '../../model/signup_model/registration_res.dart';

class SignupController extends GetxController {
  //OTP Controllers

  var otpPageCurrentStep = 0.obs;
  Rx<TextEditingController> signupMobileNumber = TextEditingController().obs;
  Rx<TextEditingController> alternateContactNumber =
      TextEditingController().obs;
  // Rx<TextEditingController> ContactNumber = TextEditingController().obs;
  Rx<FocusNode> signupMobileNumberFocusNode = FocusNode().obs;
  Rx<FocusNode> alternateContactNumberFocusNode = FocusNode().obs;
  Rx<FocusNode> ContactNumberFocusNode = FocusNode().obs;
  Rx<TextEditingController> signupOtpEntered = TextEditingController().obs;
  Rx<FocusNode> signupOtpEnteredFocusNode = FocusNode().obs;

  RxInt signupOtpSendValue = 0.obs;

  //SteeperForm Controllers

  RxString selectedOnBoardingType = "".obs;
  RxInt signupDriverId = 0.obs;
  RxBool useCurrentAddressAsPermanentAddress = false.obs;

  //For Page 1
  var signupSteeperCurrentPage = 0.obs;

  RxBool isTermsAccepted = false.obs;

  Rx<TextEditingController> voterId = TextEditingController().obs;
  Rx<FocusNode> voterIdFocusNode = FocusNode().obs;
  Rx<TextEditingController> username = TextEditingController().obs;
  Rx<FocusNode> usernameFocusNode = FocusNode().obs;
  Rx<TextEditingController> fristname = TextEditingController().obs;
  Rx<FocusNode> fristnameFocusNode = FocusNode().obs;
  Rx<TextEditingController> middlename = TextEditingController().obs;
  Rx<FocusNode> middlenameFocusNode = FocusNode().obs;
  Rx<TextEditingController> lastname = TextEditingController().obs;
  Rx<FocusNode> lastnameFocusNode = FocusNode().obs;
  Rx<TextEditingController> userEmail = TextEditingController().obs;
  Rx<FocusNode> userEmailFocusNode = FocusNode().obs;
  Rx<TextEditingController> userDob = TextEditingController().obs;
  Rx<TextEditingController> userDobDateApiFormat = TextEditingController().obs;
  Rx<FocusNode> userDobFocusNode = FocusNode().obs;
  Rx<TextEditingController> userCurrentAddress = TextEditingController().obs;
  Rx<FocusNode> userCurrentAddressFocusNode = FocusNode().obs;
  Rx<TextEditingController> userPermanentAddress = TextEditingController().obs;
  Rx<FocusNode> userPermanentAddressFocusNode = FocusNode().obs;
  Rx<TextEditingController> userPinCode = TextEditingController().obs;
  Rx<FocusNode> userPinCodeFocusNode = FocusNode().obs;
  Rx<TextEditingController> userStateController = TextEditingController().obs;
  Rx<FocusNode> userStateFocusNode = FocusNode().obs;
  Rx<TextEditingController> userCityController = TextEditingController().obs;
  Rx<FocusNode> userCityFocusNode = FocusNode().obs;
  Rx<FocusNode> userGenderFocusNode = FocusNode().obs;
  Rx<FocusNode> isTermsAcceptedFocusNode = FocusNode().obs;

  // Rx<FocusNode> userStateFocusNode = FocusNode().obs;
  // Rx<FocusNode> userCityFocusNode = FocusNode().obs;

  var userGender = "Select Gender".obs;
  var isAddressCopy = false.obs;
  var userState = "Select State".obs;
  var userCity = "Select City".obs;
  var stateId = "".obs;
  var cityId = "".obs;
  var waitingText = "Please Wait".obs;

  List<MasterResponse> masterList =
      List<MasterResponse>.empty(growable: true).obs;
  List<String> stateList = List<String>.empty(growable: true).obs;
  List<String> cityList = List<String>.empty(growable: true).obs;
  List<String> pinCodeList = List<String>.empty(growable: true).obs;

  var pinCodeResponse = Rx<PinCodeResponse?>(null);

  callGetDetailsByPinCodeDetailsApi(value) async {
    PinCodeRequest request = PinCodeRequest(
      pincode: value,
    );

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl2 + ApiUrl.getDetailsByPinCode, request, "");
    print("response pincode=-- $response");
    if (response != null) {
      pinCodeResponse.value = PinCodeResponse.fromJson(response);
      if (pinCodeResponse.value! != {}) {
        userStateController.value.text =
            pinCodeResponse.value!.state.toString();
        stateId.value = pinCodeResponse.value!.stateId.toString();
        userCityController.value.text = pinCodeResponse.value!.city.toString();
        cityId.value = pinCodeResponse.value!.cityId.toString();
      } else {
        MyToast.myShowToast("Please enter Valid Pincode");
        userStateController.value.clear();
        userCityController.value.clear();
        userPinCode.value.clear();
        stateId.value = "";
        cityId.value = ""; //6549873211
      }
    }
  }

  callMasterApi() async {
    debugPrint("CALLLEDDD");
    MasterRequest req = MasterRequest(
        //cLIENTID: '7',
        // cLIENTNAME: ''
        cLIENTID: '8',
        cLIENTNAME: 'one_world');
    String token =
        "2Cf3FyZ8UYMBojjQiLNtzuN6pNWE7itD87HnG0m36tWjKNv6Lg2hRsZRgqxjFTDAvKu6kxsdj0UNpeTlZbMtKg5yA4p0qR84IUgZPx8K36Vxl7WZzRELqDUq48wjlF5kt1nO1FNDl69sU9O9ewuVbxhF9Url_8oZaNipHMO5Bd8";
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl2 + ApiUrl.master, req, token);
    if (response != null) {
      log("responseresponse=-=-0 ${req.toJson()}   ");

      debugPrint("From Masters");
      for (int i = 0; i < response.length; i++) {
        masterList.add(MasterResponse.fromJson(response[i]));
      }
    } else {
      debugPrint('Master Response fetch failed');
    }
  }

  getState() {
    stateList.add("Select State");
    for (int i = 0; i < masterList.length; i++) {
      if (masterList[i].mTypeID == 124) {
        stateList.add(masterList[i].mName);
      }
    }
  }

  getCity() {
    cityList.add('Select City');
    for (int k = 0; k < masterList.length; k++) {
      if (masterList[k].mParentID == stateId.value &&
          masterList[k].mTypeName == 'City' &&
          masterList[k].mName != 'City') {
        cityList.add(masterList[k].mName);
      }
    }
  }

  // getPinCode(){
  //   pinCodeList.add("Select PinCode");
  //   for(int j=0;j<masterList.length;j++){
  //     if(masterList[j].mParentID == hubCodeId.value ){
  //       pinCodeList.add(masterList[j].mName);
  //     }
  //   }
  // }

  //For Page2

  // DL Information
  RxList<BloodType> dlVehicleTypeList = <BloodType>[].obs;
  var userDlVehicleType = "Select Vehicle Type".obs;
  var userDlVehicleTypeId = "".obs;
  RxList<BloodType> selectedDlVehicleTypeList = <BloodType>[].obs;

  RxList<BloodType> dLTypeList = <BloodType>[].obs;
  var userDLType = "Select DL Type".obs;
  String userDLTypeId = "";

  // Vehicle Information
  RxList<BloodType> vehicleTypeList = <BloodType>[].obs;
  var userVehicleType = "Select Vehicle Type".obs;
  var userVehicleTypeId = "".obs;

  // List<String> vehicleTypeList = List<String>.empty(growable: true).obs;

  Rx<TextEditingController> userAadhaarNumber = TextEditingController().obs;
  Rx<FocusNode> userAadhaarNumberFocusNode = FocusNode().obs;
  Rx<TextEditingController> userPanNumber = TextEditingController().obs;
  Rx<FocusNode> userPanNumberFocusNode = FocusNode().obs;
  Rx<TextEditingController> userDLNumber = TextEditingController().obs;
  Rx<FocusNode> userDLNumberFocusNode = FocusNode().obs;
  Rx<FocusNode> userDLTypeFocusNode = FocusNode().obs;

  Rx<TextEditingController> userVehicleNumber = TextEditingController().obs;
  Rx<FocusNode> userVehicleNumberFocusNode = FocusNode().obs;

  Rx<Uint8List?> userDLFrontSideImageByte = Uint8List(0).obs;
  Rx<File?> userDLFrontSideSelectedImage = File('').obs;
  Rx<Uint8List?> userDLBackSideImageByte = Uint8List(0).obs;
  Rx<File?> userDLBackSideSelectedImage = File('').obs;

  Rx<Uint8List?> userAadhaarFrontSideImageByte = Uint8List(0).obs;
  Rx<File?> userAadhaarFrontSideSelectedImage = File('').obs;
  Rx<Uint8List?> userAadhaarBackSideImageByte = Uint8List(0).obs;
  Rx<File?> userAadhaarBackSideSelectedImage = File('').obs;
  Rx<Uint8List?> userPanImageByte = Uint8List(0).obs;
  Rx<File?> userPanSelectedImage = File('').obs;
  Rx<Uint8List?> userSelfieImageByte = Uint8List(0).obs;
  Rx<File?> userSelfieSelectedImage = File('').obs;

  Future<void> getDlVehicleTypeList() async {
    dlVehicleTypeList.clear();
    // dlVehicleTypeList.add(BloodType(
    //   name: "Select Vehicle Type",
    //   value: "0",
    //   isActive: false,
    // ));

    var response = await CallMasterApi.getApiCall(
        ApiUrl.baseUrl2 + ApiUrl.dlVehicleTypeList, "");
    if (response != null) {
      for (var item in response) {
        dlVehicleTypeList.add(BloodType.fromJson(item));
      }
    } else {
      debugPrint('Get Dl VehicleType Response fetch failed');
    }
  }

  Future<void> getVehicleTypeList() async {
    vehicleTypeList.clear();
    vehicleTypeList.add(BloodType(
      name: "Select Vehicle Type",
      value: "0",
      isActive: false,
    ));

    var response = await CallMasterApi.getApiCall(
        ApiUrl.baseUrl2 + ApiUrl.vehicleTypeList, "");
    if (response != null) {
      for (var item in response) {
        vehicleTypeList.add(BloodType.fromJson(item));
      }
    } else {
      debugPrint('Get VehicleType Response fetch failed');
    }
  }

  getDlTypeList() async {
    dLTypeList.clear();
    dLTypeList.add(BloodType(
      name: "Select DL Type",
      value: "0",
      isActive: false,
    ));

    var response =
        await CallMasterApi.getApiCall(ApiUrl.baseUrl2 + ApiUrl.dlTypeList, "");
    if (response != null) {
      for (var item in response) {
        dLTypeList.add(BloodType.fromJson(item));
      }
    } else {
      debugPrint('Get DL Type Response fetch failed');
    }
  }

  ///Page 3

  List<String> businessList = List<String>.empty(growable: true).obs;
  List<String> departmentList = List<String>.empty(growable: true).obs;
  List<String> departmentStateList = List<String>.empty(growable: true).obs;
  List<String> businessUnitList = List<String>.empty(growable: true).obs;

  var selectedBusiness = "Select your Business".obs;
  FocusNode selectedBusinessFocusNode = FocusNode();
  var selectedBusinessId = "".obs;
  var selectedDepartment = "Select your Department".obs;
  var selectedDepartmentId = "".obs;
  FocusNode selectedDepartmentFocusNode = FocusNode();
  var selectedDepartmentState = "Select your State".obs;
  var selectedDepartmentStateId = "".obs;
  FocusNode selectedDepartmentStateFocusNode = FocusNode();
  var selectedBusinessUnit = "Select your Business Unit".obs;
  var selectedBusinessUnitId = "".obs;
  FocusNode selectedBusinessUnitFocusNode = FocusNode();

  getBusinessList() {
    businessList.add("Select your Business");
    for (int i = 0; i < masterList.length; i++) {
      if (masterList[i].mTypeID == 117) {
        businessList.add(masterList[i].mName);
      }
    }
  }

  getDepartmentList() {
    departmentList.add("Select your Department");
    if (selectedBusinessId.isNotEmpty) {
      for (int i = 0; i < masterList.length; i++) {
        if (masterList[i].mParentID.toString() == selectedBusinessId.value) {
          departmentList.add(masterList[i].mName);
        }
      }
    }
  }

  getDepartmentStateList() {
    departmentStateList.add("Select your State");
    if (selectedDepartmentId.isNotEmpty) {
      for (int i = 0; i < masterList.length; i++) {
        if (masterList[i].mParentID.toString() == selectedDepartmentId.value) {
          departmentStateList.add(masterList[i].mName);
        }
      }
    }
  }

  getBusinessUnitList() {
    businessUnitList.add("Select your Business Unit");
    if (selectedDepartmentStateId.isNotEmpty) {
      for (int i = 0; i < masterList.length; i++) {
        if (masterList[i].mParentID.toString() ==
            selectedDepartmentStateId.value) {
          businessUnitList.add(masterList[i].mName);
        }
      }
    }
  }

  ///For Page 4

  RxString userHaveDrivingLicence = "".obs;

  List<String> bankList = List<String>.empty(growable: true).obs;
  RxList<String> filterBankList = <String>[].obs;

  void filterBanks(String query) {
    filterBankList.clear(); // Clear first to avoid duplicates

    if (query.trim().isNotEmpty) {
      filterBankList.assignAll(
        bankList
            .where((bank) => bank.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    } else {
      filterBankList.assignAll(bankList);
    }
    // Ensure "Select Bank" is always the first item
    filterBankList.remove("Select Bank");
    filterBankList.insert(0, "Select Bank");

    filterBankList.refresh();
  }

  var selectedBank = "Select Bank".obs;
  var selectedBankId = "0".obs;
  var selectedNomineeRelation = "Select Nominee Relation".obs;

  Rx<TextEditingController> serachBankController = TextEditingController().obs;
  Rx<TextEditingController> accountHolderName = TextEditingController().obs;
  Rx<FocusNode> accountHolderNameFocusNode = FocusNode().obs;
  Rx<TextEditingController> branchName = TextEditingController().obs;
  Rx<FocusNode> branchNameFocusNode = FocusNode().obs;
  Rx<TextEditingController> accountNumber = TextEditingController().obs;
  Rx<FocusNode> accountNumberFocusNode = FocusNode().obs;
  Rx<TextEditingController> ifscCode = TextEditingController().obs;
  Rx<FocusNode> ifscCodeFocusNode = FocusNode().obs;
  Rx<TextEditingController> nomineeName = TextEditingController().obs;
  Rx<FocusNode> nomineeNameFocusNode = FocusNode().obs;
  Rx<TextEditingController> nomineeContactNumber = TextEditingController().obs;
  Rx<FocusNode> nomineeContactNumberFocusNode = FocusNode().obs;

  Rx<TextEditingController> userDlIssueDate = TextEditingController().obs;
  Rx<TextEditingController> userDlIssueDateApiFormat =
      TextEditingController().obs;
  Rx<FocusNode> userDlIssueDateFocusNode = FocusNode().obs;

  Rx<TextEditingController> userDlExpireDate = TextEditingController().obs;
  Rx<TextEditingController> userDlExpireDateApiFormat =
      TextEditingController().obs;
  Rx<FocusNode> userDlExpireDateFocusNode = FocusNode().obs;

  Rx<Uint8List?> passbookImageByte = Uint8List(0).obs;
  Rx<File?> passbookSelectedImage = File('').obs;

  // getBank() {
  //   bankList.add("Select Bank");
  //   for (int i = 0; i < masterList.length; i++) {
  //     if (masterList[i].mTypeID == 116 &&
  //         masterList[i].mTypeName == 'Bank name') {
  //       bankList.add(masterList[i].mName);
  //     }
  //   }
  // }

  void getBank() {
    bankList.clear();
    bankList.add("Select Bank");
    for (int i = 0; i < masterList.length; i++) {
      if (masterList[i].mTypeID == 116 &&
          masterList[i].mTypeName == 'Bank name') {
        if (!bankList.contains(masterList[i].mName)) {
          bankList.add(masterList[i].mName);
        }
      }
    }
    bankList = [
      "Select Bank",
      ...bankList.sublist(1)
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()))
    ];
  }

  ///For Page 5

  var selectedBloodGroup = "Select Blood Group".obs;
  var selectedBloodGroupId = "".obs;

  RxList<BloodType> selectedBloodGroupList = <BloodType>[].obs;
  getBloodGroup() async {
    log("Fetching Blood Groups...");

    var response = await CallMasterApi.postApiCallWithoutBody(
        ApiUrl.baseUrl6 + ApiUrl.getBloodGroupList, '');

    // Clear list before adding new items
    selectedBloodGroupList.clear();

    // Add default item
    selectedBloodGroupList.add(BloodType(
      name: "Select Blood Group",
      value: '0',
      description: '',
      isActive: false,
    ));

    if (response != null) {
      log("Response received: $response");

      for (var item in response) {
        selectedBloodGroupList.add(BloodType.fromJson(item));
      }
    } else {
      debugPrint('Failed to fetch Blood Groups');
    }
  }

  Rx<TextEditingController> bloodGroup = TextEditingController().obs;
  Rx<FocusNode> bloodGroupFocusNode = FocusNode().obs;
  Rx<TextEditingController> designation = TextEditingController().obs;
  Rx<FocusNode> designationFocusNode = FocusNode().obs;
  Rx<TextEditingController> daCategory = TextEditingController().obs;
  Rx<FocusNode> daCategoryFocusNode = FocusNode().obs;
  Rx<TextEditingController> approverName = TextEditingController().obs;
  Rx<FocusNode> approverNameFocusNode = FocusNode().obs;
  Rx<TextEditingController> approverEmpId = TextEditingController().obs;
  Rx<FocusNode> approverEmpIdFocusNode = FocusNode().obs;
  Rx<TextEditingController> businessId = TextEditingController().obs;
  Rx<FocusNode> businessIdFocusNode = FocusNode().obs;
  Rx<TextEditingController> route = TextEditingController().obs;
  Rx<FocusNode> routeFocusNode = FocusNode().obs;
  Rx<TextEditingController> paymentType = TextEditingController().obs;
  Rx<FocusNode> paymentTypeFocusNode = FocusNode().obs;
  Rx<TextEditingController> fixAmount = TextEditingController().obs;
  Rx<FocusNode> fixAmountFocusNode = FocusNode().obs;
  Rx<TextEditingController> variableAmount = TextEditingController().obs;
  Rx<FocusNode> variableAmountFocusNode = FocusNode().obs;
  Rx<TextEditingController> fuelAmount = TextEditingController().obs;
  Rx<FocusNode> fuelAmountFocusNode = FocusNode().obs;
  Rx<TextEditingController> fixVariable = TextEditingController().obs;
  Rx<FocusNode> fixVariableFocusNode = FocusNode().obs;
  Rx<TextEditingController> fixRateAmount = TextEditingController().obs;
  Rx<FocusNode> fixRateAmountFocusNode = FocusNode().obs;
  Rx<TextEditingController> payFrequency = TextEditingController().obs;
  Rx<FocusNode> payFrequencyFocusNode = FocusNode().obs;

  var submitApiResponse = Rx<SubmitSignupResponse?>(null);
  var isLottieCalled = false.obs;

  callSignUpSubmitApi(BuildContext context) async {
    debugPrint("DriverName... ${username.value.text.trim()}");
    debugPrint("DlTypeIds... ${userDlVehicleTypeId.value}");
    debugPrint("HaveDrivingLicense... ${userHaveDrivingLicence.value}");
    debugPrint("VehicleTypeId... ${userVehicleTypeId.value.trim()}");
    debugPrint("VehicleType... ${userVehicleType.value.trim()}");
    debugPrint("VehicleNo... ${userVehicleNumber.value.text.trim()}");
    debugPrint("RcPhoto... ${userRcBase64.value}");
    debugPrint("OnBoardingType... ${selectedOnBoardingType.value}");
    debugPrint("EmailId... ${userEmail.value.text.trim()}");
    debugPrint("DateOfBirth... ${userDobDateApiFormat.value.text.trim()}");
    debugPrint("CurrentAddress... ${userCurrentAddress.value.text.trim()}");
    debugPrint("PermanentAddress... ${userPermanentAddress.value.text.trim()}");
    debugPrint("Gender... ${userGender.value}");
    debugPrint("PinCode... ${userPinCode.value.text.trim()}");
    debugPrint("StateId... ${stateId.value}");
    debugPrint("CityId... ${cityId.value}");
    debugPrint("MobileNo... ${signupMobileNumber.value.text.trim()}");
    debugPrint("AadharCardNumber... ${userAadhaarNumber.value.text.trim()}");
    debugPrint("PanCardNumber... ${userPanNumber.value.text.trim()}");
    debugPrint("DrivingLicenseNumber... ${userDLNumber.value.text.trim()}");
    debugPrint(
        "DrivingLicenseIssueDate... ${userDlIssueDateApiFormat.value.text.trim()}");
    debugPrint(
        "DrivingLicenseExpiryDate... ${userDlExpireDateApiFormat.value.text.trim()}");
    debugPrint(
        "DrivingLicenseFrontSide... ${userDLFrontSideSelectedImage.value!.path}");
    debugPrint(
        "DrivingLicenseBackSide... ${userDLBackSideSelectedImage.value!.path}");
    debugPrint("AadharCardFrontSide... ${aadhaarFrontImageBase64.value}");
    debugPrint("AadharCardBackSide... ${aadhaarBackImageBase64.value}");
    debugPrint("BranchId... ${selectedBankId.value}");
    debugPrint("Blood group... ${selectedBloodGroupId.value}");
    debugPrint("Branch... ${selectedBank.value}");
    debugPrint("BusinessId... ${selectedBusinessId.value.trim()}");
    debugPrint("Business... ${selectedBusiness.value.trim()}");
    debugPrint("DepartmentId... ${selectedDepartmentId.value.trim()}");
    debugPrint("Department... ${selectedDepartment.value.trim().toString()}");
    debugPrint("BranchStateId... ${selectedDepartmentStateId.value.trim()}");
    debugPrint("BranchStateName... ${selectedDepartmentState.value.trim()}");
    debugPrint(
        "BusinessUnitId... ${selectedBusinessUnitId.value.trim().toString()}");
    debugPrint("BusinessUnit... ${selectedBusinessUnit.value}");
    debugPrint("userDlVehicleTypeId... ${userDlVehicleTypeId.value.trim()}");
    debugPrint("BankName... ${selectedBank.value.trim()}");
    debugPrint("BranchName... ${branchName.value.text.trim()}");
    debugPrint("AccountHolderName... ${accountHolderName.value.text.trim()}");
    debugPrint("AccountNumber... ${accountNumber.value.text.trim()}");
    debugPrint("IFSCCode... ${ifscCode.value.text.trim()}");
    debugPrint("PassbookCancelCheque... ${passbookImageBase64.value}");
    debugPrint("NomineeName... ${nomineeName.value.text.trim()}");
    debugPrint("NomineeContactNo... ${nomineeContactNumber.value.text.trim()}");
//I/flutter (  491): DriverName... test
// I/flutter (  491): EmailId... test@gmail.com
// I/flutter (  491): DateOfBirth... 01/01/1990
// I/flutter (  491): CurrentAddress... test
// I/flutter (  491): PermanentAddress... test
// I/flutter (  491): Gender... Female
// I/flutter (  491): PinCode... 400001
// I/flutter (  491): StateId... 27
// I/flutter (  491): CityId... 5073
// I/flutter (  491): MobileNo... 7096042224
// I/flutter (  491): VehicleTypeId... 1
// I/flutter (  491): VehicleType... BIKE
// I/flutter (  491): AadharCardNumber... 545464664649
// I/flutter (  491): PanCardNumber... FDNPP2081P
// I/flutter (  491): DrivingLicenseNumber... DL-1220118282838
// I/flutter (  491): DrivingLicenseIssueDate... 01/01/2024
// I/flutter (  491): DrivingLicenseExpiryDate... 27/01/2025
// I/flutter (  491): DrivingLicenseFrontSide...
// I/flutter (  491): DrivingLicenseBackSide...
// I/flutter (  491): AadharCardFrontSide... /9j/4QMERXhpZgAATU0AKgAAAAgACAEAAAQAAAABAAAf4AEQAAIAAAARAAAAbgEBAAQAAAABAAAOuAEPAAIAAAAIAAAAfwExAAIAAAAOAAAAh4dpAAQAAAABAAAAqQESAAMAAAABAAYAAAEyAAIAAAAUAAAAlQAAAABHYWxheHkgUzI0IFVsdHJhAHNhbXN1bmcAUzkyOEJYWFM0QVhLQQAyMDI1OjAxOjI3IDE0OjQ1OjQ4AAAbkAAAAgAAAAUAAAHzkgIABQAAAAEAAAH4kgQACgAAAAEAAAIAiCIAAwAAAAEAAgAApCAAAgAAAAwAAAIIkgUABQAAAAEAAAIUkAMAAgAAABQAAAIcoAAAAgAAAAUAAAIwkpEAAgAAAAQyNzAApAMAAwAAAAEAAAAApAIAAwAAAAEAAAAAgpoABQAAAAEAAAI1kBAAAgAAAAcAAAI9kgkAAwAAAAEAAAAAkpAAAgAAAAQyNzAAgp0ABQAAAAEAAAJEiCcAAwAAAAEE4gAApAUAAwAAAAEAFwAAkpIAAgAAAAQyNzAApAQABQAAAAEAAAJMkAQAAgAAABQAAAJUkgEACgAAAAEAAAJokgcAAwAAAAEAAgAAkgoABQAAAAEAAAJwkBEAAgAAAAcAAAJ4pAYAAwAAAAEAAAAAkggAAwAAAAEAAAAAAAAAADAyMjAAAAAAmQAAAGQAAAAAAAAAZEhLMFhMUUUwMFNNAAAAAJkAAABkMjAyNTowMToyNyAxNDo0NTo0OAAwMTAwAAAAAkwAACcQKzA1OjMwAAAAQmgAACcQAAAnEAAAJxAyMDI1OjAxOjI3IDE0OjQ1OjQ4AAAAAAEAAAARAAACdgAAAGQrMDU6MzAAAAUBEAACAAAAEQAAAsEBDwACAAAACAAAAtIBMQACAAAADgAAAtoBEgADAAAAAQAGAAABMgACAAAAFAAAAugAAAAAR2FsYXh5IFMyNCBVbHRyYQBzYW1zdW5nAFM5MjhCWFhT
// I/flutter (  491): AadharCardBackSide... /9j/4QMERXhpZgAATU0AKgAAAAgACAEAAAQAAAABAAAf4AEQAAIAAAARAAAAbgEBAAQAAAABAAAOuAEPAAIAAAAIAAAAfwExAAIAAAAOAAAAh4dpAAQAAAABAAAAqQESAAMAAAABAAYAAAEyAAIAAAAUAAAAlQAAAABHYWxheHkgUzI0IFVsdHJhAHNhbXN1bmcAUzkyOEJYWFM0QVhLQQAyMDI1OjAxOjI3IDE0OjQ1OjU1AAAbkAAAAgAAAAUAAAHzkgIABQAAAAEAAAH4kgQACgAAAAEAAAIAiCIAAwAAAAEAAgAApCAAAgAAAAwAAAIIkgUABQAAAAEAAAIUkAMAAgAAABQAAAIcoAAAAgAAAAUAAAIwkpEAAgAAAAQ1NDIApAMAAwAAAAEAAAAApAIAAwAAAAEAAAAAgpoABQAAAAEAAAI1kBAAAgAAAAcAAAI9kgkAAwAAAAEAAAAAkpAAAgAAAAQ1NDIAgp0ABQAAAAEAAAJEiCcAAwAAAAEGQAAApAUAAwAAAAEAFwAAkpIAAgAAAAQ1NDIApAQABQAAAAEAAAJMkAQAAgAAABQAAAJUkgEACgAAAAEAAAJokgcAAwAAAAEAAgAAkgoABQAAAAEAAAJwkBEAAgAAAAcAAAJ4pAYAAwAAAAEAAAAAkggAAwAAAAEAAAAAAAAAADAyMjAAAAAAmQAAAGQAAAAAAAAAZEhLMFhMUUUwMFNNAAAAAJkAAABkMjAyNTowMToyNyAxNDo0NTo1NQAwMTAwAAAAAfQAACcQKzA1OjMwAAAAQmgAACcQAAAnEAAAJxAyMDI1OjAxOjI3IDE0OjQ1OjU1AAAAAAEAAAAUAAACdgAAAGQrMDU6MzAAAAUBEAACAAAAEQAAAsEBDwACAAAACAAAAtIBMQACAAAADgAAAtoBEgADAAAAAQAGAAABMgACAAAAFAAAAugAAAAAR2FsYXh5IFMyNCBVbHRyYQBzYW1zdW5nAFM5MjhCWFhTN
//I/flutter (  491): BranchId... 22
// I/flutter (  491): Branch... HDFC BANK
// I/flutter (  491): BusinessId... 2
// I/flutter (  491): Business... Flipkart
// I/flutter (  491): DepartmentId... 123
// I/flutter (  491): Department... BLRG
// I/flutter (  491): BranchStateId... 5118
// I/flutter (  491): BranchStateName... POLASARA
// I/flutter (  491): BusinessUnitId... 5131
// I/flutter (  491): BusinessUnit... 4979
// I/flutter (  491): BankId... 22
// I/flutter (  491): BankName... HDFC BANK
// I/flutter (  491): AccountHolderName... jsjjd
// I/flutter (  491): AccountNumber... 6495956569446
// I/flutter (  491): IFSCCode... HDFC0009214
// I/flutter (  491): PassbookCancelCheque... /9j/4QMERXhpZgAATU0AKgAAAAgACAEAAAQAAAABAAAf4AEQAAIAAAARAAAAbgEBAAQAAAABAAAOuAEPAAIAAAAIAAAAfwExAAIAAAAOAAAAh4dpAAQAAAABAAAAqQESAAMAAAABAAYAAAEyAAIAAAAUAAAAlQAAAABHYWxheHkgUzI0IFVsdHJhAHNhbXN1bmcAUzkyOEJYWFM0QVhLQQAyMDI1OjAxOjI3IDE0OjQ4OjQyAAAbkAAAAgAAAAUAAAHzkgIABQAAAAEAAAH4kgQACgAAAAEAAAIAiCIAAwAAAAEAAgAApCAAAgAAAAwAAAIIkgUABQAAAAEAAAIUkAMAAgAAABQAAAIcoAAAAgAAAAUAAAIwkpEAAgAAAAQ2NDkApAMAAwAAAAEAAAAApAIAAwAAAAEAAAAAgpoABQAAAAEAAAI1kBAAAgAAAAcAAAI9kgkAAwAAAAEAAAAAkpAAAgAAAAQ2NDkAgp0ABQAAAAEAAAJEiCcAAwAAAAED6AAApAUAAwAAAAEAFwAAkpIAAgAAAAQ2NDkApAQABQAAAAEAAAJMkAQAAgAAABQAAAJUkgEACgAAAAEAAAJokgcAAwAAAAEAAgAAkgoABQAAAAEAAAJwkBEAAgAAAAcAAAJ4pAYAAwAAAAEAAAAAkggAAwAAAAEAAAAAAAAAADAyMjAAAAAAmQAAAGQAAAAAAAAAZEhLMFhMUUUwMFNNAAAAAJkAAABkMjAyNTowMToyNyAxNDo0ODo0MgAwMTAwAAAAAZAAACcQKzA1OjMwAAAAQmgAACcQAAAnEAAAJxAyMDI1OjAxOjI3IDE0OjQ4OjQyAAAAAAEAAAAZAAACdgAAAGQrMDU6MzAAAAUBEAACAAAAEQAAAsEBDwACAAAACAAAAtIBMQACAAAADgAAAtoBEgADAAAAAQAGAAABMgACAAAAFAAAAugAAAAAR2FsYXh5IFMyNCBVbHRyYQBzYW1zdW5nAFM5MjhCWFh
// I/flutter (  491): NomineeName... test
// I/flutter (  491): NomineeContactNo... 2546464646
    SubmitSignupRequest signupRequest = SubmitSignupRequest(
      signupDriverId: signupDriverId.value,
      alternativeMobileNo: alternateContactNumber.value.text.trim(),
      rcPhoto: userRcBase64.value,
      haveDrivingLicense: userHaveDrivingLicence.value == "Yes" ? true : false,
      vehicleNo: userVehicleNumber.value.text,
      dlVehicleTypeIds: userDlVehicleTypeId.value.toString(),
      dlTypeId: userDLTypeId,
      useCurrentAddressAsPermanentAddress:
          useCurrentAddressAsPermanentAddress.value,
      //onboardingType: selectedOnBoardingType.value,
      //resreRelationshipStorePartner: selectedNomineeRelation.value.trim(),
      // nomineeName: nomineeName.value.text.trim(),
      // nomineeContactNo: nomineeContactNumber.value.text.trim(),
      // driverName: username.value.text.trim(),
      mobileNo: signupMobileNumber.value.text.trim(),
      emailId: userEmail.value.text.trim(),
      cityId: int.parse(cityId.value),
      stateId: int.parse(stateId.value),
      currentAddress: userCurrentAddress.value.text.trim(),
      pinCode: userPinCode.value.text.trim(),
      drivingLicenseIssueDate: userDlIssueDateApiFormat.value.text.trim(),
      drivingLicenseBackSide: userDLBackSideBase64.value,
      drivingLicenseFrontSide: userDLFrontSideBase64.value,
      drivingLicenseExpiryDate: userDlExpireDateApiFormat.value.text.trim(),
      //  storeFrontPictureName: selfieConvertedImage,
      aadharCardNumber: userAadhaarNumber.value.text.trim(),
      aadharCardFrontSide: aadhaarFrontImageBase64.value,
      aadharCardBackSide: aadhaarBackImageBase64.value,
      panCardNumber: userPanNumber.value.text.trim(),
      voterId: voterId.value.text.trim(),
      // ownerPanCard: panCardConvertedImage,
      // bankName: selectedBank.value.trim(),
      // bankId: int.parse(selectedBankId.value.trim()),
      // accountHolderName: accountHolderName.value.text.trim(),
      // accountNumber: accountNumber.value.text.trim(),
      // ifscCode: ifscCode.value.text.trim(),
      // passbookCancelCheque: passbookImageBase64.value,
      // businessId: 0,
      // business: '',
      // departmentId: 0,
      // businessUnitId: 0,
      // businessUnit: '',
      // department: '',
      permanentAddress: userPermanentAddress.value.text.trim(),
      vehicleTypeId: int.parse(userVehicleTypeId.value.trim()),
      // vehicleType: userVehicleType.value.trim(),
      drivingLicenseNumber: userDLNumber.value.text.trim(),
      // branchStateId: 0,
      // branchStateName: '',
      dateOfBirth: userDobDateApiFormat.value.text.trim(),
      // nomineeRelation: selectedNomineeRelation.value,
      panCardImage: panCardImageBase64.value,
      selfie: selfieImageBase64.value,
      gender: userGender.value,
      bloodGroupId: int.parse(selectedBloodGroupId.value),
      // designation: designation.value.text.trim(),
      // doctorCategory: daCategory.value.text.trim(),
      // approverEmpID: approverEmpId.value.text.trim(),
      // route: route.value.text,
      // variableAmount: variableAmount.value.text,
      // fixAmount: fixAmount.value.text,
      // paymentType: paymentType.value.text,
      // fixVariable: fixVariable.value.text.trim(),
      // fuelAmount: fuelAmount.value.text.trim(),
      // fixRateAmount: fixRateAmount.value.text.trim(),
      // payFrequency: payFrequency.value.text.trim(),
      // approverName: approverName.value.text.trim(),
      firstName: fristname.value.text.trim(),
      middleName: middlename.value.text.trim(),
      lastName: lastname.value.text.trim(),
      // alterMobileNo: alternateContactNumber.value.text.trim(),
      // drivingLicenseType: userDLType.value.trim(),
      voterIdFrontSide: userVoterDLFrontSideBase64.value,
      voterIdBackSide: userVoterDLBackSideBase64.value,
      // twoWheelerDrivingLicenseNumber: userDLNumber.value.text.trim(),
      // threeWheelerDrivingLicenseNumber: userDLNumber.value.text.trim(),
      // fourWheelerDrivingLicenseNumber: userDLNumber.value.text.trim(),
      twoWheelerDrivingLicenseNumber: userDlVehicleType.value == "BIKE" ||
              userDlVehicleType.value == "BICYCLE"
          ? userDLNumber.value.text.trim()
          : "",
      threeWheelerDrivingLicenseNumber: "",
      fourWheelerDrivingLicenseNumber:
          userDlVehicleType.value == "VAN" || userDlVehicleType.value == "CAR"
              ? userDLNumber.value.text.trim()
              : "",
      // branchName: branchName.value.text.trim(),
    );

    debugPrint("DATA MAPPEDs");
    // debugPrint("debugPrint image ${passbookImageByte.value!.toList()}");
    debugPrint(jsonEncode(signupRequest.toJson()));
    debugPrint(signupRequest.toString());
    var response = await CallMasterApi.postApiCallBasicAuth(
        ApiUrl.baseUrl6 + ApiUrl.signUpSubmit, signupRequest);

    if (response != null) {
      debugPrint("Response Received $response");
      submitApiResponse.value = SubmitSignupResponse.fromJson(response);

      // debugPrint("Request again ${submitApiResponse.value}");
      // debugPrint("Request again ${submitApiResponse.value}");

      if (submitApiResponse.value!.insertId != 0) {
        debugPrint("Submit Successfully");
        signupSteeperCurrentPage.value = 0;
      } else {
        debugPrint("Response received but submission failed");
      }
    } else {
      debugPrint("API FAILED");
    }
  }

  ///Aadhaar Front Image
  List<Uint8List> aadhaarFrontImageList = <Uint8List>[].obs;
  List<int> aadhaarFrontConvertedImage = [];
  var aadharFrontImageBytes;
  RxString aadhaarFrontImageBase64 = ''.obs;

  void aadhaarFrontSelectImage(String imagePath) {
    aadharFrontImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(aadharFrontImageBytes);
    aadhaarFrontImageList.clear();
    aadhaarFrontImageList.add(imageBytes);
    aadhaarFrontConvertedImage =
        aadhaarFrontImageList.expand((Int8List) => Int8List).toList();
    aadhaarFrontImageBase64.value = base64Encode(aadhaarFrontConvertedImage);

    debugPrint("$aadhaarFrontConvertedImage");
  }

  final ImagePicker aadhaarFrontImagePicker = ImagePicker();
  var aadhaarFrontImage;

  Future<void> aadhaarFrontShowImage(ImageSource source) async {
    aadhaarFrontImage = await aadhaarFrontImagePicker.pickImage(
        source: source, imageQuality: 50);
    if (aadhaarFrontShowImage != null) {
      aadhaarFrontSelectImage(aadhaarFrontImage.path);
    }
  }

  ///Aadhaar Back Image
  List<Uint8List> aadhaarBackImageList = <Uint8List>[].obs;
  List<int> aadhaarBackConvertedImage = [];
  var aadhaarBackImageBytes;
  RxString aadhaarBackImageBase64 = ''.obs;

  void aadhaarBackSelectImage(String imagePath) {
    aadhaarBackImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(aadhaarBackImageBytes);
    aadhaarBackImageList.clear();
    aadhaarBackImageList.add(imageBytes);
    aadhaarBackConvertedImage =
        aadhaarBackImageList.expand((Uint8List) => Uint8List).toList();
    aadhaarBackImageBase64.value = base64Encode(aadhaarBackConvertedImage);

    debugPrint("$aadhaarBackConvertedImage");
  }

  final ImagePicker aadhaarBackImagePicker = ImagePicker();
  var aadhaarBackImage;

  Future<void> aadhaarBackShowImage(ImageSource source) async {
    aadhaarBackImage = await aadhaarBackImagePicker.pickImage(
        source: source, imageQuality: 50);
    if (aadhaarBackShowImage != null) {
      aadhaarBackSelectImage(aadhaarBackImage.path);
    }
  }

  ///Voter ID Front Side
  List<Uint8List> voterDLFrontImageList = <Uint8List>[].obs;
  List<int> voterDLFrontConvertedImage = [];
  var voterDLFrontImageBytes;
  RxString userVoterDLFrontSideBase64 = ''.obs;

  ///Voter ID Front Side
  List<int> dlFrontConvertedImage = [];
  var dlFrontImageBytes;
  String dlFrontSideBase64 = '';

  void voterFrontSelectImage(String imagePath) {
    voterDLFrontImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(voterDLFrontImageBytes);
    voterDLFrontImageList.clear();
    voterDLFrontImageList.add(imageBytes);
    voterDLFrontConvertedImage =
        voterDLFrontImageList.expand((Uint8List) => Uint8List).toList();
    userVoterDLFrontSideBase64.value = base64Encode(voterDLFrontConvertedImage);
    debugPrint("${voterDLFrontConvertedImage.toString()}");
  }

  void dlSelectImage(String imagePath) {
    dlFrontImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(voterDLFrontImageBytes);
    DLFrontImageList.clear();
    DLFrontImageList.add(imageBytes);
    dlFrontConvertedImage =
        DLFrontImageList.expand((Uint8List) => Uint8List).toList();
    dlFrontSideBase64 = base64Encode(dlFrontConvertedImage);
    debugPrint("${dlFrontConvertedImage.toString()}");
  }

  final ImagePicker voterDLFrontImagePicker = ImagePicker();
  var voterDLFrontImage;
  var dlImage;
  Future<void> voterFrontShowImage(ImageSource source) async {
    voterDLFrontImage = await voterDLFrontImagePicker.pickImage(
        source: source, imageQuality: 50);
    if (voterFrontShowImage != null) {
      voterFrontSelectImage(voterDLFrontImage.path);
    }
  }

  Future<void> dlShowImage(ImageSource source) async {
    dlImage = await voterDLFrontImagePicker.pickImage(
        source: source, imageQuality: 50);
    if (dlShowImage != null) {
      dlSelectImage(dlImage.path);
    }
  }

  ///Voter ID Back Side
  List<Uint8List> voterDLBackImageList = <Uint8List>[].obs;
  List<int> voterDLBackConvertedImage = [];
  var voterDLBackImageBytes;
  RxString userVoterDLBackSideBase64 = ''.obs;

  void voterBackSelectImage(String imagePath) {
    voterDLBackImageBytes =
        File(imagePath).readAsBytesSync(); // Read file as bytes
    Uint8List imageBytes = Uint8List.fromList(
        voterDLBackImageBytes); // Use Uint8List instead of Int8List
    voterDLBackImageList.clear();
    voterDLBackImageList.add(imageBytes);

    // Convert the image list into a single list of bytes
    voterDLBackConvertedImage =
        voterDLBackImageList.expand((Uint8List) => Uint8List).toList();

    // Encode the bytes into a Base64 string
    userVoterDLBackSideBase64.value = base64Encode(voterDLBackConvertedImage);

    debugPrint("$voterDLBackConvertedImage");
  }

  final ImagePicker voterDLBackImagePicker = ImagePicker();
  var voterDLBackImage;

  Future<void> voterBackShowImage(
    ImageSource source,
  ) async {
    voterDLBackImage = await voterDLBackImagePicker.pickImage(
        source: source, imageQuality: 50);
    if (voterBackShowImage != null) {
      voterBackSelectImage(voterDLBackImage.path);
    }
  }

  final ImagePicker RcImagePicker = ImagePicker();
  var RcImage;

  Future<void> RcShowImage(ImageSource source) async {
    RcImage =
        await DLFrontImagePicker.pickImage(source: source, imageQuality: 50);
    if (RcImage != null) {
      RcSelectImage(RcImage.path);
    }
  }

  List<Uint8List> RcImageList = <Uint8List>[].obs;
  List<int> RcConvertedImage = [];
  var RcImageBytes;
  RxString userRcBase64 = ''.obs;

  void RcSelectImage(String imagePath) {
    RcImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(RcImageBytes);
    RcImageList.clear();
    RcImageList.add(imageBytes);
    RcConvertedImage = RcImageList.expand((Uint8List) => Uint8List).toList();
    userRcBase64.value = base64Encode(RcConvertedImage);
    debugPrint("${RcConvertedImage.toString()}");
  }

  /// DL Front Side
  List<Uint8List> DLFrontImageList = <Uint8List>[].obs;
  List<int> DLFrontConvertedImage = [];
  var DLFrontImageBytes;
  RxString userDLFrontSideBase64 = ''.obs;
  void DLFrontSelectImage(String imagePath) {
    DLFrontImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(DLFrontImageBytes);
    DLFrontImageList.clear();
    DLFrontImageList.add(imageBytes);
    DLFrontConvertedImage =
        DLFrontImageList.expand((Uint8List) => Uint8List).toList();
    userDLFrontSideBase64.value = base64Encode(DLFrontConvertedImage);
    debugPrint("${DLFrontConvertedImage.toString()}");
  }

  // Driving Licences Selection

  final ImagePicker DLFrontImagePicker = ImagePicker();
  var DLFrontImage;

  Future<void> DLFrontShowImage(ImageSource source) async {
    DLFrontImage =
        await DLFrontImagePicker.pickImage(source: source, imageQuality: 50);
    if (DLFrontImage != null) {
      DLFrontSelectImage(DLFrontImage.path);
    }
  }

  /// DL Back Side
  List<Uint8List> DLBackImageList = <Uint8List>[].obs;
  List<int> DLBackConvertedImage = [];
  var DLBackImageBytes;
  RxString userDLBackSideBase64 = ''.obs;
  var DLBackImage;

  Future<void> DLBackShowImage(ImageSource source) async {
    DLBackImage =
        await DLBackImagePicker.pickImage(source: source, imageQuality: 50);
    if (DLBackImage != null) {
      DLBackSelectImage(DLBackImage.path);
    }
  }

  void DLBackSelectImage(String imagePath) {
    DLBackImageBytes = File(imagePath).readAsBytesSync(); // Read file as bytes
    Uint8List imageBytes = Uint8List.fromList(
        DLBackImageBytes); // Use Uint8List instead of Int8List
    DLBackImageList.clear();
    DLBackImageList.add(imageBytes);

    // Convert the image list into a single list of bytes
    DLBackConvertedImage =
        DLBackImageList.expand((Uint8List) => Uint8List).toList();

    // Encode the bytes into a Base64 string
    userDLBackSideBase64.value = base64Encode(DLBackConvertedImage);

    debugPrint("$DLBackConvertedImage");
  }

  final ImagePicker DLBackImagePicker = ImagePicker();

  ///Pan Card Photo
  List<Uint8List> panCardImageList = <Uint8List>[].obs;
  List<int> panCardConvertedImage = [];
  var panCardImageBytes;
  RxString panCardImageBase64 = ''.obs;

  void panCardSelectImage(String imagePath) {
    panCardImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(panCardImageBytes);
    panCardImageList.clear();
    panCardImageList.add(imageBytes);
    panCardConvertedImage =
        panCardImageList.expand((Int8List) => Int8List).toList();
    panCardImageBase64.value = base64Encode(panCardConvertedImage);

    debugPrint("$panCardConvertedImage");
  }

  final ImagePicker panCardImagePicker = ImagePicker();
  var panCardImage;

  Future<void> panCardShowImage(ImageSource source) async {
    panCardImage =
        await panCardImagePicker.pickImage(source: source, imageQuality: 50);
    if (panCardShowImage != null) {
      panCardSelectImage(panCardImage.path);
    }
  }

  /// Pan Card Back Side
  List<Uint8List> panCardBackImageList = <Uint8List>[].obs;
  List<int> panCardBackConvertedImage = [];
  var panCardBackImageBytes;
  String userPanCardBackSideBase64 = '';

  void panCardBackSelectImage(String imagePath) {
    panCardBackImageBytes =
        File(imagePath).readAsBytesSync(); // Read file as bytes
    Uint8List imageBytes = Uint8List.fromList(
        panCardBackImageBytes); // Use Uint8List instead of Int8List
    panCardBackImageList.clear();
    panCardBackImageList.add(imageBytes);

    // Convert the image list into a single list of bytes
    panCardBackConvertedImage =
        panCardBackImageList.expand((Uint8List) => Uint8List).toList();

    // Encode the bytes into a Base64 string
    userPanCardBackSideBase64 = base64Encode(panCardBackConvertedImage);

    debugPrint("$panCardBackConvertedImage");
  }

  final ImagePicker panCardBackImagePicker = ImagePicker();
  var panCardBackImage;

  Future<void> panCardBackShowImage(ImageSource source) async {
    panCardBackImage = await panCardBackImagePicker.pickImage(
        source: source, imageQuality: 50);
    if (panCardBackImage != null) {
      panCardBackSelectImage(panCardBackImage.path);
    }
  }

  ///Selfie
  List<Uint8List> selfieImageList = <Uint8List>[].obs;
  List<int> selfieConvertedImage = [];
  var selfieImageBytes;
  RxString selfieImageBase64 = ''.obs;

  void selfieSelectImage(String imagePath) {
    selfieImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(selfieImageBytes);
    selfieImageList.clear();
    selfieImageList.add(imageBytes);
    selfieConvertedImage =
        selfieImageList.expand((Int8List) => Int8List).toList();
    selfieImageBase64.value = base64Encode(selfieConvertedImage);

    debugPrint("$selfieConvertedImage");
  }

  final ImagePicker selfieImagePicker = ImagePicker();
  var selfieImage;

  Future<void> selfieShowImage(ImageSource source) async {
    selfieImage =
        await selfieImagePicker.pickImage(source: source, imageQuality: 50);
    if (selfieShowImage != null) {
      selfieSelectImage(selfieImage.path);
    }
  }

  ///PassBook Image
  List<Uint8List> passbookImageList = <Uint8List>[].obs;
  List<int> passbookConvertedImage = [];
  var passbookImageBytes;
  RxString passbookImageBase64 = ''.obs;

  void passbookSelectImage(String imagePath) {
    passbookImageBytes = File(imagePath).readAsBytesSync();
    Uint8List imageBytes = Uint8List.fromList(passbookImageBytes);
    passbookImageList.clear();
    passbookImageList.add(imageBytes);
    passbookConvertedImage =
        passbookImageList.expand((Uint8List) => Uint8List).toList();
    passbookImageBase64.value = base64Encode(passbookConvertedImage);
    debugPrint("$passbookConvertedImage");
  }

  final ImagePicker passbookImagePicker = ImagePicker();
  var passbookImage;

  Future<void> passbookShowImage(ImageSource source) async {
    passbookImage =
        await passbookImagePicker.pickImage(source: source, imageQuality: 50);
    if (passbookShowImage != null) {
      passbookSelectImage(passbookImage.path);
    }
  }

  var isMobileAlreadyRegistered = false.obs;
  RxBool isSignupFromEditable = false.obs;
  SignUpDriverDetailsByMobileNoModel? driverDetailModel;

  getdriverdata() {
    if (driverDetailModel != null) {
      fristname.value.text = driverDetailModel!.firstName ?? "";
      middlename.value.text = driverDetailModel!.middleName ?? "";
      lastname.value.text = driverDetailModel!.lastName ?? "";
      userEmail.value.text = driverDetailModel!.emailId ?? "";
      signupMobileNumber.value.text = driverDetailModel!.mobileNo ?? "";
      alternateContactNumber.value.text =
          driverDetailModel!.alternativeMobileNo ?? "";
      useCurrentAddressAsPermanentAddress.value =
          driverDetailModel!.useCurrentAddressAsPermanentAddress ?? false;
      userGender.value = driverDetailModel!.gender ?? "";
      userDob.value.text = DateFormat('dd/MM/yyyy')
          .format(driverDetailModel!.dateOfBirth ?? DateTime.now());
      userDobDateApiFormat.value.text = DateFormat('yyyy-MM-dd')
          .format(driverDetailModel!.dateOfBirth ?? DateTime.now());
      isTermsAccepted.value = true;

      // userDLType.value = driverDetailModel!.twoWheelerDrivingLicenseNumber != ''
      //     ? 'TWO WHEELER'
      //     : driverDetailModel!.threeWheelerDrivingLicenseNumber != ''
      //         ? 'THREE WHEELER'
      //         : driverDetailModel!.fourWheelerDrivingLicenseNumber != ''
      //             ? 'FOUR WHEELER'
      //             : 'Select DL Type';
      // userDLNumber.value.text =
      //     (driverDetailModel!.twoWheelerDrivingLicenseNumber != ''
      //         ? driverDetailModel!.twoWheelerDrivingLicenseNumber
      //         : driverDetailModel!.threeWheelerDrivingLicenseNumber != ''
      //             ? driverDetailModel!.threeWheelerDrivingLicenseNumber
      //             : driverDetailModel!.fourWheelerDrivingLicenseNumber != ''
      //                 ? driverDetailModel!.fourWheelerDrivingLicenseNumber
      //                 : ' ')!;

      // masterList.firstWhere(
      //   (element) {
      //     bool isMatch = element.mID == driverDetailModel!.bankId &&
      //         element.mTypeID == 116;
      //     if (isMatch) {
      //       selectedBank.value = element.mName;
      //     }
      //     return isMatch;
      //   },
      // );

      userCurrentAddress.value.text = driverDetailModel!.currentAddress ?? "";
      userPermanentAddress.value.text =
          driverDetailModel!.permanentAddress ?? "";

      userPinCode.value.text = driverDetailModel!.pincode ?? "";
      callGetDetailsByPinCodeDetailsApi(userPinCode.value.text);
      selectedBankId.value = driverDetailModel!.bankId.toString();
      userDlIssueDate.value.text = DateFormat('dd/MM/yyyy')
          .format(driverDetailModel!.drivingLicenseIssueDate ?? DateTime.now());
      userDlIssueDateApiFormat.value.text = DateFormat('yyyy-MM-dd')
          .format(driverDetailModel!.drivingLicenseIssueDate ?? DateTime.now());
      userDlExpireDate.value.text = DateFormat('dd/MM/yyyy').format(
          driverDetailModel!.drivingLicenseExpiryDate ?? DateTime.now());
      userDlExpireDateApiFormat.value.text = DateFormat('yyyy-MM-dd').format(
          driverDetailModel!.drivingLicenseExpiryDate ?? DateTime.now());
      userAadhaarNumber.value.text = driverDetailModel!.aadharCardNumber ?? "";
      userPanNumber.value.text = driverDetailModel!.panCardNumber ?? "";
      voterId.value.text = driverDetailModel!.voterId ?? "";
      branchName.value.text = driverDetailModel!.branchName ?? "";
      selectedBankId.value = driverDetailModel!.bankId.toString() ?? "";
      accountHolderName.value.text = driverDetailModel!.accountHolderName ?? "";
      accountNumber.value.text = driverDetailModel!.accountNumber ?? "";
      ifscCode.value.text = driverDetailModel!.ifscCode ?? "";
      nomineeName.value.text = driverDetailModel!.nomineeName ?? "";
      nomineeContactNumber.value.text =
          driverDetailModel!.nomineeContactNo ?? "";
      selectedNomineeRelation.value = driverDetailModel!.nomineeRelation ?? "";
      selectedBloodGroupId.value = driverDetailModel!.bloodGroupId.toString();

      selectedBloodGroupList.firstWhere(
        (element) {
          bool isMatch =
              element.value == driverDetailModel!.bloodGroupId.toString();
          if (isMatch) {
            selectedBloodGroup.value = element.name;
          }
          return isMatch;
        },
      );

      aadhaarFrontImageBase64.value =
          driverDetailModel!.aadharCardFrontSide ?? "";
      passbookImageBase64.value = driverDetailModel!.passbookCancelCheque ?? "";
      aadhaarBackImageBase64.value =
          driverDetailModel!.aadharCardBackSide ?? "";
      panCardImageBase64.value = driverDetailModel!.panCardImage ?? "";
      userVoterDLFrontSideBase64.value =
          driverDetailModel!.voterIdFrontSide ?? "";
      userVoterDLBackSideBase64.value =
          driverDetailModel!.voterIdBackSide ?? "";
      selfieImageBase64.value = driverDetailModel!.selfie ?? "";
      userDLFrontSideBase64.value =
          driverDetailModel!.drivingLicenseFrontSide ?? "";
      userDLBackSideBase64.value =
          driverDetailModel!.drivingLicenseBackSide ?? "";
      log(" ${"driverDetailModel!.drivingLicenseFrontSide"}");

      // DL Information
      userHaveDrivingLicence.value =
          driverDetailModel!.haveDrivingLicense! == true ? "Yes" : "No";
      userDlVehicleTypeId.value = driverDetailModel!.dlVehicleTypeIds ?? '';
      userDLNumber.value.text = driverDetailModel!.drivingLicenseNumber ?? '';
      if (userDlVehicleTypeId.value.isNotEmpty) {
        List _dlId = userDlVehicleTypeId.value.split(",");
        for (var type in dlVehicleTypeList) {
          if (_dlId.contains(type.value)) {
            selectedDlVehicleTypeList.add(type);
          }
        }
        userDlVehicleType.value =
            selectedDlVehicleTypeList.map((f) => f.name).join(",");
      }

      //DL Type
      userDLTypeId = driverDetailModel!.dlTypeId.toString();
      dLTypeList.firstWhere(
        (element) {
          bool isMatch =
              element.value == driverDetailModel!.dlTypeId.toString();
          if (isMatch) {
            userDLType.value = element.name;
          }
          return isMatch;
        },
      );

      // Vehicle Information
      userVehicleTypeId.value = driverDetailModel!.vehicleTypeId.toString();
      userVehicleNumber.value.text = driverDetailModel!.vehicleNo ?? '';
      userRcBase64.value = driverDetailModel!.rcPhoto ?? '';
      vehicleTypeList.firstWhere(
        (element) {
          bool isMatch =
              element.value == driverDetailModel!.vehicleTypeId.toString();
          if (isMatch) {
            userVehicleType.value = element.name;
          }
          return isMatch;
        },
      );
    }
    //{AadharNumber: null, PanNumber: null, StatusId: 0, DriverLocationId: 12, WarehouseId: 11, BranchId: 0,
    // DriverLocationCode: MAZGAON, DriverCode: null,
    // FromDate: 0001-01-01T00:00:00, ToDate: 0001-01-01T00:00:00,
    // IsApproved: false, Status: Pending, Remarks: null,
    // SignupDriverId: 57, DriverName: null,
    // FirstName: test mansi, MiddleName: ajaybhai,
    // LastName: patel, EntryDate: 0001-01-01T00:00:00,
    // DateOfBirth: 2000-01-25T00:00:00, AadharCardNumber: 454545454545,
    // PanCardNumber: FDNPP2081P, MobileNo: 7096042224,
    // EmailId: mansipatel2501@gmail.com, CurrentAddress: adajan,
    // PermanentAddress: adajan, Gender: Female,
    // Selfie: /9j/4QMERXhpZgAATU0AKgAAAAgACAEAAAQAAAABAAAf4AEQAAIAAAARAAAAbgEBAAQAAAABAAAR8AEPAAIAAAAIAAAAfwExAAIAAAAOAAAAh4dpAAQAAAABAAAAqQESAAMAAAABAAYAAAEyAAIAAAAUAAAAlQAAAABHYWxheHkgUzI0IFVsdHJhAHNhbXN1bmcAUzkyOEJYWFM0QVlBMQAyMDI1OjAyOjI0IDExOjU5OjI0AAAbkAAAAgAAAAUAAAHzkgIABQAAAAEAAAH4kgQACgAAAAEAAAIAiCIAAwAAAAEAAgAApCAAAgAAAAwAAAIIkgUABQAAAAEAAAIUkAMAAgAAABQAAAIcoAAAAgAAAAUAAAIwkpEAAgAAAAQ3NzMApAMAAwAAAAEAA
    // log("data are printing");
    // log("${driverDetailModel!.aadharCardFrontSide}");
    // log("${driverDetailModel!.firstName ?? "NA"}");
    // log("${driverDetailModel!.middleName ?? "NA"}");
    // log("${driverDetailModel!.lastName ?? "NA"}");
    // log("${driverDetailModel!.emailId ?? "NA"}");
  }

  Future<void> getSignupDriverId(RegistrationReq registrationReq) async {
    var res = await CallMasterApi.getDatBody(
        uri: Uri.parse("${ApiUrl.baseUrl6}${ApiUrl.getSignupDriverId}"),
        token: '',
        body: {"MobileNo": signupMobileNumber.value.text.trim()});
    debugPrint("*************************");
    debugPrint("*****$res*******");
    debugPrint("*************************");

    /// do not change this logic without permission
    if (res != null) {
      driverDetailModel = SignUpDriverDetailsByMobileNoModel.fromJson(res);
      debugPrint("SignupDriverId ====== ${driverDetailModel!.signupDriverId}");
      debugPrint("Remarks ====== ${driverDetailModel!.remarks}");
      if (driverDetailModel!.statusId == 2 ||
          driverDetailModel!.statusId == 4) {
        isSignupFromEditable.value = false;
        MyToast.myShowToast3("${driverDetailModel!.remarks}");
        signupDriverId.value = driverDetailModel!.signupDriverId!;
        CreateAccount(registrationReq);
      } else if (driverDetailModel!.statusId == 1 ||
          driverDetailModel!.statusId == 3) {
        isSignupFromEditable.value = true;
        MyToast.myShowToast3("${driverDetailModel!.remarks}");
        signupDriverId.value = driverDetailModel!.signupDriverId!;
        CreateAccount(registrationReq);
      } else if (res != null &&
          (driverDetailModel!.remarks) == null &&
          (driverDetailModel!.status) == "Pending" &&
          (driverDetailModel!.statusId) == 0) {
        MyToast.myShowToast("Verification is Pending.");
      }  else {
      debugPrint("GetSignUpDriverDetailsByMobileNo API Response  ");
      MyToast.myShowToast("Verification Successful");
      CreateAccount(registrationReq);
      clearValues();
    }}else {
      debugPrint("GetSignUpDriverDetailsByMobileNo API Response null");
      MyToast.myShowToast("Verification Successful");
      CreateAccount(registrationReq);
      clearValues();
    }
    //{AadharNumber: null, PanNumber: nu⁄ll, StatusId: 0, DriverLocationId: 12, WarehouseId: 11, BranchId: 0,
    // DriverLocationCode: MAZGAON, DriverCode: null,
    // FromDate: 0001-01-01T00:00:00, ToDate: 0001-01-01T00:00:00,
    // IsApproved: false, Status: Pending, Remarks: null,
    // SignupDriverId: 57, DriverName: null,
    // FirstName: test mansi, MiddleName: ajaybhai,
    // LastName: patel, EntryDate: 0001-01-01T00:00:00,
    // DateOfBirth: 2000-01-25T00:00:00, AadharCardNumber: 454545454545,
    // PanCardNumber: FDNPP2081P, MobileNo: 7096042224,
    // EmailId: mansipatel2501@gmail.com, CurrentAddress: adajan,
    // PermanentAddress: adajan, Gender: Female,
    // Selfie: /9j/4QMERXhpZgAATU0AKgAAAAgACAEAAAQAAAABAAAf4AEQAAIAAAARAAAAbgEBAAQAAAABAAAR8AEPAAIAAAAIAAAAfwExAAIAAAAOAAAAh4dpAAQAAAABAAAAqQESAAMAAAABAAYAAAEyAAIAAAAUAAAAlQAAAABHYWxheHkgUzI0IFVsdHJhAHNhbXN1bmcAUzkyOEJYWFM0QVlBMQAyMDI1OjAyOjI0IDExOjU5OjI0AAAbkAAAAgAAAAUAAAHzkgIABQAAAAEAAAH4kgQACgAAAAEAAAIAiCIAAwAAAAEAAgAApCAAAgAAAAwAAAIIkgUABQAAAAEAAAIUkAMAAgAAABQAAAIcoAAAAgAAAAUAAAIwkpEAAgAAAAQ3NzMApAMAAwAAAAEAA
  }

  Future<void> CreateAccount(RegistrationReq registrationReq) async {
    debugPrint(json.encode(registrationReq.toJson()));
    var res = await CallMasterApi.postApiCallBasicAuth(
        ApiUrl.baseUrl + ApiUrl.createAccount, registrationReq);
    debugPrint("*************************");
    debugPrint("*****$res*******");
    debugPrint("*************************");
    if (res != null) {
      RegistrationRes registrationRes = RegistrationRes.fromJson(res);
      debugPrint(registrationRes.insertId.toString());
      if (registrationRes.insertId == 1) {
        // MyToast.myShowToast(registrationRes.response);
        Get.offAll(const SelectOnboarding());
      } else {
        MyToast.myShowToast(registrationRes.response);
        Get.back();
      }
    } else {
      MyToast.myShowToast("Something Went Wrong");
      Get.back();
    }
  }

  // https://abhilaya.in:8443/api/driver/IsAadharCardNumberAvailable
  bool isAadharNumberAvailable = true;
  bool isPanNumberAvailable = true;
  Future<void> checkAadharCardNumberAvailable() async {
    var res = await CallMasterApi.getDatBody(
        uri: Uri.parse(
            "${ApiUrl.baseUrl6}${ApiUrl.isAadharCardNumberAvailable}"),
        token: '',
        body: {
          "MobileNo": signupMobileNumber.value.text,
          "AadharCardNumber": userAadhaarNumber.value.text
        });

    if (res != null) {
      if (res['Flag'] == true) {
        isAadharNumberAvailable = false;

        MyToast.myShowToast(
            "${userAadhaarNumber.value.text} already exists with other Mobile Number.");
        userAadhaarNumber.value.text = "";
      } else {
        isAadharNumberAvailable = true;
      }
    } else {}
  }

  Future<void> checkPanCardNumberAvailable() async {
    var res = await CallMasterApi.getDatBody(
        uri: Uri.parse("${ApiUrl.baseUrl6}${ApiUrl.isPanCardNumberAvailable}"),
        token: '',
        body: {
          "MobileNo": signupMobileNumber.value.text,
          "PanCardNumber": userPanNumber.value.text
        });

    if (res != null) {
      if (res['Flag'] == true) {
        isPanNumberAvailable = false;

        MyToast.myShowToast(
            "${userPanNumber.value.text} already exists with other Mobile Number.");
        userPanNumber.value.text = "";
      } else {
        isPanNumberAvailable = true;
      }
    } else {}
  }

  void clearValues() {
    signupSteeperCurrentPage.value = 0;
    useCurrentAddressAsPermanentAddress.value = false;

    ///first page
    fristname.value.clear();
    middlename.value.clear();
    lastname.value.clear();
    alternateContactNumber.value.clear();
    username.value.clear();
    userEmail.value.clear();
    userDob.value.clear();
    userCurrentAddress.value.clear();
    userPermanentAddress.value.clear();
    userGender.value = "Select Gender";
    userPinCode.value.clear();
    userStateController.value.clear();
    userCityController.value.clear();

    ///second page
    userDlVehicleType.value = "Select Vehicle Type";
    userDlVehicleTypeId.value = "";
    userAadhaarNumber.value.clear();
    userPanNumber.value.clear();
    userDLNumber.value.clear();
    aadhaarFrontImageList.clear();
    aadhaarFrontImageBase64.value = "";
    aadhaarBackImageList.clear();
    aadhaarBackImageBase64.value = "";
    selectedBusiness.value = "Select your Business";
    selectedBusinessId.value = "";
    selectedDepartment.value = "Select your Department";
    selectedDepartmentId.value = "";
    selectedDepartmentState.value = "Select your State";
    selectedDepartmentStateId.value = "";
    selectedBusinessUnit.value = "Select your Business Unit";
    selectedBusinessUnitId.value = "";

    ///third page
    isTermsAccepted.value = false;

    ///fourth page
    userHaveDrivingLicence.value = "";
    DLFrontImageList.clear();
    userDLFrontSideBase64.value = "";
    DLBackImageList.clear();
    userDLBackSideBase64.value = "";
    userDlIssueDate.value.clear();
    userDlExpireDate.value.clear();

    ///fifth page
    voterId.value.clear();
    voterDLFrontImageList.clear();
    userVoterDLFrontSideBase64.value = "";
    voterDLBackImageList.clear();
    userVoterDLBackSideBase64.value = "";
    panCardImageList.clear();
    panCardImageBase64.value = "";
    panCardBackImageList.clear();
    selfieImageList.clear();
    selfieImageBase64.value = "";

    userVehicleNumber.value.clear();
    userRcBase64.value = "";

    ///six page
    selectedBank.value = "Select Bank";
    branchName.value.clear();
    accountHolderName.value.clear();
    accountNumber.value.clear();
    ifscCode.value.clear();
    passbookImageList.clear();

    ///seven page
    nomineeName.value.clear();
    nomineeContactNumber.value.clear();
    selectedNomineeRelation.value = "Select Nominee Relation";
  }
}
