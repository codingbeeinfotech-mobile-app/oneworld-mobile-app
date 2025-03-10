import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/model/response_model/reason_list_response.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/delivered_pages/available_deliveries.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/delivered_pages/pay_phi_ui.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pinput/pinput.dart';
import 'package:signature/signature.dart';

import '../../../../controller/dashboard_routes_controller/delivery_location_controller.dart';
import '../../../../utils/barcode_scanner.dart';
import '../../../../utils/image_picker.dart';

class SubmitDelivery extends StatefulWidget {
  const SubmitDelivery({super.key});

  @override
  State<SubmitDelivery> createState() => _SubmitDeliveryState();
}

class _SubmitDeliveryState extends State<SubmitDelivery>
    with WidgetsBindingObserver {
  var deliveryLocationController = Get.find<DeliveryLocationController>();
  TextEditingController locationSearchController = TextEditingController();
  final MobileScannerController cameraController = MobileScannerController();
  final List<dynamic> list = []; // Replace with your actual list
  final AudioPlayer player = AudioPlayer();
  var loginController = Get.find<LoginController>();
  GeneralMethods generalMethods = GeneralMethods();
  late double deviceHeight, deviceWidth;
  static GlobalKey key = GlobalKey();
  static GlobalKey secondKey = GlobalKey();

  static const int otpResendTimeout = 30;

  Timer? _timer;

  RxInt start = 0.obs;

  // bool _isButtonDisabled = true;
  bool _isTimerStarted = false;

  void startTimer() {
    if (_isTimerStarted) {
      debugPrint("here");
      _timer?.cancel();
    }
    deliveryLocationController.isButtonDisabled.value = true;
    start.value = otpResendTimeout;
    _isTimerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (start.value == 0) {
        setState(() {
          deliveryLocationController.isButtonDisabled.value = false;
          _isTimerStarted = false;
        });
        timer.cancel();
      } else {
        setState(() {
          start.value--;
        });
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    debugPrint("From Payphi Back");
    super.initState();

    Future.delayed(
      Duration(seconds: 0),
      () {
        WidgetsBinding.instance.addObserver(this);
        if (deliveryLocationController.statusCheckTimer != null &&
            deliveryLocationController.statusCheckTimer!.isActive) {
          debugPrint("Timer cancel");
          deliveryLocationController.statusCheckTimer!.cancel();
        }

        deliveryLocationController.isPaymentPageOpened.value = false;
        deliveryLocationController.reasonInfoList.clear();
        deliveryLocationController.reasonDescription.clear();
        deliveryLocationController.isRedirectingViaCall.value = false;

        call();
      },
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //
  //  if (state == AppLifecycleState.paused) {
  //     if(deliveryLocationController.isRedirectingViaCall.value) {
  //       debugPrint("closing the loader as api is being called");
  //       Navigator.pop(context);
  //     }
  //     debugPrint("App redirected to another app or minimized.");
  //   } else if (state == AppLifecycleState.resumed) {
  //     debugPrint("App has returned to the foreground.");
  //   }
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Check if the page is being revisited after a pop from another page
  //   if (ModalRoute.of(context)?.isCurrent == true) {
  //     if(deliveryLocationController.transactionId.value != ""){
  //       debugPrint("Hello from payphi");
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         receiverFormDialogBox(context);
  //       });
  //
  //     }
  //   }
  // }

  call() async {
    deliveryLocationController.exotelResponse.value = null;
    deliveryLocationController.reasonListResponse.value = null;
    deliveryLocationController.isNDRSelected.value = false;
    deliveryLocationController.isButtonDisabled.value = true;
    deliveryLocationController.selectedNDR.value = "Select";
    deliveryLocationController.selectedNDRValue.value = "0";
    deliveryLocationController.receiversIndex.value = 0;
    deliveryLocationController.receivingAmount.value.clear();
    deliveryLocationController.receiversName.value.clear();
    deliveryLocationController.receiversContact.value.clear();
    deliveryLocationController.employerId.value.clear();
    deliveryLocationController.receiversSignatureBase64.value = "";
    deliveryLocationController.receiversSignatureImageByte = Uint8List(0).obs;
    deliveryLocationController.podImageByte = Uint8List(0).obs;
    deliveryLocationController.isOTPValid.value = false;
    deliveryLocationController.isCancellationOTPValid.value = false;
    deliveryLocationController.isRtoCheck.value = 2;
    deliveryLocationController.isOtpDialogBoxOpened.value = false;
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Color(0xffFF9B55),
          ),
          title: Text(
            "Delivery",
            style: TextStyle(fontSize: 20, color: Color(0xffFF9B55)),
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         // Get.to(const DeliveryList());
          //       },
          //       icon: const Icon(Icons.menu))
          // ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //         color: Color(0xFFE7E5ED),
                //       ),
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: DropdownButton2(
                //     isExpanded: true,
                //     underline: Container(),
                //     value: deliveryLocationController
                //         .selectedDeliveryLocation.value,
                //     onChanged: (selected) {
                //       setState(() {
                //         // deliveryLocationController
                //         //     .selectedDeliveryLocation.value = selected!;
                //         // deliveryLocationController.isTrackingNumberValid.value = false;
                //         // deliveryLocationController.amountController.value.clear();
                //         // deliveryLocationController.isRtoCheck.value = 2;
                //       });
                //     },
                //     items: deliveryLocationController.deliveryLocationList
                //         .toSet()
                //         .map((items) {
                //       return DropdownMenuItem(
                //           value: items,
                //           child: Text(
                //             items,
                //             style: const TextStyle(fontSize: 11),
                //             softWrap: true,
                //             overflow: TextOverflow.visible,
                //           ));
                //     }).toList(),
                //     dropdownSearchData: DropdownSearchData(
                //         searchController: locationSearchController,
                //         searchInnerWidgetHeight: 30,
                //         searchInnerWidget: Container(
                //           padding: const EdgeInsets.all(10),
                //           decoration: BoxDecoration(
                //               // border: Border.all(color: Colors.deepOrange.shade500),
                //               borderRadius: BorderRadius.circular(5)),
                //           child: SizedBox(
                //             child: TextFormField(
                //               controller: locationSearchController,
                //               decoration: InputDecoration(
                //                   hintText: 'Search',
                //                   isDense: true,
                //                   border: const OutlineInputBorder(
                //                       borderSide:
                //                           BorderSide(color: Colors.black45)),
                //                   suffixIcon: Icon(
                //                     Icons.search,
                //                     color: Colors.deepOrange.shade500,
                //                     size: 30,
                //                   )),
                //             ),
                //           ),
                //         )),
                //     onMenuStateChange: ((isOpen) {
                //       locationSearchController.clear();
                //       setState(() {});
                //     }),
                //   ),
                // ),
                SizedBox(height: 20),
                Visibility(
                    visible: deliveryLocationController
                            .selectedDeliveryLocation.value !=
                        "Select Delivery Location",
                    child: Container(
                      height: 290.h,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              // height: 282.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFE7E5ED),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Color(0xffE7E5ED))
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/delivery_location.png",
                                          height: 28.h,
                                          width: 28.w,
                                        ),
                                        Expanded(
                                          child: Text("${deliveryLocationController.selectedDeliveryLocation
                                              .value.capitalizeFirst}",maxLines: 3, style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis)),
                                        )
                                      ],
                                    ),
                                  ),
                                  /*TextFormField(
                                    controller: TextEditingController(
                                        text: deliveryLocationController
                                            .selectedDeliveryLocation
                                            .value
                                            .capitalizeFirst),
                                    readOnly: true,
                                    maxLines: null,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis),
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        constraints: BoxConstraints(
                                            minHeight: 64.h, maxHeight: 64.h),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffE7E5ED)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffE7E5ED)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffE7E5ED)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffE7E5ED)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffE7E5ED)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        hintText: "Delivery Location Name",
                                        hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        prefixIcon: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/delivery_location.png",
                                              height: 28.h,
                                              width: 28.w,
                                            ),
                                          ],
                                        )),
                                  ),*/
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Toatal Order",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                              ),
                                              child: TextFormField(
                                                controller: TextEditingController(
                                                    text: deliveryLocationController
                                                            .isTrackingNumberValid
                                                            .value
                                                        ? "1"
                                                        : "0"),
                                                readOnly: true,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                decoration: InputDecoration(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 99.w,
                                                        minWidth: 99.w,
                                                        maxHeight: 40.h,
                                                        minHeight: 40.h),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFE7E5ED)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFE7E5ED)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    labelStyle: const TextStyle(
                                                      color: Color(0xFFE7E5ED),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Amount",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                              ),
                                              child: TextFormField(
                                                maxLines: 1,
                                                controller:
                                                    deliveryLocationController
                                                            .isOrderCOD.value
                                                        ? deliveryLocationController
                                                            .amountController
                                                            .value
                                                        : TextEditingController(
                                                            text: "₹ 0.0"),
                                                readOnly: false,
                                                enabled: true,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                decoration: InputDecoration(
                                                    constraints: BoxConstraints(
                                                        maxHeight: 40.h,
                                                        maxWidth: 99.w,
                                                        minWidth: 99.w,
                                                        minHeight: 40.h),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFE7E5ED)),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5)),
                                                    disabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFE7E5ED)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFE7E5ED)),
                                                        borderRadius:
                                                            BorderRadius.circular(5)),
                                                    labelStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFFE7E5ED),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),

                                        /*  SizedBox(
                                          height: 50,
                                          width: MediaQuery.sizeOf(context).width * 0.2,
                                          child: TextFormField(
                                            maxLines: 1,
                                            controller: TextEditingController(
                                                text: deliveryLocationController
                                                        .isTrackingNumberValid.value
                                                    ? "1"
                                                    : "0"),
                                            readOnly: true,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis),
                                            decoration: InputDecoration(
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.black45),
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                labelText: "Scan Count",
                                                labelStyle: const TextStyle(
                                                  color: Colors.black45,
                                                )),
                                          ),
                                        ),*/

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "RTO",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                              ),
                                              child: TextFormField(
                                                maxLines: 1,
                                                controller:
                                                    TextEditingController(
                                                        text: deliveryLocationController
                                                                    .isRtoCheck
                                                                    .value ==
                                                                0
                                                            ? "No"
                                                            : deliveryLocationController
                                                                        .isRtoCheck
                                                                        .value ==
                                                                    1
                                                                ? "Yes"
                                                                : ""),
                                                readOnly: true,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                decoration: InputDecoration(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 99.w,
                                                        minWidth: 99.w,
                                                        maxHeight: 40.h,
                                                        minHeight: 40.h),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 3.w),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFE7E5ED)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color(
                                                                    0xFFE7E5ED)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    labelStyle: const TextStyle(
                                                      color: Color(0xFFE7E5ED),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 54.h,
                                    child: TextFormField(
                                      // controller: TextEditingController(text: deliveryLocationController.scannedTrackingNumber.value),
                                      readOnly: false,
                                      // readOnly: deliveryLocationController.isTrackingNumberValid.value?
                                      // true:false,
                                      controller: deliveryLocationController
                                          .trackingNumberController.value,
                                      maxLines: 1,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      onFieldSubmitted: (value) async {
                                        debugPrint("value is $value");
                                        Dialogs.lottieLoading(context,
                                            'assets/lottiee/abhi_loading.json');
                                        await deliveryLocationController
                                            .callValidateTrackingNumberApi(
                                                value);
                                        //   .then(
                                        // (_) {
                                        Navigator.pop(context);
                                        //   if (deliveryLocationController
                                        //           .isTrackingNumberValid.value &&
                                        //       !deliveryLocationController
                                        //           .isOrderCOD.value) {
                                        //     showVerifyOtpDialog(context);
                                        //   }

                                        // deliveryLocationController.validateTrackingNumber();
                                      },
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Color(0xff7A7A7A),
                                            fontSize: 16.sp,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFE7E5ED)),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xffE7E5ED)),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          labelText: "Search Tracking No",
                                          suffixIcon: InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MybatteryScanner(
                                                    onDetect: (String val) {
                                                      deliveryLocationController
                                                          .trackingNumberController
                                                          .value
                                                          .text = val;
                                                    },
                                                  ),
                                                ),
                                              );

                                              if (deliveryLocationController
                                                  .trackingNumberController
                                                  .value
                                                  .text
                                                  .isNotEmpty) {
                                                await deliveryLocationController
                                                    .callValidateTrackingNumberApi(
                                                        deliveryLocationController
                                                            .trackingNumberController
                                                            .value
                                                            .text);
                                              } else {
                                                debugPrint("Clear");
                                              }
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 4.h),
                                              child: Image.asset(
                                                "assets/images/barcode.png",
                                                height: 36.h,
                                                width: 36.w,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -1.h,
                            left: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Delivery Details",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),

                Visibility(
                  visible:
                      deliveryLocationController.isTrackingNumberValid.value,
                  child: Container(

                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color(0xffE7E5ED)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 36.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                ),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF9F9F9),
                                    border: Border(
                                      right: BorderSide(
                                        color:
                                        Color(0xffE7E5ED),
                                        width: 0.5,
                                      ),
                                    ),
                                    borderRadius:
                                    BorderRadius.only(
                                        topLeft:
                                        Radius.circular(
                                            8))),
                                child: const Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tracking Number",
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 36.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.only(
                                      topRight:
                                      Radius.circular(
                                          8)),
                                  border: Border(
                                    left: BorderSide(
                                      //                   <--- right side
                                      color: Color(0xffE7E5ED),
                                      width: 0.5,
                                    ),
                                  ),
                                  color: Color(0xFFF9F9F9),
                                ),
                                child: const Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: 36.h,
                                padding:
                                EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        color: Color(
                                            0xffE7E5ED),
                                        width: 0.5,
                                      ),
                                    ),
                                    borderRadius:  BorderRadius.only(
                                        bottomLeft: Radius
                                            .circular(
                                            8))),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors
                                                  .white)),
                                      child:  Text(
                                        deliveryLocationController
                                            .scannedTrackingNumber.value,
                                        maxLines: null,
                                        style:   TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors
                                                .black,
                                            fontWeight:
                                            FontWeight
                                                .w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(


                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        color: Color(
                                            0xffE7E5ED),
                                        width: 0.5,
                                      ),
                                    ),
                                    borderRadius:   BorderRadius.only(
                                        bottomRight: Radius
                                            .circular(
                                            8))),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    GestureDetector(onTap: () {
                                      getNprDropdown(context);
                                    },
                                      child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),

                                        margin: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                                        decoration: BoxDecoration(
                                            color: Color(
                                                0xFFFF9B55),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8)),
                                        child: Center(
                                          child: Text(
                                            "${deliveryLocationController.selectedNDR.value.toString()}",

                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors
                                                    .white,
                                                fontWeight:
                                                FontWeight
                                                    .w400),
                                          ),
                                        ),
                                      ),
                                    ) // const SizedBox(height: 8.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),

                // Visibility(
                //   visible:
                //       deliveryLocationController.isTrackingNumberValid.value,
                //   child: DataTable(
                //     columnSpacing: 20,
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: Color(0xFFE7E5ED),
                //       ),
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(5),
                //     ),
                //     columns: const [
                //       DataColumn(
                //         label: Text(
                //           "Tracking Number",
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       DataColumn(
                //         label: Text(
                //           "Status",
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ],
                //     rows: [
                //       DataRow(
                //         cells: [
                //           DataCell(
                //             Row(
                //               children: [
                //                 Text(
                //                   deliveryLocationController
                //                       .scannedTrackingNumber.value,
                //                   style: const TextStyle(
                //                     fontSize: 13.0,
                //                     color: Colors.black54,
                //                     fontWeight: FontWeight.w500,
                //                   ),
                //                 ),
                //                 const VerticalDivider(
                //                   color: Color(0xFFE7E5ED),
                //                   thickness: 1,
                //                   width: 1,
                //                 ),
                //               ],
                //             ),
                //           ),
                //           DataCell(
                //             Row(
                //               children: [
                //                 SizedBox(
                //                   width: 150, // Adjust width for button
                //                   child: ElevatedButton(
                //                     style: ButtonStyle(
                //                       backgroundColor:
                //                           MaterialStateProperty.all(
                //                         Color(0XFFFF9B55),
                //                       ),
                //                     ),
                //                     onPressed: () {
                //                       getNprDropdown(context);
                //                     },
                //                     child: Text(
                //                       deliveryLocationController
                //                           .selectedNDR.value
                //                           .toString(),
                //                       overflow: TextOverflow.visible,
                //                       style:
                //                           TextStyle(color: Color(0xffFFFFFF)),
                //                     ),
                //                   ),
                //                 ),
                //                 const VerticalDivider(
                //                   color: Color(0xFFE7E5ED),
                //                   thickness: 1,
                //                   width: 1,
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

                /// ------------------- Call Feature-----------
