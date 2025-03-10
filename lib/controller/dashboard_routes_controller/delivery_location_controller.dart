import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/pay_phi/qrGeneratorRequest.dart';
import 'package:abhilaya/model/pay_phi/transaction_status_requeset.dart';
import 'package:abhilaya/model/request_model/delivery_list_request.dart';
import 'package:abhilaya/model/request_model/delivery_submit_request.dart';
import 'package:abhilaya/model/request_model/reason_list_request.dart';
import 'package:abhilaya/model/request_model/tracking_number_validation_request.dart';
import 'package:abhilaya/model/response_model/delivery_list_response.dart';
import 'package:abhilaya/model/response_model/new_otp_response.dart';
import 'package:abhilaya/model/response_model/otp_response.dart';
import 'package:abhilaya/model/response_model/reason_list_response.dart';
import 'package:abhilaya/model/response_model/submit_delivery_response.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/dashboard/Dashboard.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../../model/exotel/call_response.dart';
import '../../model/pay_phi/qr_generator_response.dart';
import '../../model/pay_phi/transaction_status_response.dart';
import '../../model/response_model/tracking_number_validation_response.dart'
    as validation_response;
import '../../model/response_model/tracking_number_validation_response.dart';
import '../../utils/toast.dart';

class DeliveryLocationController extends GetxController {
  RxBool isOTPValid = false.obs;
  RxInt cancellationOtpSent = 0.obs;
  RxBool isCancellationOTPValid = false.obs;
  var isOtpDialogBoxOpened = false.obs;

  var transactionId = "".obs;

  var reasonStatusId = "103".obs;
  var reasonListResponse = Rx<ReasonListResponse?>(null);

  RxList<TextEditingController?> otpControllers =
      <TextEditingController?>[].obs;

  String get otpText => otpControllers
      .map((element) => element?.text ?? '')
      .toList()
      .toString()
      .replaceAll(',', '')
      .replaceAll('[', '')
      .replaceAll(']', '')
      .replaceAll(' ', '')
      .trim();

  RxList<TextEditingController?> cancelOtpControllers =
      <TextEditingController?>[].obs;

  String get cancelOtpText => cancelOtpControllers
      .map((element) => element?.text ?? '')
      .toList()
      .toString()
      .replaceAll(',', '')
      .replaceAll('[', '')
      .replaceAll(']', '')
      .replaceAll(' ', '')
      .trim();

  var isPaymentPageOpened = false.obs;

  var receiversIndex = 0.obs;
  var loginController = Get.find<LoginController>();
  AudioPlayer player = AudioPlayer();
  Timer? statusCheckTimer;
  Rx<TextEditingController> searchTrackingNumber = TextEditingController().obs;
  Rx<FocusNode> searchTrackingNumberFocusNode = FocusNode().obs;

  var doesDataExist = true.obs;

  var deliveryListResponse = Rx<DeliveryListResponse?>(null);
  var selectedDeliveryLocation = "Select Delivery Location".obs;
  var scannedTrackingNumber = " ".obs;
  var isOrderCOD = false.obs;

  // var ndrListResponse = Rx<NDRListResponse?>(null);
  var isNDRSelected = false.obs;
  var selectedNDR = "Select".obs;
  var selectedNDRValue = "0".obs;

  // Rx<Data>? selectedData;

  List<String> deliveryLocationList = List<String>.empty(growable: true).obs;

  // List<> allDeliveryLocationsList = List<>.empty(growable: true).obs;
  // List<NDRListResponse> ndrAPIResponseList =
  //     List<NDRListResponse>.empty(growable: true).obs;
  // Map<String, String> ndrResponseMap = {};
  // List<String> ndrResponseList = List<String>.empty(growable: true).obs;

  Rx<TextEditingController> trackingNumberController =
      TextEditingController().obs;
  Rx<FocusNode> trackingNumberFocusNode = FocusNode().obs;
  Rx<TextEditingController> amountController = TextEditingController().obs;
  Rx<FocusNode> amountFocusNode = FocusNode().obs;
  var isTrackingNumberValid = false.obs;
  var isRtoCheck = 2.obs;
  List<Data> trackingDetailsList = List<Data>.empty(growable: true).obs;

  Rx<TextEditingController> employerId = TextEditingController().obs;
  Rx<TextEditingController> receiversName = TextEditingController().obs;
  Rx<TextEditingController> receiversContact = TextEditingController().obs;
  Rx<TextEditingController> receivingAmount = TextEditingController().obs;

  Rx<FocusNode> employerIdFocusNode = FocusNode().obs;
  Rx<FocusNode> receiversNameFocusNode = FocusNode().obs;
  Rx<FocusNode> receiversContactFocusNode = FocusNode().obs;
  Rx<FocusNode> receivingAmountFocusNode = FocusNode().obs;

  Rx<Uint8List?> receiversSignatureImageByte = Uint8List(0).obs;
  var receiversSignatureBase64 = "".obs;
  Rx<File?> receiversSignatureSelectedImage = File('').obs;
  Rx<Uint8List?> podImageByte = Uint8List(0).obs;
  Rx<File?> podSelectedImage = File('').obs;
  var podBase64Url = "".obs;

  sendOTP(BuildContext context, RxInt otpSent, String phone) async {
    var random = math.Random();
    otpSent.value = random.nextInt(900000) + 100000;
    debugPrint(otpSent.value.toString());

    var res = await http.get(
      Uri.parse(
        // "http://api.bulksmsgateway.in/sendmessage.php?user=Surya769&password=Isourse@123\$&mobile=$phone&message=Hi, Your OTP for order cancellation is ${otpSent.value.toString()}. Thanks, Isourse&sender=ISOTPL&type=3&template_id=1207171325511576880"
        "http://www.alots.in/sms-panel/api/http/index.php?username=ONEWORLD&apikey=DD6DB-CF1A0&apirequest=Text&sender=ABLAYA&mobile=$phone&message=Your OTP for order cancellation is ${otpSent.value.toString()}. Thanks, Abhilaya&route=TRANS&TemplateID=1707172492906259944&format=JSON",
      ),
    );
    debugPrint("${otpSent.toString()}}");
    debugPrint(res.body);
    debugPrint(res.statusCode.toString());
    debugPrint(res.statusCode.toString());
    if (res.statusCode == 200) {
      var decode = json.decode(res.body);
      var data = NewOtpResponse.fromJson(decode);
      if (data.status == 'success') {
        // loginController.otpVisibility.value = true;
        MyToast.myShowToast("OTP Sent Successfully");
      } else {
        Navigator.pop(context);
        MyToast.myShowToast("${data.status} while sending otp");
      }
    } else {
      Navigator.pop(context);
      MyToast.myShowToast("Something goes wrong");
    }
  }

  var isButtonDisabled = true.obs;

  sendFixedOTP(BuildContext context, int otpSent, String phone) async {
    // var random = Random();
    // otpSent.value = random.nextInt(900000) + 100000;
    debugPrint("fixed otp -${otpSent.toString()}");
    var res = await http.get(Uri.parse(
        "http://api.bulksmsgateway.in/sendmessage.php?user=Surya769&password=Isourse@123\$&mobile=$phone&message=Hi, Your OTP for order verification is ${otpSent.toString()}. Thanks, Isourse&sender=ISOTPL&type=3&template_id=1207171325511576880"));
    debugPrint("${otpSent.toString()}}");
    debugPrint(res.body);
    debugPrint(res.statusCode.toString());
    debugPrint(res.statusCode.toString());
    if (res.statusCode == 200) {
      var decode = json.decode(res.body);
      var data = SendOtpResponse.fromJson(decode);
      if (data.status == 'success') {
        // loginController.otpVisibility.value = true;
        MyToast.myShowToast("OTP Sent Successfully");
      } else {
        Navigator.pop(context);
        MyToast.myShowToast("${data.status} while sending otp");
      }
    } else {
      Navigator.pop(context);
      MyToast.myShowToast("Something goes wrong");
    }
  }

  getDeliveryLocationList() async {
    DeliveryListRequestModel req = DeliveryListRequestModel(
        dRIVERID: 0,
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        locationId: "0",
        userId: int.parse(loginController.loginResponse!.uSERID),
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID));

    debugPrint("JSONs ${req.toJson()}");
    var response = await CallMasterApi.postApiCall(
        // ApiUrl.baseUrl4 + ApiUrl.deliveryLocationList, req, "");
        ApiUrl.baseUrl4WithS + ApiUrl.deliveryLocationList,
        req,
        "");