//                 Visibility(
//                     visible:
//                         deliveryLocationController.isTrackingNumberValid.value,
//                     child: Container(
//                       padding: const EdgeInsets.all(10.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 3,
//                             blurRadius: 5,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         // crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(height:10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(50.0)),
//                                       border: Border.all(
//                                         color: Colors.black,
//                                         width: 1.5,
//                                       ),
//                                     ),
//                                     child: const CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       child: Icon(
//                                         Icons.person,
//                                         size: 25,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width:15),
//                                   Text(
//                                     deliveryLocationController.validateTrackingNumberResponse.value != null && deliveryLocationController.validateTrackingNumberResponse.value!.data!= null && deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString().isNotEmpty?
//                                     deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString() :
//                                     "OneWorld Customer",style: const TextStyle(fontWeight: FontWeight.w500),
//                                   ),
//                                 ],
//                               ),
//
//                               Expanded(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap :() async {
//
//                                           debugPrint(GeneralMethods.receiversName.value);
//                                           debugPrint(GeneralMethods.receiversMobileNumber.value);
//                                           debugPrint(GeneralMethods.mobileNo.value);
//                                           if(GeneralMethods.mobileNo.value.isEmpty || GeneralMethods.receiversMobileNumber.value.isEmpty){
//                                             MyToast.myShowToast("Can't Make this call");
//                                           }
//                                           else{
//                                             // Dialogs.lottieLoading(context, "assets/lottiee/abhi_loading.json");
//                                            // await deliveryLocationController.callCallingApi(context,GeneralMethods.mobileNo.value,GeneralMethods.receiversMobileNumber.value);
//                                            await deliveryLocationController.callCallingApi(context,"9205634005","8755227406");
//
//                                            // if(!deliveryLocationController.isRedirectingViaCall.value){
//                                            //   Navigator.pop(context);
//                                            // }
//
//                                            // if(deliveryLocationController.isRedirectingViaCall.value && deliveryLocationController.exotelStatus.value == "in-progress"){
//                                            //   debugPrint("closing");
//                                            //   Navigator.pop(context);
//                                            // }
//
//                                           }
//                                         },
//                                         child: CircleAvatar(
//                                           backgroundColor: Colors.green,
//                                           child: Icon(Icons.call,color: Colors.white,),
//                                         ),
//                                       ),
//                                       const SizedBox(width:10),                                    ],
//                                   )
//                               )
//
//
//
//                             ],),
//                           const SizedBox(height:10),
//
//                         ],
//                       ),
//                     )
//                     ),
//                 const SizedBox(height: 20),
                const SizedBox(height: 20),
                Visibility(
                  visible:
                      deliveryLocationController.isTrackingNumberValid.value,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 150,
                          /*deliveryLocationController.isOrderCOD.value
                      ? MediaQuery.sizeOf(context).width / 2
                      : MediaQuery.sizeOf(context).width * 0.80,*/
                          // padding: const EdgeInsets.only(right: 25),
                          child: InkWell(
                            onTap: () async {
                              var isRto = deliveryLocationController
                                  .validateTrackingNumberResponse
                                  .value!
                                  .data!
                                  .isRto;
                              bool isB2C = ((deliveryLocationController
                                          .validateTrackingNumberResponse
                                          .value!
                                          .data!
                                          .transporterId!
                                          .toLowerCase()) ==
                                      'xc') ||
                                  ((deliveryLocationController
                                          .validateTrackingNumberResponse
                                          .value!
                                          .data!
                                          .transporterId!
                                          .toLowerCase()) ==
                                      'sdd');
                              if (deliveryLocationController
                                  .isOrderCOD.value) {
                                debugPrint("COD Case");
                                if (deliveryLocationController
                                            .selectedNDRValue.value ==
                                        '2' &&
                                    isB2C &&
                                    isRto == 0) {
                                  debugPrint("Cancel Case");
                                  if (!deliveryLocationController
                                      .isOtpDialogBoxOpened.value) {
                                    deliveryLocationController
                                        .isOtpDialogBoxOpened.value = true;
                                    showVerifyCancellationOtpDialog(
                                        context);
                                  } else {
                                    MyToast.myShowToast("Wait");
                                  }
                                  // showVerifyCancellationOtpDialog(context);
                                } else if (deliveryLocationController
                                        .selectedNDRValue.value ==
                                    '0') {
                                  debugPrint("Receiver Form Case");
                                  // receiverFormDialogBox(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      deliveryLocationController
                                          .receiversIndex.value = 0;
                                      deliveryLocationController
                                          .receivingAmount.value
                                          .clear();
                                      deliveryLocationController
                                          .receiversName.value
                                          .clear();
                                      deliveryLocationController
                                          .receiversContact.value
                                          .clear();
                                      deliveryLocationController
                                          .receiversSignatureBase64
                                          .value = "";
                                      deliveryLocationController
                                          .receiversSignatureImageByte
                                          .value = Uint8List(0);
                                      deliveryLocationController
                                          .podImageByte
                                          .value = Uint8List(0);
                                      return const ReceiverForm();
                                    },
                                  );
                                } else {
                                  debugPrint("Direct Submit");
                                  await deliveryLocationController
                                      .callDeliverySubmitApi(context);
                                }
                              } else {
                                debugPrint("Prepaid Case");

                                if (deliveryLocationController
                                            .selectedNDRValue.value ==
                                        '0' &&
                                    isB2C &&
                                    isRto == 0) {
                                  debugPrint("Select Case");

                                  showVerifyOtpDialog(context);
                                } else if (deliveryLocationController
                                            .selectedNDRValue.value ==
                                        '2' &&
                                    isB2C &&
                                    isRto == 0) {
                                  debugPrint("Cancel Case");

                                  if (!deliveryLocationController
                                      .isOtpDialogBoxOpened.value) {
                                    deliveryLocationController
                                        .isOtpDialogBoxOpened.value = true;
                                    showVerifyCancellationOtpDialog(
                                        context);
                                  } else {
                                    MyToast.myShowToast("Wait");
                                  }
                                } else {
                                  debugPrint("Direct Submit Case");
                                  await deliveryLocationController
                                      .callDeliverySubmitApi(context);
                                }
                              }
                            },
                            child: Container(
                              width: 150.w,
                              height: 38.h,
                              padding: const EdgeInsets.only(
                                  left: 22, top: 10, bottom: 10, right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF9B55),
                                    Color(0xFFE3622D)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Center(
                                child: Text("Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        if (deliveryLocationController.isOrderCOD.value &&
                            !deliveryLocationController.isNDRSelected.value &&
                            deliveryLocationController.transactionId.value ==
                             "")
                        SizedBox(
                          height: 50,
                          // width: MediaQuery.sizeOf(context).width,
                          // padding: const EdgeInsets.only(right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  debugPrint(
                                      "oder ${deliveryLocationController.isOrderCOD.value}");
                                  double amnt = double.parse(
                                      deliveryLocationController
                                          .amountController.value.text);
                                  if (ApiUrl.payPhiMerchantId == "P_32395") {
                                    ///Live
                                    if (amnt >= 10) {
                                      Get.to(const PayPhiQrCodeGenerator());
                                    } else {
                                      MyToast.myShowToast(
                                          "Payment Below 10 Rs. is not accepted");
                                    }
                                  }

                                  ///For test
                                  else {
                                    Get.to(const PayPhiQrCodeGenerator());
                                  }
                                },
                                child: Container(
                                  width: 150.w,
                                  height: 38.h,
                                  padding: const EdgeInsets.only(
                                      left: 22, top: 10, bottom: 10, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(
                                            0xffFF9B55)), // Corrected border property
                                  ),
                                  child: Center(
                                    child: Text("UPI",
                                        style: TextStyle(
                                            color: Color(0xffFF9B55),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )

                ///--------------------
                // Visibility(
                //   visible:
                //       deliveryLocationController.isTrackingNumberValid.value &&
                //           !((deliveryLocationController.isOrderCOD.value)
                //               ? true
                //               : deliveryLocationController.isOTPValid.value),
                //   child: MaterialButton(
                //     height: deviceHeight * 0.06,
                //     color: Colors.deepOrange.shade500,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     onPressed: () {
                //       showVerifyOtpDialog(context);
                //     },
                //     child: const Text(
                //       'Verify OTP',
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }

  getNprDropdown(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Obx(() {
          return AlertDialog(
            title: const Center(child: Text("Non Delivery Reason")),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45)),
                    // height:30,

                    width: MediaQuery.sizeOf(context).width,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: Container(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.deepOrange,
                        size: 40,
                      ),
                      value: deliveryLocationController.selectedNDR.value,
                      onChanged: (newValue) {
                        setState(() {
                          deliveryLocationController.selectedNDR.value =
                              newValue!;
                          List<ReasonInformation> temp = [];
                          // var temp = [];
                          if (newValue == "Select" ||
                              newValue == "NDR" ||
                              newValue == "RTO NDR") {
                            deliveryLocationController.selectedNDRValue.value =
                                "0";
                            deliveryLocationController.isNDRSelected.value =
                                false;
                          } else {
                            temp.add(deliveryLocationController.reasonInfoList
                                .firstWhere((element) =>
                                    element.codeDescription == newValue));
                            deliveryLocationController.selectedNDRValue.value =
                                temp[0].codeId.toString();
                            deliveryLocationController.isNDRSelected.value =
                                true;
                          }
                          debugPrint(
                              "ndr value ${deliveryLocationController.selectedNDRValue.value}");
                          debugPrint(
                              "${deliveryLocationController.selectedNDR.value}");
                          // print("Selected ${deliveryLocationController.selectedNDR} and value ${deliveryLocationController.selectedNDRValue}");
                        });
                      },
                      items: deliveryLocationController.reasonDescription
                          .toSet()
                          .toList()
                          .map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            maxLines: null,
                            style: const TextStyle(
                                fontSize: 13.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Yes"))
                ],
              ),
            ),
          );
        });
      },
    );
  }

  showVerifyOtpDialog(BuildContext context) async {
    if (key.currentContext != null) {
      Navigator.pop(context);
    } else {
      deliveryLocationController.isOTPValid.value = false;

      deliveryLocationController.otpControllers.value = [];

      startTimer();
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            key: key,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              margin: const EdgeInsets.all(10),
              height: deviceHeight * 0.3,
              width: deviceWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  OtpTextField(
                    fieldWidth: deviceWidth * 0.1,
                    showFieldAsBox: true,
                    numberOfFields: 5,
                    cursorColor: Colors.black,
                    borderColor: Colors.black,
                    textStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    handleControllers: (c) {
                      deliveryLocationController.otpControllers.value = c;
                    },
                  ),
                  MaterialButton(
                    height: deviceHeight * 0.07,
                    minWidth: deviceWidth * 0.8,
                    color: Colors.deepOrange.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      debugPrint(deliveryLocationController
                          .validateTrackingNumberResponse.value?.data?.otp
                          .toString());
                      debugPrint("otp ${deliveryLocationController.otpText}");

                      if ((deliveryLocationController
                                      .validateTrackingNumberResponse
                                      .value
                                      ?.data
                                      ?.otp ??
                                  0)
                              .toString()
                              .length >
                          1) {
                        if ((deliveryLocationController
                                    .validateTrackingNumberResponse
                                    .value!
                                    .data!
                                    .otp)
                                .toString() ==
                            deliveryLocationController.otpText) {
                          deliveryLocationController.isOTPValid.value = true;
                          debugPrint(deliveryLocationController
                              .validateTrackingNumberResponse.value?.data?.otp
                              .toString());
                          debugPrint('IsValid');
                          MyToast.myShowToast("OTP verification successful");
                          Navigator.pop(context);
                          // receiverFormDialogBox(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              deliveryLocationController.receiversIndex.value =
                                  0;
                              deliveryLocationController.receivingAmount.value
                                  .clear();
                              deliveryLocationController.receiversName.value
                                  .clear();
                              deliveryLocationController.receiversContact.value
                                  .clear();
                              deliveryLocationController
                                  .receiversSignatureImageByte
                                  .value = Uint8List(0);
                              deliveryLocationController.podImageByte.value =
                                  Uint8List(0);
                              return const ReceiverForm();
                            },
                          );
                        } else {
                          MyToast.myShowToast("Incorrect OTP");
                        }
                      }
                      // deliveryLocationController.isOTPValid.value = true;
                      // Navigator.pop(context);
                    },
                  ),
                  //Resend OTP Button
                  /*  Obx(() => Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Resend in ${start.value} seconds',
                          style: const TextStyle(fontSize: 12,color: Colors.black45),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (!deliveryLocationController.isButtonDisabled.value) {
                              startTimer();
                              await deliveryLocationController.sendFixedOTP(
                                context,
                                deliveryLocationController
                                    .validateTrackingNumberResponse.value?.data!
                                    .otp! ?? 11111,
                                deliveryLocationController
                                    .validateTrackingNumberResponse.value?.data
                                    ?.receiverPhoneNo ??
                                    '',

                              );
                            }
                          },
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(fontSize: 14, color: deliveryLocationController.isButtonDisabled.value ? Colors.black45:Colors.deepOrange.shade500),
                          ),
                        )

                      ],
                    ),
                  )), */
                ],
              ),
            ),
          );
        },
      );
    }
  }

  showVerifyCancellationOtpDialog(BuildContext context) async {
    if (secondKey.currentContext != null) {
      Navigator.pop(context);
    } else {
      deliveryLocationController.isCancellationOTPValid.value = false;
      // if (!kDebugMode) {
      await deliveryLocationController.sendOTP(
        context,
        deliveryLocationController.cancellationOtpSent,
        deliveryLocationController
                .validateTrackingNumberResponse.value?.data?.receiverPhoneNo ??
            '',
      );

      deliveryLocationController.isOtpDialogBoxOpened.value = false;
      // } else {
      //   var random = Random();
      //   deliveryLocationController.cancellationOtpSent.value =
      //       random.nextInt(900000) + 100000;

      // }
      debugPrint(
          deliveryLocationController.cancellationOtpSent.value.toString());
      startTimer();
      // String otp;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            key: secondKey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              margin: const EdgeInsets.all(10),
              height: deviceHeight * 0.30,
              width: deviceWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  OtpTextField(
                    fieldWidth: deviceWidth * 0.1,
                    showFieldAsBox: true,
                    numberOfFields: 6,
                    cursorColor: Colors.black,
                    borderColor: Colors.black,
                    textStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    handleControllers: (c) {
                      deliveryLocationController.cancelOtpControllers.value = c;
                    },
                    // onCodeChanged: (val) {},
                    // onCodeChanged: (val) {
                    //   if (val ==
                    //       deliveryLocationController.cancellationOtpSent
                    //           .toString()) {
                    //     debugPrint("Valid Otp");
                    //     deliveryLocationController.isCancellationOTPValid.value =
                    //         true;
                    //   } else {
                    //     deliveryLocationController.isCancellationOTPValid.value =
                    //         false;
                    //   }
                    // },
                  ),
                  MaterialButton(
                    height: deviceHeight * 0.07,
                    minWidth: deviceWidth * 0.8,
                    color: Colors.deepOrange.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () async {
                      debugPrint(deliveryLocationController.cancelOtpText);
                      debugPrint(deliveryLocationController.cancellationOtpSent
                          .toString());
                      if (deliveryLocationController.cancelOtpText ==
                          deliveryLocationController.cancellationOtpSent
                              .toString()) {
                        // Navigator.pop(context);
                        MyToast.myShowToast("OTP verification successful");
                        await deliveryLocationController
                            .callDeliverySubmitApi(context);
                      } else {
                        MyToast.myShowToast("Incorrect OTP");
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  //Resend OTP Button
                  /*  Obx(() => Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Resend in ${start.value} seconds',
                        style: const TextStyle(fontSize: 12,color: Colors.black45),
                      ),
                      TextButton(
                        onPressed: () async {
                         if(!deliveryLocationController.isButtonDisabled.value){
                           startTimer();
                           await deliveryLocationController.sendOTP(
                             context,
                             deliveryLocationController.cancellationOtpSent,
                             deliveryLocationController
                                 .validateTrackingNumberResponse.value?.data?.receiverPhoneNo ??
                                 '',
                           );
                         }
                        },
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(fontSize: 14, color: deliveryLocationController.isButtonDisabled.value ? Colors.black45:Colors.deepOrange.shade500),
                        ),
                      )

                    ],
                  ),
                )), */
                ],
              ),
            ),
          );
        },
      );
    }
  }

  receiverFormDialogBox(BuildContext context) {
    debugPrint("Yo");
    var loginController = Get.find<LoginController>();
    var deliveryLocationController = Get.find<DeliveryLocationController>();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Obx(() {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(15),
              title: const Text("Receiver's Details"),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              debugPrint("Tapped");
                              setState(() {
                                deliveryLocationController
                                    .receiversIndex.value = 1;
                                deliveryLocationController.receivingAmount.value
                                    .clear();
                                deliveryLocationController.receiversName.value
                                    .clear();
                                deliveryLocationController
                                    .receiversContact.value
                                    .clear();
                                deliveryLocationController
                                        .receivingAmount.value.text =
                                    deliveryLocationController
                                        .validateTrackingNumberResponse
                                        .value!
                                        .data!
                                        .codValue
                                        .toString();
                                deliveryLocationController
                                        .receiversName.value.text =
                                    deliveryLocationController
                                        .validateTrackingNumberResponse
                                        .value!
                                        .data!
                                        .receiverName
                                        .toString();
                                deliveryLocationController
                                    .receiversSignatureImageByte
                                    .value = Uint8List(0);
                                deliveryLocationController.podImageByte.value =
                                    Uint8List(0);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: deliveryLocationController
                                          .receiversIndex.value ==
                                      1
                                  ? Colors.deepOrange.shade500
                                  : Colors.grey,
                              child: const Text("Self",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black)),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              setState(() {
                                deliveryLocationController
                                    .receiversIndex.value = 2;
                                deliveryLocationController.receivingAmount.value
                                    .clear();
                                deliveryLocationController.receiversName.value
                                    .clear();
                                deliveryLocationController
                                    .receiversContact.value
                                    .clear();
                                deliveryLocationController
                                    .receiversSignatureImageByte
                                    .value = Uint8List(0);
                                deliveryLocationController.podImageByte.value =
                                    Uint8List(0);
                                deliveryLocationController
                                        .receivingAmount.value.text =
                                    deliveryLocationController
                                        .validateTrackingNumberResponse
                                        .value!
                                        .data!
                                        .codValue
                                        .toString();
                                // deliveryLocationController.receiversName.value.text = deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: deliveryLocationController
                                          .receiversIndex.value ==
                                      2
                                  ? Colors.deepOrange.shade500
                                  : Colors.grey,
                              child: const Text("Family",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              deliveryLocationController.receiversIndex.value =
                                  3;
                              deliveryLocationController.receivingAmount.value
                                  .clear();
                              deliveryLocationController.receiversContact.value
                                  .clear();
                              deliveryLocationController.receiversName.value
                                  .clear();
                              deliveryLocationController
                                  .receiversSignatureImageByte
                                  .value = Uint8List(0);
                              deliveryLocationController.podImageByte.value =
                                  Uint8List(0);
                              deliveryLocationController
                                      .receivingAmount.value.text =
                                  deliveryLocationController
                                      .validateTrackingNumberResponse
                                      .value!
                                      .data!
                                      .codValue
                                      .toString();
                              // deliveryLocationController.receiversName.value.text = deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: deliveryLocationController
                                          .receiversIndex.value ==
                                      3
                                  ? Colors.deepOrange.shade500
                                  : Colors.grey,
                              child: const Text("Neighbour",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black)),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              setState(() {
                                deliveryLocationController
                                    .receiversIndex.value = 4;

                                deliveryLocationController.receivingAmount.value
                                    .clear();
                                deliveryLocationController.receiversName.value
                                    .clear();
                                deliveryLocationController
                                    .receiversContact.value
                                    .clear();
                                deliveryLocationController
                                    .receiversSignatureImageByte
                                    .value = Uint8List(0);
                                deliveryLocationController.podImageByte.value =
                                    Uint8List(0);
                                deliveryLocationController
                                        .receivingAmount.value.text =
                                    deliveryLocationController
                                        .validateTrackingNumberResponse
                                        .value!
                                        .data!
                                        .codValue
                                        .toString();
                                // deliveryLocationController.receiversName.value.text = deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: deliveryLocationController
                                          .receiversIndex.value ==
                                      4
                                  ? Colors.deepOrangeAccent.shade400
                                  : Colors.grey,
                              child: const Text("Guard",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          TextFormField(
                            // readOnly: true,
                            // enabled: false,
                            controller: TextEditingController(
                                text: loginController.loginResponse!.uSERID),
                            focusNode: deliveryLocationController
                                .employerIdFocusNode.value,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                labelText: "Employee ID/Photo Id",
                                labelStyle:
                                    const TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 7),
                          TextFormField(
                            controller:
                                deliveryLocationController.receiversName.value,
                            focusNode: deliveryLocationController
                                .receiversNameFocusNode.value,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                labelText: "Name",
                                labelStyle:
                                    const TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 7),
                          TextFormField(
                            controller: deliveryLocationController
                                .receiversContact.value,
                            focusNode: deliveryLocationController
                                .receiversContactFocusNode.value,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                labelText: "Contact",
                                labelStyle:
                                    const TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 7),
                          TextFormField(
                            readOnly: false,
                            enabled: true,
                            controller: deliveryLocationController
                                .receivingAmount.value,
                            focusNode: deliveryLocationController
                                .receivingAmountFocusNode.value,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(5)),
                                labelText: "Amount",
                                labelStyle:
                                    const TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black45)),
                            child: InkWell(
                              onTap: () {
                                Get.dialog(const SignatureCanvas());
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,

                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 20),
                                  deliveryLocationController
                                          .receiversSignatureImageByte
                                          .value!
                                          .isEmpty
                                      ? CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/add-image.png'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey[200],
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: DecorationImage(
                                                      image: MemoryImage(
                                                          deliveryLocationController
                                                              .receiversSignatureImageByte
                                                              .value!),
                                                      fit: BoxFit.fill))),
                                        ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Signature",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          callImageAdder(
                              deliveryLocationController.podImageByte,
                              deliveryLocationController.podSelectedImage,
                              "Upload POD"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40,
                                // width: MediaQuery.sizeOf(context).width,
                                // padding: const EdgeInsets.only(right: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (deliveryLocationController
                                            .receiversName.value.text.isEmpty) {
                                          deliveryLocationController
                                              .receiversNameFocusNode.value
                                              .requestFocus();
                                          MyToast.myShowToast(
                                              "Name can't be empty");
                                        } else if (deliveryLocationController
                                                .receiversContact
                                                .value
                                                .text
                                                .isEmpty ||
                                            deliveryLocationController
                                                    .receiversContact
                                                    .value
                                                    .length !=
                                                10 ||
                                            deliveryLocationController
                                                .receiversContact.value.text
                                                .startsWith('0') ||
                                            !deliveryLocationController
                                                .receiversContact
                                                .value
                                                .text
                                                .isNumericOnly) {
                                          deliveryLocationController
                                              .receiversContactFocusNode.value
                                              .requestFocus();
                                          MyToast.myShowToast(
                                              "Please Provide valid Receiver's Contact Number");
                                        } else if (deliveryLocationController
                                            .receivingAmount
                                            .value
                                            .text
                                            .isEmpty) {
                                          deliveryLocationController
                                              .receivingAmountFocusNode.value
                                              .requestFocus();
                                          MyToast.myShowToast(
                                              "Receiving Amount can't be empty");
                                        } else if (deliveryLocationController
                                            .receiversSignatureImageByte
                                            .value!
                                            .isEmpty) {
                                          MyToast.myShowToast(
                                              "Please Provide Your Signature");
                                        } else {
                                          debugPrint(
                                              "Receiver's Details Validated");
                                          await deliveryLocationController
                                              .callDeliverySubmitApi(context);
                                          // Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.40,
                                        padding: const EdgeInsets.only(
                                            left: 22,
                                            top: 10,
                                            bottom: 10,
                                            right: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.deepOrange.shade500,
                                                Colors.deepOrange
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomCenter),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text("Save",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget callImageAdder(
      Rx<Uint8List?> ImageBytes, Rx<File?> SelectedImage, String title) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black45)),
      child: InkWell(
        onTap: () {
          PickImage().showImagePickerOption(ImageBytes, SelectedImage, context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            ImageBytes.value!.isEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/add-image.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: MemoryImage(ImageBytes.value!),
                                fit: BoxFit.fill))),
                  ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class ReceiverForm extends StatefulWidget {
  const ReceiverForm({super.key});

  @override
  State<ReceiverForm> createState() => _ReceiverFormState();
}

class _ReceiverFormState extends State<ReceiverForm> {
  @override
  Widget build(BuildContext context) {
    var loginController = Get.find<LoginController>();
    var deliveryLocationController = Get.find<DeliveryLocationController>();
    return Obx(() {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15),
        title: const Text("Receiver's Details"),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          deliveryLocationController.receiversIndex.value = 1;
                          deliveryLocationController.receivingAmount.value
                              .clear();
                          deliveryLocationController.receiversName.value
                              .clear();
                          deliveryLocationController.receiversContact.value
                              .clear();
                          deliveryLocationController
                                  .receivingAmount.value.text =
                              deliveryLocationController
                                  .validateTrackingNumberResponse
                                  .value!
                                  .data!
                                  .codValue
                                  .toString();
                          deliveryLocationController.receiversName.value.text =
                              deliveryLocationController
                                  .validateTrackingNumberResponse
                                  .value!
                                  .data!
                                  .receiverName
                                  .toString();
                          deliveryLocationController
                              .receiversSignatureImageByte.value = Uint8List(0);
                          deliveryLocationController.podImageByte.value =
                              Uint8List(0);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color:
                            deliveryLocationController.receiversIndex.value == 1
                                ? Colors.deepOrange.shade500
                                : Colors.grey,
                        child: const Text("Self",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          deliveryLocationController.receiversIndex.value = 2;
                          deliveryLocationController.receivingAmount.value
                              .clear();
                          deliveryLocationController.receiversName.value
                              .clear();
                          deliveryLocationController.receiversContact.value
                              .clear();
                          deliveryLocationController
                              .receiversSignatureImageByte.value = Uint8List(0);
                          deliveryLocationController.podImageByte.value =
                              Uint8List(0);
                          deliveryLocationController
                                  .receivingAmount.value.text =
                              deliveryLocationController
                                  .validateTrackingNumberResponse
                                  .value!
                                  .data!
                                  .codValue
                                  .toString();
                          // deliveryLocationController.receiversName.value.text = deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color:
                            deliveryLocationController.receiversIndex.value == 2
                                ? Colors.deepOrange.shade500
                                : Colors.grey,
                        child: const Text("Family",
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        deliveryLocationController.receiversIndex.value = 3;
                        deliveryLocationController.receivingAmount.value
                            .clear();
                        deliveryLocationController.receiversContact.value
                            .clear();
                        deliveryLocationController.receiversName.value.clear();
                        deliveryLocationController
                            .receiversSignatureImageByte.value = Uint8List(0);
                        deliveryLocationController.podImageByte.value =
                            Uint8List(0);
                        deliveryLocationController.receivingAmount.value.text =
                            deliveryLocationController
                                .validateTrackingNumberResponse
                                .value!
                                .data!
                                .codValue
                                .toString();
                        // deliveryLocationController.receiversName.value.text = deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color:
                            deliveryLocationController.receiversIndex.value == 3
                                ? Colors.deepOrange.shade500
                                : Colors.grey,
                        child: const Text("Neighbour",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          deliveryLocationController.receiversIndex.value = 4;

                          deliveryLocationController.receivingAmount.value
                              .clear();
                          deliveryLocationController.receiversName.value
                              .clear();
                          deliveryLocationController.receiversContact.value
                              .clear();
                          deliveryLocationController
                              .receiversSignatureImageByte.value = Uint8List(0);
                          deliveryLocationController.podImageByte.value =
                              Uint8List(0);
                          deliveryLocationController
                                  .receivingAmount.value.text =
                              deliveryLocationController
                                  .validateTrackingNumberResponse
                                  .value!
                                  .data!
                                  .codValue
                                  .toString();
                          // deliveryLocationController.receiversName.value.text = deliveryLocationController.validateTrackingNumberResponse.value!.data!.receiverName.toString();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color:
                            deliveryLocationController.receiversIndex.value == 4
                                ? Colors.deepOrangeAccent.shade400
                                : Colors.grey,
                        child: const Text("Guard",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    TextFormField(
                      // readOnly: true,
                      // enabled: false,
                      controller: TextEditingController(
                          text: loginController.loginResponse!.uSERID),
                      focusNode:
                          deliveryLocationController.employerIdFocusNode.value,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "Employee ID/Photo Id",
                          labelStyle: const TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller:
                          deliveryLocationController.receiversName.value,
                      focusNode: deliveryLocationController
                          .receiversNameFocusNode.value,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "Name",
                          labelStyle: const TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller:
                          deliveryLocationController.receiversContact.value,
                      focusNode: deliveryLocationController
                          .receiversContactFocusNode.value,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                      decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "Contact",
                          labelStyle: const TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 7),
                    TextFormField(
                      readOnly: false,
                      enabled: true,
                      controller:
                          deliveryLocationController.receivingAmount.value,
                      focusNode: deliveryLocationController
                          .receivingAmountFocusNode.value,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "Amount",
                          labelStyle: const TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black45)),
                      child: InkWell(
                        onTap: () {
                          Get.dialog(const SignatureCanvas());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 20),
                            deliveryLocationController
                                    .receiversSignatureImageByte.value!.isEmpty
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/add-image.png'),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey[200],
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: MemoryImage(
                                                    deliveryLocationController
                                                        .receiversSignatureImageByte
                                                        .value!),
                                                fit: BoxFit.fill))),
                                  ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Signature",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    callImageAdder(
                        deliveryLocationController.podImageByte,
                        deliveryLocationController.podSelectedImage,
                        "Upload POD"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          // width: MediaQuery.sizeOf(context).width,
                          // padding: const EdgeInsets.only(right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (deliveryLocationController
                                      .receiversName.value.text.isEmpty) {
                                    deliveryLocationController
                                        .receiversNameFocusNode.value
                                        .requestFocus();
                                    MyToast.myShowToast("Name can't be empty");
                                  } else if (deliveryLocationController
                                          .receiversContact
                                          .value
                                          .text
                                          .isEmpty ||
                                      deliveryLocationController
                                              .receiversContact.value.length !=
                                          10 ||
                                      deliveryLocationController
                                          .receiversContact.value.text
                                          .startsWith('0') ||
                                      !deliveryLocationController
                                          .receiversContact
                                          .value
                                          .text
                                          .isNumericOnly) {
                                    deliveryLocationController
                                        .receiversContactFocusNode.value
                                        .requestFocus();
                                    MyToast.myShowToast(
                                        "Please Provide valid Receiver's Contact Number");
                                  } else if (deliveryLocationController
                                      .receivingAmount.value.text.isEmpty) {
                                    deliveryLocationController
                                        .receivingAmountFocusNode.value
                                        .requestFocus();
                                    MyToast.myShowToast(
                                        "Receiving Amount can't be empty");
                                  } else if (deliveryLocationController
                                      .receiversSignatureImageByte
                                      .value!
                                      .isEmpty) {
                                    MyToast.myShowToast(
                                        "Please Provide Your Signature");
                                  } else {
                                    debugPrint("Receiver's Details Validated");
                                    await deliveryLocationController
                                        .callDeliverySubmitApi(context);
                                    // Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.40,
                                  padding: const EdgeInsets.only(
                                      left: 22, top: 10, bottom: 10, right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.deepOrange.shade500,
                                          Colors.deepOrange
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Save",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget callImageAdder(
      Rx<Uint8List?> ImageBytes, Rx<File?> SelectedImage, String title) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black45)),
      child: InkWell(
        onTap: () {
          PickImage().showImagePickerOption(ImageBytes, SelectedImage, context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            ImageBytes.value!.isEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/add-image.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: MemoryImage(ImageBytes.value!),
                                fit: BoxFit.fill))),
                  ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class SignatureCanvas extends StatefulWidget {
  const SignatureCanvas({super.key});

  @override
  State<SignatureCanvas> createState() => _SignatureCanvasState();
}

class _SignatureCanvasState extends State<SignatureCanvas> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.grey.shade300,
  );

  @override
  Widget build(BuildContext context) {
    var deliveryLocationController = Get.find<DeliveryLocationController>();
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      // backgroundColor: oran,
      title: SizedBox(
        height: 300, // Adjust height as needed
        width: MediaQuery.sizeOf(context).width, // Adjust width as needed
        child: Signature(
          controller: _controller,
          backgroundColor: Colors.orangeAccent,
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            onPressed: () async {
              if (_controller.isNotEmpty) {
                deliveryLocationController.receiversSignatureImageByte.value =
                    await _controller.toPngBytes();
                Uint8List? signatureBytes = await _controller.toPngBytes();
                if (signatureBytes != null) {
                  String base64Image = base64Encode(signatureBytes);
                  deliveryLocationController.receiversSignatureBase64.value =
                      base64Image;
                  debugPrint(
                      "BASE64 ${deliveryLocationController.receiversSignatureBase64.value}");
                }
                setState(() {});
                Navigator.of(context).pop();
              } else {
                MyToast.myShowToast("Signature is Empty");
              }
            },
            child: const Text("Save"),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {
              _controller.clear();
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }
}