    debugPrint("response received");
    if (response != null) {
      deliveryListResponse.value = DeliveryListResponse.fromJson(response);

      deliveryLocationList.add("Select Delivery Location");
      for (int i = 0; i < deliveryListResponse.value!.data.length; i++) {
        trackingDetailsList.add(deliveryListResponse.value!.data[i]);
        deliveryLocationList.add(
            deliveryListResponse.value!.data[i].transporterLocation.toString());
        // allDeliveryLocationsList.add(deliveryListResponse.value!.data[i]);
      }
      // createMap();
    } else {
      debugPrint("Location response = null");
      MyToast.myShowToast("Something went wrong");
    }
  }

  // var scannedDeliveryProduct  = Rx<TrackingDetailsResponseClass?>(null);
  // var scannedDeliveryProduct2  = Rx<TrackingDetailsResponseClass?>(null);
  var scannedDeliveryProduct = Rx<ValidTrackingNumberProduct?>(null);

  var validateTrackingNumberResponse =
      Rx<validation_response.ValidateTrackingNumberResponse?>(null);

  callValidateTrackingNumberApi(String trackingNumber) async {
    ValidateTrackingNumberRequest request = ValidateTrackingNumberRequest(
        clientId: int.parse(loginController.loginResponse!.cLIENTID),
        clientName: loginController.loginResponse!.cLIENTNAME,
        companyId: int.parse(loginController.loginResponse!.cOMPANYID),
        locationId: "0",
        userId: int.parse(loginController.loginResponse!.uSERID),
        roleId: loginController.loginResponse!.rOLEID.isEmpty
            ? 0
            : int.parse(loginController.loginResponse!.rOLEID),
        trackingNumber: trackingNumber.trim(),
        warehouseId: int.parse(loginController.loginResponse!.wAREHOUSEID));

    debugPrint("json ${jsonEncode(request.toJson())}");

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4WithS + ApiUrl.isDeliveryTrackingNoValid, request, "");

    if (response != null) {
      validateTrackingNumberResponse.value =
          validation_response.ValidateTrackingNumberResponse.fromJson(response);

      var json = validateTrackingNumberResponse.value?.toJson();

      debugPrint(
          "response ${jsonEncode(validateTrackingNumberResponse.value!.toJson())}");

      if (validateTrackingNumberResponse.value!.result!.flag == true) {
        isTrackingNumberValid.value = true;
        GeneralMethods.receiversMobileNumber.value =
            validateTrackingNumberResponse.value!.data!.receiverPhoneNo
                .toString();
        GeneralMethods.receiversName.value =
            validateTrackingNumberResponse.value!.data!.receiverName.toString();
        scannedTrackingNumber.value = trackingNumberController.value.text;
        trackingNumberController.value.clear();
        if (validateTrackingNumberResponse.value!.data!.isRto == 0) {
          reasonStatusId.value = "103";
        } else if (validateTrackingNumberResponse.value!.data!.isRto == 1) {
          reasonStatusId.value = "113";
        } else {
          reasonStatusId.value = "103";
        }

        await fetchProductViaTrackingNumber(trackingNumber);
        try {
          await player.setAsset('assets/sounds/validated.mp3');
          player.play();
        } catch (e) {
          debugPrint("Error while playing audio");
        }
      } else {
        try {
          await player.setAsset('assets/sounds/warning.ogg');
          player.play();
        } catch (e) {
          debugPrint("Error while playing audio");
        }
        MyToast.myShowToast("Invalid Tracking Number");
        isTrackingNumberValid.value = false;
        scannedTrackingNumber.value = trackingNumberController.value.text;
        trackingNumberController.value.clear();
      }
    } else {
      MyToast.myShowToast("Internal Server Error");
      debugPrint("Tracking Number response = null");
    }
  }

  fetchProductViaTrackingNumber(String trackingNumber) async {
    scannedDeliveryProduct.value = validateTrackingNumberResponse.value!.data!;
    selectedDeliveryLocation.value =
        scannedDeliveryProduct.value!.transporterLocation;
    amountController.value.text =
        scannedDeliveryProduct.value!.codValue.toString();
    isRtoCheck.value = scannedDeliveryProduct.value!.isRto;
    debugPrint("isRtoValue is ${isRtoCheck.value}");
    if (isRtoCheck.value == 0) {
      selectedNDR.value = "NDR";
    } else if (isRtoCheck.value == 1) {
      selectedNDR.value = "RTO NDR";
    } else {
      selectedNDR.value = "Select";
    }
    await getParticularNdrList();
  }

  List<ReasonInformation> reasonInfoList =
      List<ReasonInformation>.empty(growable: true).obs;
  List<String> reasonDescription = List<String>.empty(growable: true).obs;

  getParticularNdrList() async {
    debugPrint("Here");
    ReasonListRequest reasonListRequest =
        ReasonListRequest(codeTypeId: reasonStatusId.value);

    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl5 + ApiUrl.getReasonList, reasonListRequest, "");
    if (response != null) {
      reasonListResponse.value = ReasonListResponse.fromJson(response);
      debugPrint("reason response ${reasonListResponse.toString()}");
      await getNdrListFromResponse();
    } else {
      debugPrint("reason response = null");
    }
  }

  getNdrListFromResponse() {
    reasonDescription.add("Select");
    if (isRtoCheck.value == 0) {
      reasonDescription[0] = "NDR";
    } else if (isRtoCheck.value == 1) {
      reasonDescription[0] = "RTO NDR";
    } else {
      reasonDescription[0] = "Select";
    }
    if (reasonListResponse.value!.statusCode == 200 &&
        reasonListResponse.value!.flag == 1) {
      for (int i = 0; i < reasonListResponse.value!.data.length; i++) {
        reasonInfoList.add(reasonListResponse.value!.data[i]);
        reasonDescription
            .add(reasonListResponse.value!.data[i].codeDescription);
      }
    }
  }

  void convertByteToBase64(Rx<Uint8List?> byteList, Rx<String> base64Url) {
    if (byteList.value != null) {
      String base64String = base64Encode(byteList.value!);
      base64Url.value = base64String;
      debugPrint('Base64 String: $base64String');
    } else {
      debugPrint('Byte list is null');
    }
  }

  // getNDRList() async {
  //   var response = await CallMasterApi.postApiCallWithoutToken(
  //       ApiUrl.baseUrl4 + ApiUrl.ndrList);
  //   print(response);
  //   if (response != null) {
  //     for (int i = 0; i < response.length; i++) {
  //       ndrAPIResponseList.add(NDRListResponse.fromJson(response[i]));
  //     }
  //     getResponseFromNdrList();
  //   }
  // }
  //
  // getResponseFromNdrList() {
  //   ndrResponseList.add("Select");
  //   for (int i = 0; i < ndrAPIResponseList.length; i++) {
  //     ndrResponseList.add(ndrAPIResponseList[i].name!);
  //     ndrResponseMap[ndrAPIResponseList[i].name.toString()] =
  //         ndrAPIResponseList[i].value.toString();
  //   }
  // }

  ///For multiple submissions
  // List<TrackingDetailsResponseClass> scannedDeliveryItems = List<TrackingDetailsResponseClass>.empty(growable: true).obs;

  var submitDeliveryResponse = Rx<SubmitDeliveryResponse?>(null);

  callDeliverySubmitApi(BuildContext context) async {
    Dialogs.signUpLoading(context);

    if (podImageByte.value!.isNotEmpty) {
      convertByteToBase64(podImageByte, podBase64Url);
    }

    DefaultParam defaultParam = DefaultParam(
        clientId: loginController.loginResponse!.cLIENTID,
        clientName: loginController.loginResponse!.cLIENTNAME);

    Param param = Param(
        amount: amountController.value.text.isEmpty
            ? "0.0"
            : amountController.value.text.trim(),
        deliveryDistance: 0.0,
        employeeId: loginController.loginResponse!.uSERID,
        isPaidOnline: transactionId.value == "" ? false : true,
        isReturn: 0,
        // isReturn: isRtoCheck.value == 1 ?1:0,
        odnId: scannedDeliveryProduct.value!.odnId,
        paymentLinkId: isOrderCOD.value
            ? transactionId.value == ""
                ? ""
                : transactionId.value
            : "",
        picture: podImageByte.value.toString().isEmpty
            ? ""
            : podBase64Url.value.trim(),
        receiverName: receiversName.value.text.isEmpty
            ? ""
            : receiversName.value.text.trim(),
        receiverPhoneNo: receiversContact.value.text.isEmpty
            ? ""
            : receiversContact.value.text.trim(),
        returnReasonId: selectedNDRValue.value == "0"
            ? 0
            : int.parse(selectedNDRValue.value),
        signature: receiversSignatureImageByte.value.toString().isEmpty
            ? ""
            : receiversSignatureBase64.value.trim(),
        trackingNoStatus: "1",
        unDeliveredReasonId: selectedNDRValue.value == "0"
            ? 0
            : int.parse(selectedNDRValue.value),
        codeTypeId: reasonStatusId.value);

    List<Param> paramList = [];
    paramList.add(param);

    SubmitDeliveryRequest submitDeliveryRequest =
        SubmitDeliveryRequest(defaultParam: defaultParam, param: paramList);

    debugPrint("Request : ${jsonEncode(submitDeliveryRequest.toJson())}");
    log('message');
    var response = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl4 + ApiUrl.submitDelivery, submitDeliveryRequest, "");
    debugPrint("Delivery Responseresponse : ${response}");

    if (response != null) {
      submitDeliveryResponse.value = SubmitDeliveryResponse.fromJson(response);

      debugPrint(
          "Delivery Response : ${jsonEncode(submitDeliveryResponse.toJson())}");

      if (submitDeliveryResponse.value!.flag == true) {
        if (isNDRSelected.value) {
          MyToast.myShowToast('Submitted Successfully');
        } else {
          MyToast.myShowToast(
              submitDeliveryResponse.value!.flagMessage.toString());
        }
        Navigator.pop(context);
        isTrackingNumberValid.value = false;
      //  Get.offAll(  BottomNavBar());
      } else {
        Navigator.pop(context);
        MyToast.myShowToast(
            submitDeliveryResponse.value!.flagMessage.toString());
      }
    } else {
      debugPrint("Submit Response is null");
    }
  }

  var merchantRefNo = "".obs;
  var secureHashValue = "".obs;
  var statusCheckSecureHashValue = "".obs;

  var payPhiGenerateQrResponse = Rx<PayPhiGenerateQrResponse?>(null);
  var payPhiTransactionStatusResponse =
      Rx<PayPhiTransactionStatusResponse?>(null);

  callPayPhiQrGeneratorApi() async {
    // amountController.value.text = "10.0";
    merchantRefNo.value = "";
    merchantRefNo.value = generateMerchantRefNo();
    var mobileNumber = loginController.loginResponse!.mOBILENO.trim();
    var odnId = scannedTrackingNumber.value ?? "isourseCo";
    var reqType = "UPIQR";
    debugPrint("Reference Number ${merchantRefNo.value}");
    debugPrint("Scanned Tracking Number $odnId");
    secureHashValue.value = generateHashCode(
        odnId,
        amountController.value.text,
        "356",
        "guest@isourse.com",
        ApiUrl.payPhiMerchantId,
        merchantRefNo.value,
        reqType.trim(),
        loginController.loginResponse!.mOBILENO.trim(),
        ApiUrl.payPhiSecretKey);

    debugPrint("Amount: ${double.tryParse(amountController.value.text)}");

    debugPrint("Reference Number ${merchantRefNo.value}");
    debugPrint("Request type $reqType");
    PayPhiGenerateQrRequest payPhiGenerateQrRequest = PayPhiGenerateQrRequest(
        merchantId: ApiUrl.payPhiMerchantId,
        merchantRefNo: merchantRefNo.value,
        amount: double.tryParse(amountController.value.text),
        currency: 356,
        emailId: "guest@isourse.com",
        mobileNo: loginController.loginResponse!.mOBILENO.trim().isEmpty
            ? ""
            : mobileNumber,
        requestType: "UPIQR",
        secureHash: secureHashValue.value,
        addlparam1: odnId);

    debugPrint(
        "QR Json Request  ${jsonEncode(payPhiGenerateQrRequest.toJson())}");
    debugPrint("URL Check ${ApiUrl.payPhiMerchantId}");

    var response = await CallMasterApi.postApiCallFormUrlEncoded(
        ApiUrl.payPhiUrl + ApiUrl.payPhiQrGenerator, payPhiGenerateQrRequest);

    if (response != null) {
      payPhiGenerateQrResponse.value =
          PayPhiGenerateQrResponse.fromJson(response);
      var temp = merchantRefNo.value;
      debugPrint(
          "PayPhi Response : ${jsonEncode(payPhiGenerateQrResponse.toJson())}");
      if (payPhiGenerateQrResponse.value != null &&
          payPhiGenerateQrResponse.value!.respBody != null) {
        merchantRefNo.value = payPhiGenerateQrResponse
                    .value!.respBody!.merchantRefNo
                    .toString() ==
                ""
            ? payPhiGenerateQrResponse.value!.respBody!.merchantRefNo
                .toString()
                .trim()
            : temp;
      }
    }
  }

  String generateMerchantRefNo({int minLength = 6, int maxLength = 12}) {
    final math.Random random = math.Random();

    int length = minLength + random.nextInt(maxLength - minLength + 1);

    String randomNumber = '';
    for (int i = 0; i < length; i++) {
      if (i == 0) {
        randomNumber += (1 + random.nextInt(9)).toString();
      } else {
        randomNumber += random.nextInt(10).toString();
      }
    }

    return randomNumber;
  }

  String generateStatusCheckSecureHashCode(
      String merchantId,
      String merchantTxnNo,
      String originalTxnNo,
      String transactionType,
      String sharedKey) {
    String encryptedKey = "";
    String value = merchantId + merchantTxnNo + originalTxnNo + transactionType;
    debugPrint("value : ${value}");
    var key = utf8.encode(sharedKey);
    var bytes = utf8.encode(value);
    var hmachSha256 = Hmac(sha256, key);
    var digest = hmachSha256.convert(bytes);
    var hexString = digest.toString();
    encryptedKey = hexString.toLowerCase();
    // debugPrint("enc : $encryptedKey");
    return encryptedKey;
  }

  String generateHashCode(
      String addParam1,
      String amount,
      String currency,
      String emailId,
      String merchantID,
      String merchantRefNo,
      String requestType,
      String mobileNo,
      String sharedKey) {
    String encryptedHashKey = "";

    // var sharedKey = "abc";
    String value = addParam1 +
        amount +
        currency +
        emailId +
        merchantID +
        merchantRefNo +
        mobileNo +
        requestType;
    debugPrint("value : $value");
    debugPrint("value : $amount");
    var key = utf8.encode(sharedKey);
    var bytes = utf8.encode(value);
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

    debugPrint("Digest : $digest");

    var hexString = digest.toString();
    debugPrint("HexString : $hexString");
    encryptedHashKey = hexString.toLowerCase();
    debugPrint("encryptedString : $encryptedHashKey");
    return encryptedHashKey;
  }

  callPayPhiCheckStatusApi(BuildContext context) async {
    debugPrint("reference number from status check ${merchantRefNo.value}");
    statusCheckSecureHashValue.value = generateStatusCheckSecureHashCode(
        ApiUrl.payPhiMerchantId,
        merchantRefNo.value,
        merchantRefNo.value,
        "STATUS",
        ApiUrl.payPhiSecretKey);

    PayPhiTransactionStatusRequest payPhiTransactionStatusRequest =
        PayPhiTransactionStatusRequest(
            merchantId: ApiUrl.payPhiMerchantId,
            merchantTxnNo: merchantRefNo.value,
            originalTxnNo: merchantRefNo.value,
            transactionType: "STATUS",
            secureHash: statusCheckSecureHashValue.value);

    debugPrint(
        "Status Request : ${jsonEncode(payPhiTransactionStatusRequest.toJson())}");

    var response = await CallMasterApi.postApiCallForPaymentStatusCheck(
        ApiUrl.payPhiUrl + ApiUrl.payPhiStatusCheck,
        payPhiTransactionStatusRequest);

    if (response != null) {
      debugPrint("Status Response Received");

      payPhiTransactionStatusResponse.value =
          PayPhiTransactionStatusResponse.fromJson(response);
      debugPrint(
          "Response ${jsonEncode(payPhiTransactionStatusResponse.toJson())}");

      if (payPhiTransactionStatusResponse.value != null &&
              payPhiTransactionStatusResponse.value!.responseCode == "0000" ||
          payPhiTransactionStatusResponse.value!.responseCode == "000" ||
          payPhiTransactionStatusResponse.value!.respDescription!
                  .toLowerCase() ==
              "transaction successful") {
        statusCheckTimer!.cancel();

        transactionId.value =
            payPhiTransactionStatusResponse.value!.txnId.toString() ?? "";
        debugPrint("transactionID : ${transactionId.value}");
        MyToast.myShowToast("Transaction Successful");

        await Dialogs.paymentSuccessLottie(
            context, "assets/lottiee/payment_success.json");

        Get.back();
      } else {
        MyToast.myShowToast("Payment Pending");
      }
    }
  }

  var isTimeLeft = true.obs;

  int start = 0;

  checkStatusPeriodically(BuildContext context) {
    isTimeLeft.value = true;
    start = 0;
    debugPrint("Status CHeck Called");
    statusCheckTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (isPaymentPageOpened.value == false) {
        debugPrint("Page toggled so timer closed");
        statusCheckTimer!.cancel();
      }
      debugPrint("Status Check called for ${start++} time");
      await callPayPhiCheckStatusApi(context);
      if (start >= 9) {
        debugPrint("Checking for one last time");
        statusCheckTimer!.cancel();
        debugPrint("Cancel time");
        await callPayPhiCheckStatusApi(context);

        isTimeLeft.value = false;
      }
    });
  }

  ///For showing Number of deliveries in a particular location , map is used (Controller)
/*
 Map<String, List<TrackingDetailsResponseClass>> map = {};
  List<MapEntry<String, List<TrackingDetailsResponseClass>>> mapEntries = List<MapEntry<String, List<TrackingDetailsResponseClass>>>.empty(growable: true).obs;


createMap(){
      for (int i = 0; i < deliveryListResponse.value!.data.length; i++) {
        String key = deliveryListResponse.value!.data[i].transporterLocation.toString();
        TrackingDetailsResponseClass req = TrackingDetailsResponseClass(
            odnId: deliveryListResponse.value!.data[i].odnId,
            trackingNumber: deliveryListResponse.value!.data[i].trackingNumber,
            transporterId: deliveryListResponse.value!.data[i].transporterId,
            transporterLocation: deliveryListResponse.value!.data[i].transporterLocation,
            transporterLocationId: deliveryListResponse.value!.data[i].transporterLocationId,
            orderType: deliveryListResponse.value!.data[i].orderType,
            codAmount: deliveryListResponse.value!.data[i].codAmount,
            masterNumber: deliveryListResponse.value!.data[i].masterNumber);
        if (!map.containsKey(key)) {
          map[key] = [];
        }

        bool containsDuplicate = map[key]!.any((element) =>
        element.odnId == req.odnId &&
            element.trackingNumber == req.trackingNumber &&
            element.transporterId == req.transporterId &&
            element.transporterLocation == req.transporterLocation &&
            element.transporterLocationId == req.transporterLocationId &&
            element.orderType == req.orderType &&
            element.codAmount == req.codAmount &&
            element.masterNumber == req.masterNumber
        );

        if (!containsDuplicate) {
          map[key]!.add(req);
        }
      }
        // map[key]!.add(req);


      // print("LENGTH ${map.length}");

    mapEntries = map.entries.toList();

        map.forEach((key, value) {
          print("Key: $key, Values: $value");
        });

      print(map["test"]?.length);

      print(mapEntries);



  }
 */

  ///If you also want to show the number of deliveries in that particular location, ( UI part )
/*  SizedBox(
                width:MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
                  child: ListView.builder(
                    itemCount: deliveryLocationController.map.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemBuilder: (context, index) {
                      String key = deliveryLocationController.mapEntries[index].key;
                      List<TrackingDetailsResponseClass> values = deliveryLocationController.mapEntries[index].value;
                      int valuesLength = values.length;
                      return
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Tracking Number Section
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding:const  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                            decoration: BoxDecoration(
                                              color: Colors.blueAccent.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              // "${deliveryLocationController.map[deliveryLocationController.deliveryListResponse.value!.data[index].transporterLocation.toString()]?.length}",
                                              "$valuesLength",
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          const Text("Available \n Deliveries",style: TextStyle(fontSize: 12,color: Colors.black45),)
                                        ],
                                      ),
                                      const SizedBox(width: 20.0), // Space between the tracking number and the rest of the info
                                      // Address and Delivery Info Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height:35,
                                              child: TextField(
                                                readOnly: true,
                                                // controller: TextEditingController(text: deliveryLocationController.deliveryListResponse.value!.data[index].trackingNumber),
                                                controller: TextEditingController(text: values[0].trackingNumber),
                                                style:const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.black45),
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.black45),
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    labelText: "Tracking Number"

                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              height:50,
                                              // width: MediaQuery.sizeOf(context).width/2.5,
                                              child: Text("${key.capitalizeFirst}",
                                                softWrap: true, overflow: TextOverflow.visible,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height:7),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        deliveryLocationController.selectedDeliveryLocation.value = key;
                                        deliveryLocationController.trackingNumberController.value.clear();
                                        deliveryLocationController.amountController.value.clear();
                                        deliveryLocationController.isTrackingNumberValid.value = false;
                                        deliveryLocationController.isOrderCOD.value = false;
                                      });
                                      Get.to(const SubmitDelivery());
                                    }
                                    ,child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            colors: [Colors.deepOrange.shade500,Colors.deepOrange.shade400],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter
                                        ),),
                                      height: 50,
                                      width: MediaQuery.sizeOf(context).width,
                                      // padding: const EdgeInsets.only(right: 25),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Row(
                                            children: [
                                              Text("Deliver",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                                              SizedBox(width: 15),
                                              Icon(Icons.arrow_forward,color: Colors.white,),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height:15),
                          ],
                        );

                      /*   Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)
                            ),
                            height: 120,
                            child: Column(
                              children: [

                                Row(
                                  children: [
                            Container(
                            padding: EdgeInsets.all(16.0),
                            width: MediaQuery.sizeOf(context).width*0.30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                    fontSize: 18, // Large font size for the number
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.0), // Spacing between the number and the text
                                Text(
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  'Available Deliveries \n at location',
                                  style: TextStyle(
                                    fontSize: 10, // Smaller font size for the subtitle
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context).width/3,
                                            child: TextField(
                                                readOnly: true,
                                                controller: TextEditingController(text: deliveryLocationController.deliveryListResponse.value!.data[index].trackingNumber),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                      borderSide:const BorderSide(
                                                          color: Colors.black)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                      borderSide:
                                                      BorderSide(color:Colors.deepOrange.shade500)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                      borderSide: const  BorderSide(
                                                          color: Colors.black)
                                                  ),
                                                  label: Text("Tracking Number"),
                                                  // prefixIcon: const Icon(Icons.search,size: 20,),

                                                )
                                            ),
                                          ),
                                          Container(
                                            height:50,
                                            width: MediaQuery.sizeOf(context).width/2.5,
                                            child: Text("${deliveryLocationController.deliveryListResponse.value!.data[index].transporterLocation}",
                                              softWrap: true, overflow: TextOverflow.visible,style: TextStyle(fontSize: 10),),
                                          ),
                                        ],
                                      ),
                                    )


                                  ],
                                )
                              ],
                            ),
                          ); */
                    },),
                ),
              )*/

  ///call

  var exotelResponse = Rx<ExotelCallResponse?>(null);
  var isRedirectingViaCall = false.obs;
  var exotelStatus = "".obs;
  // callCallingApi(String from, String to) async {
  //
  //
  //   debugPrint("calling");
  //   String apiKey = "61de7148fd264d5808bf3d6e4d51a480a3e855e374d202d0";
  //   String apiToken = "62bad4a33a72cf2546ed67ef8e71d5823353fd4ea87bb9c2" ;
  //   Map<String,dynamic> fieldMap = {
  //     // "From":"+91$from",
  //     // "To":"+91$to",
  //     "From": "+919650824005",
  //     // "From": "+917042254903",
  //     "To":"+918755227406",
  //     "CallerId":"095-138-86363",
  //     "StatusCallback":"https://yourstatuscallbackurl.com",
  //     "Record":true,
  //   };
  //
  //   Map<String,File> empty = {};
  //
  //   var response = await CallMasterApi.callPostUrlEncodedApiNoToken(ApiUrl.callUrl, fieldMap, empty);
  //
  //   debugPrint("response received");
  //
  //   if (response != null) {
  //     isRedirectingViaCall.value = true;
  //     // debugPrint("response (XML): $response");
  //
  //     var xmlDocument = xml.XmlDocument.parse(response.toString());
  //   debugPrint("xml ${xmlDocument}");
  //   debugPrint("xmlroot ${xmlDocument.rootElement}");
  //   debugPrint("xmlroot ${xmlDocument.rootElement.findElements('TwilioResponse')}");
  //     exotelResponse.value =  ExotelCallResponse.fromXml(xmlDocument.rootElement);
  //
  //     exotelStatus.value = xmlDocument.findAllElements('Status').map((element) => element.innerText).first;
  //     // debugPrint("status ${exotelStatus.value}");
  //     // debugPrint("exotel response ${exotelResponse.toString()}");
  //   }
  //   else{
  //     isRedirectingViaCall.value = false;
  //     debugPrint("call response = null");
  //   }
  // }

  // callCallingApi(BuildContext context, String from, String to) async {
  //   Dialogs.lottieLoading(context, "assets/lottiee/abhi_loading.json");
  //   debugPrint("calling");
  //
  //   String apiKey = "61de7148fd264d5808bf3d6e4d51a480a3e855e374d202d0";
  //   String apiToken = "62bad4a33a72cf2546ed67ef8e71d5823353fd4ea87bb9c2";
  //
  //   Map<String, dynamic> fieldMap = {
  //     "From":"+91$from",
  //     "To":"+91$to",
  //     // "From": "+919650824005",
  //     // "To": "+918755227406",
  //     "CallerId": "095-138-86363",
  //     "StatusCallback": "https://yourstatuscallbackurl.com",
  //     "Record": true,
  //   };
  //
  //
  //   var response = await CallMasterApi.callPostUrlEncodedApiNoToken(ApiUrl.callUrl, fieldMap, {});
  //   if (response != null) {
  //     debugPrint("Status Code: ${response is xml.XmlDocument ? 'N/A' : response.statusCode}"); // For XML responses, we don't have a status code
  //
  //     if (response is xml.XmlDocument) {
  //       debugPrint("xml ${response}");
  //       debugPrint("xmlroot ${response.rootElement}");
  //
  //       exotelResponse.value = ExotelCallResponse.fromXml(response.rootElement);
  //       exotelStatus.value = response.findAllElements('Status').map((element) => element.innerText).first;
  //
  //
  //       await Future.delayed(Duration(seconds: 5));
  //       Navigator.pop(context); // Close the loading dialog
  //       debugPrint("Five seconds have passed. Proceeding with further actions...");
  //
  //     } else {
  //       Navigator.pop(context); // Close the loading dialog
  //       debugPrint("call response not successful, status code: ${response.statusCode}");
  //     }
  //   } else {
  //     Navigator.pop(context); // Close the loading dialog
  //     debugPrint("call response is null");
  //   }
  // }
}
