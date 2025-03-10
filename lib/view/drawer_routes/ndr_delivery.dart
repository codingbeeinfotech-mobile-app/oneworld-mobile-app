import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/utils/image_picker.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:signature/signature.dart';

import '../../controller/auth_controller/login_controller.dart';
import '../../controller/drawer_routes_controller/ndr_delivery_controller.dart';
import '../../utils/barcode_scanner.dart';

class NDRDelivery extends StatefulWidget {
  const NDRDelivery({super.key});

  @override
  State<NDRDelivery> createState() => _NDRDeliveryState();
}

class _NDRDeliveryState extends State<NDRDelivery> {
  var ndrDeliveryController = Get.find<NDRDeliveryController>();
  var loginController = Get.find<LoginController>();
  GeneralMethods generalMethods = GeneralMethods();
  final MobileScannerController cameraController = MobileScannerController();
  final List<dynamic> list = []; // Replace with your actual list
  final AudioPlayer player = AudioPlayer();

  call() async {
    setState(() {
      ndrDeliveryController.isLoading = true;
    });
    ndrDeliveryController.ndrDeliveryResponse.value = null;
    ndrDeliveryController.scannedTrackingNumber.value = "";
    ndrDeliveryController.isTrackingNumberValid.value = false;
    ndrDeliveryController.trackingNumberController.value.clear();
    ndrDeliveryController.scannedBulkProductsList.clear();
    ndrDeliveryController.scannedProductTrackingNumberList.clear();
    ndrDeliveryController.callGetUserList();

    setState(() {
      ndrDeliveryController.isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    call();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleTextStyle: TextStyle(color: Color(0xFFFF9B55), fontSize: 20),

          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFFF9B55),
            ),
          ),
          centerTitle: true,
          title: Text(
            "NDR Delivery",
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         setState(() {});
          //       },
          //       icon: Icon(Icons.menu))
          // ],
        ),
        body: ndrDeliveryController.isLoading
            ? SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                ),
              )
            : ndrDeliveryController.ndrDeliveryResponse == null
                ? SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/courier.png"),
                        const SizedBox(height: 10),
                        const Text("Sorry No Delivery Options are available",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.74,
                              height: 54.h,
                              child: TextFormField(
                                // controller: TextEditingController(text: deliveryLocationController.scannedTrackingNumber.value),
                                // readOnly: true,
                                maxLines: 1,
                                textCapitalization:
                                    TextCapitalization.characters,
                                controller: ndrDeliveryController
                                    .trackingNumberController.value,
                                onFieldSubmitted: (value) async {
                                  setState(() {
                                    ndrDeliveryController.isLoading = true;
                                  });
                                  await ndrDeliveryController
                                      .validateTrackingNumber(value.trim());
                                  setState(() {
                                    ndrDeliveryController.isLoading = false;
                                  });
                                },
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                    fillColor: const Color(
                                        0xFFFFFFFF), // Background color
                                    filled: true,
                                    labelStyle: TextStyle(
                                      color: const Color(0xff7A7A7A),
                                      fontSize: 16.sp,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xffE7E5ED)),
                                        borderRadius: BorderRadius.circular(5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xffE7E5ED)),
                                        borderRadius: BorderRadius.circular(5)),
                                    labelText: "Tracking Number",
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MybatteryScanner(
                                              onDetect: (String val) {
                                                ndrDeliveryController
                                                    .trackingNumberController
                                                    .value
                                                    .text = val;
                                              },
                                            ),
                                          ),
                                        );
                                        if (ndrDeliveryController
                                            .trackingNumberController
                                            .value
                                            .text
                                            .isNotEmpty) {
                                          setState(() {
                                            ndrDeliveryController.isLoading =
                                                true;
                                          });
                                          await ndrDeliveryController
                                              .validateTrackingNumber(
                                                  ndrDeliveryController
                                                      .trackingNumberController
                                                      .value
                                                      .text);
                                          setState(() {
                                            ndrDeliveryController.isLoading =
                                                false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 4.h),
                                        child: Image.asset(
                                          "assets/images/barcode.png",
                                          height: 36.h,
                                          width: 36.w,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 54.h,
                                    // height: 40,
                                    width: 65.w,
                                    child: TextFormField(
                                      controller: TextEditingController(
                                          text: ndrDeliveryController
                                                  .scannedProductTrackingNumberList
                                                  .isEmpty
                                              ? "Count" // Display "Count" when the list is empty
                                              : ndrDeliveryController
                                                  .scannedProductTrackingNumberList
                                                  .length
                                                  .toString()),
                                      readOnly: true,
                                      style: TextStyle(
                                        color: ndrDeliveryController
                                                .scannedProductTrackingNumberList
                                                .isEmpty
                                            ? const Color(0xff7A7A7A)
                                            : Colors.black,
                                        fontSize: 16.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: const Color(0xff7A7A7A),
                                          fontSize: 16.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        fillColor: const Color(
                                            0xFFF9F9F9), // Background color
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffE7E5ED)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffE7E5ED)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        hintText: "Count",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Container(
                        //     width: MediaQuery.sizeOf(context).width,
                        //     child: Card(
                        //       elevation: 5,
                        //       child: Container(
                        //         padding: const EdgeInsets.only(
                        //             left: 10, right: 10, top: 10),
                        //         child: Column(
                        //           children: [
                        //             Row(
                        //               children: [
                        //                 SizedBox(
                        //                   width: MediaQuery.sizeOf(context)
                        //                           .width *
                        //                       0.60,
                        //                   // height: 40,
                        //                   child: TextFormField(
                        //                     // controller: TextEditingController(text: deliveryLocationController.scannedTrackingNumber.value),
                        //                     // readOnly: true,
                        //                     maxLines: 1,
                        //                     textCapitalization:
                        //                         TextCapitalization.characters,
                        //                     controller: ndrDeliveryController
                        //                         .trackingNumberController
                        //                         .value,
                        //                     onFieldSubmitted: (value) async {
                        //                       setState(() {
                        //                         ndrDeliveryController
                        //                             .isLoading = true;
                        //                       });
                        //                       await ndrDeliveryController
                        //                           .validateTrackingNumber(
                        //                               value.trim());
                        //                       setState(() {
                        //                         ndrDeliveryController
                        //                             .isLoading = false;
                        //                       });
                        //                     },
                        //                     style: const TextStyle(
                        //                         fontSize: 12,
                        //                         fontWeight: FontWeight.bold,
                        //                         overflow:
                        //                             TextOverflow.ellipsis),
                        //                     decoration: InputDecoration(
                        //                         enabledBorder: OutlineInputBorder(
                        //                             borderSide:
                        //                                 const BorderSide(
                        //                                     color: Colors
                        //                                         .black45),
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     5)),
                        //                         focusedBorder: OutlineInputBorder(
                        //                             borderSide:
                        //                                 const BorderSide(
                        //                                     color: Colors
                        //                                         .black45),
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     5)),
                        //                         labelText: "Tracking Number",
                        //                         suffixIcon: InkWell(
                        //                           onTap: () async {
                        //                             await Navigator.push(
                        //                               context,
                        //                               MaterialPageRoute(
                        //                                 builder: (context) =>
                        //                                     MybatteryScanner(
                        //                                   onDetect:
                        //                                       (String val) {
                        //                                     ndrDeliveryController
                        //                                         .trackingNumberController
                        //                                         .value
                        //                                         .text = val;
                        //                                   },
                        //                                 ),
                        //                               ),
                        //                             );
                        //                             if (ndrDeliveryController
                        //                                 .trackingNumberController
                        //                                 .value
                        //                                 .text
                        //                                 .isNotEmpty) {
                        //                               setState(() {
                        //                                 ndrDeliveryController
                        //                                     .isLoading = true;
                        //                               });
                        //                               await ndrDeliveryController
                        //                                   .validateTrackingNumber(
                        //                                       ndrDeliveryController
                        //                                           .trackingNumberController
                        //                                           .value
                        //                                           .text);
                        //                               setState(() {
                        //                                 ndrDeliveryController
                        //                                         .isLoading =
                        //                                     false;
                        //                               });
                        //                             }
                        //                           },
                        //                           child: const Icon(
                        //                               Icons.qr_code),
                        //                         )),
                        //                   ),
                        //                 ),
                        //                 Expanded(
                        //                   child: Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.end,
                        //                     children: [
                        //                       SizedBox(
                        //                         // height: 40,
                        //                         width:
                        //                             MediaQuery.sizeOf(context)
                        //                                     .width *
                        //                                 0.22,
                        //                         child: TextFormField(
                        //                           controller: TextEditingController(
                        //                               text: ndrDeliveryController
                        //                                   .scannedProductTrackingNumberList
                        //                                   .length
                        //                                   .toString()),
                        //                           readOnly: true,
                        //                           style: const TextStyle(
                        //                               fontSize: 12,
                        //                               fontWeight:
                        //                                   FontWeight.bold,
                        //                               overflow: TextOverflow
                        //                                   .ellipsis),
                        //                           decoration: InputDecoration(
                        //                             enabledBorder: OutlineInputBorder(
                        //                                 borderSide:
                        //                                     const BorderSide(
                        //                                         color: Colors
                        //                                             .black45),
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(5)),
                        //                             focusedBorder: OutlineInputBorder(
                        //                                 borderSide:
                        //                                     const BorderSide(
                        //                                         color: Colors
                        //                                             .black45),
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(5)),
                        //                             labelText: "Scan Count",
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 12),
                        //             /*
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     SizedBox(
                        //       height: 30,
                        //       width: MediaQuery.sizeOf(context).width/5,
                        //       child: TextFormField(
                        //         controller: TextEditingController(text: ndrDeliveryController.scannedBulkProductsList.length.toString()),
                        //         readOnly: true,
                        //         style:const TextStyle(
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.bold,
                        //             overflow: TextOverflow.ellipsis
                        //         ),
                        //         decoration: InputDecoration(
                        //           enabledBorder: OutlineInputBorder(
                        //               borderSide: const BorderSide(color: Colors.black45),
                        //               borderRadius: BorderRadius.circular(5)
                        //           ),
                        //           focusedBorder: OutlineInputBorder(
                        //               borderSide: const BorderSide(color: Colors.black45),
                        //               borderRadius: BorderRadius.circular(5)
                        //           ),
                        //           labelText: "Total Order",
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 30,
                        //       width: MediaQuery.sizeOf(context).width/4,
                        //       child: TextFormField(
                        //         controller: TextEditingController(text: ndrDeliveryController.scannedBulkProductsList.length.toString()),
                        //         readOnly: true,
                        //         style:const TextStyle(
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.bold,
                        //             overflow: TextOverflow.ellipsis
                        //         ),
                        //         decoration: InputDecoration(
                        //           enabledBorder: OutlineInputBorder(
                        //               borderSide: const BorderSide(color: Colors.black45),
                        //               borderRadius: BorderRadius.circular(5)
                        //           ),
                        //           focusedBorder: OutlineInputBorder(
                        //               borderSide: const BorderSide(color: Colors.black45),
                        //               borderRadius: BorderRadius.circular(5)
                        //           ),
                        //           labelText: "Scan Count",
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ), */
                        //           ],
                        //         ),
                        //       ),
                        //     )),
                        // const SizedBox(height: 15),
                        Visibility(
                            visible: ndrDeliveryController
                                .isTrackingNumberValid.value,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffE7E5ED)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
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
                                                    color: Color(0xffE7E5ED),
                                                    width: 0.5,
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8))),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Tracking Number",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8)),
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
                                                  "NDR Reason",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                      itemCount: ndrDeliveryController
                                          .scannedBulkProductsList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 36.h,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      right: BorderSide(
                                                        color:
                                                            Color(0xffE7E5ED),
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    borderRadius: index !=
                                                            ((ndrDeliveryController
                                                                    .scannedBulkProductsList
                                                                    .length) -
                                                                1)
                                                        ? null
                                                        : BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white)),
                                                      child: Text(
                                                        ndrDeliveryController
                                                            .scannedBulkProductsList[
                                                                index]
                                                            .trackingNumber
                                                            .toString(),
                                                        maxLines: null,
                                                        style: TextStyle(
                                                            fontSize: 13.sp,
                                                            color: Colors.black,
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
                                                        color:
                                                            Color(0xffE7E5ED),
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    borderRadius: index !=
                                                            ((ndrDeliveryController
                                                                    .scannedBulkProductsList
                                                                    .length) -
                                                                1)
                                                        ? null
                                                        : BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(

                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.w,
                                                              vertical: 2.h),padding: EdgeInsets.symmetric(
                                                        vertical: 3.h,
                                                        horizontal: 6.w),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFFFF9B55),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Center(
                                                        child: Text(
                                                          ndrDeliveryController
                                                              .scannedBulkProductsList[
                                                                  index]
                                                              .ndrReason
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ) // const SizedBox(height: 8.0),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(height: 12.h),
                        Visibility(
                          visible:
                              ndrDeliveryController.isTrackingNumberValid.value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                debugPrint("Submit Bulk Pickup");
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    ndrDeliveryController.selectedUser.value =
                                        'Select User';
                                    ndrDeliveryController
                                        .userSearchController.text = '';
                                    ndrDeliveryController
                                        .receiversSignatureBase64.value = "";
                                    ndrDeliveryController
                                        .receiversSignatureImageByte
                                        .value = Uint8List(0);
                                    ndrDeliveryController.podImageByte.value =
                                        Uint8List(0);
                                    return const ReceiverForm();
                                  },
                                );
                              },
                              child: Container(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.06,
                                width: 150.w,
                                padding: const EdgeInsets.only(
                                    left: 22, top: 10, bottom: 10, right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
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
                        )
                      ],
                    ),
                  ),
        // bottomNavigationBar: Visibility(
        //   visible: ndrDeliveryController.isTrackingNumberValid.value,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: InkWell(
        //       onTap: () async {
        //         debugPrint("Submit Bulk Pickup");
        //         showDialog(
        //           context: context,
        //           builder: (context) {
        //             ndrDeliveryController.selectedUser.value = 'Select User';
        //             ndrDeliveryController.userSearchController.text = '';
        //             ndrDeliveryController.receiversSignatureBase64.value = "";
        //             ndrDeliveryController.receiversSignatureImageByte.value =
        //                 Uint8List(0);
        //             ndrDeliveryController.podImageByte.value = Uint8List(0);
        //             return const ReceiverForm();
        //           },
        //         );
        //       },
        //       child: Container(
        //         height: MediaQuery.sizeOf(context).height * 0.06,
        //         width: MediaQuery.sizeOf(context).width,
        //         padding: const EdgeInsets.only(
        //             left: 22, top: 10, bottom: 10, right: 20),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //           gradient: LinearGradient(
        //               colors: [Colors.deepOrange.shade500, Colors.deepOrange],
        //               begin: Alignment.topLeft,
        //               end: Alignment.bottomCenter),
        //         ),
        //         child: const Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Text("Submit",
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 15,
        //                     fontWeight: FontWeight.bold)),
        //             SizedBox(width: 15),
        //             // Icon(Icons.arrow_forward,color: Colors.white,),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // )
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

class ReceiverForm extends StatefulWidget {
  const ReceiverForm({super.key});

  @override
  State<ReceiverForm> createState() => _ReceiverFormState();
}

class _ReceiverFormState extends State<ReceiverForm> {
  @override
  Widget build(BuildContext context) {
    var loginController = Get.find<LoginController>();
    var deliveryLocationController = Get.find<NDRDeliveryController>();
    return Obx(() {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15),
        title: const Text("Receiver's Details"),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    if (loginController.loginResponse!.userTypeId != 2)
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton2(
                          isExpanded: true,
                          underline: Container(),
                          onChanged: (value) async {
                            print("Selected value: $value");
                            setState(() {
                              deliveryLocationController.selectedUser.value =
                                  value;
                              deliveryLocationController
                                  .userSearchController.text = value;
                            });
                          },
                          value: deliveryLocationController.selectedUser.value,
                          items: [
                            // Default "Select User" dropdown item
                            DropdownMenuItem<String>(
                              value: 'Select User', // Optional default value
                              child: Text(
                                deliveryLocationController.selectedUser.value,
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Map through the userList to display users
                            ...deliveryLocationController.userList
                                .where((item) =>
                                    item.userName !=
                                    'Select User') // Filter out "Select User"
                                .toSet() // Remove duplicates if any
                                .toList()
                                .map((item) {
                              return DropdownMenuItem<String>(
                                value: "${item.userId}",
                                child: Text(
                                  "${item.name}:(${item.userName})",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                          dropdownSearchData: DropdownSearchData(
                            searchController:
                                deliveryLocationController.userSearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: deliveryLocationController
                                    .userSearchController,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  isDense: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black45),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.deepOrange.shade500,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onMenuStateChange: (isOpen) {
                            deliveryLocationController.userSearchController
                                .clear();
                            setState(() {});
                          },
                        ),
                      ),
                    // TextFormField(
                    //   // readOnly: true,
                    //   // enabled: false,
                    //   controller: TextEditingController(
                    //       text: loginController.loginResponse!.uSERID),
                    //   focusNode:
                    //       deliveryLocationController.employerIdFocusNode.value,
                    //   style: const TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.bold,
                    //       overflow: TextOverflow.ellipsis),
                    //   decoration: InputDecoration(
                    //       enabledBorder: OutlineInputBorder(
                    //           borderSide:
                    //               const BorderSide(color: Colors.black45),
                    //           borderRadius: BorderRadius.circular(5)),
                    //       disabledBorder: OutlineInputBorder(
                    //           borderSide:
                    //               const BorderSide(color: Colors.black45),
                    //           borderRadius: BorderRadius.circular(5)),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderSide:
                    //               const BorderSide(color: Colors.black45),
                    //           borderRadius: BorderRadius.circular(5)),
                    //       labelText: "Employee ID/Photo Id",
                    //       labelStyle: const TextStyle(color: Colors.black)),
                    // ),
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
                                      .receiversSignatureImageByte
                                      .value!
                                      .isEmpty) {
                                    MyToast.myShowToast(
                                        "Please Provide Your Signature");
                                  } else {
                                    debugPrint("Receiver's Details Validated");
                                    await deliveryLocationController
                                        .callNDRDeliverySubmitApi(context);
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
                                      // pending to put tost where we succefull to upload data
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
    var deliveryLocationController = Get.find<NDRDeliveryController>();
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

// class NDRDelivery extends StatefulWidget {
//   const NDRDelivery({super.key});
//
//   @override
//   State<NDRDelivery> createState() => _NDRDeliveryState();
// }
//
// class _NDRDeliveryState extends State<NDRDelivery> {
//   var ndrDeliveryController = Get.find<NDRDeliveryController>();
//   var loginController = Get.find<LoginController>();
//   GeneralMethods generalMethods = GeneralMethods();
//   final MobileScannerController cameraController = MobileScannerController();
//   final List<dynamic> list = []; // Replace with your actual list
//   final AudioPlayer player = AudioPlayer();
//
//   call() async {
//     setState(() {
//       ndrDeliveryController.isLoading = true;
//     });
//     ndrDeliveryController.ndrDeliveryResponse.value = null;
//     ndrDeliveryController.scannedTrackingNumber.value = "";
//     ndrDeliveryController.isTrackingNumberValid.value = false;
//     ndrDeliveryController.trackingNumberController.value.clear();
//     ndrDeliveryController.scannedBulkProductsList.clear();
//     ndrDeliveryController.scannedProductTrackingNumberList.clear();
//     ndrDeliveryController.callGetUserList();
//
//     setState(() {
//       ndrDeliveryController.isLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     call();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar( titleTextStyle:
//           TextStyle(color: Color(0xFFFF9B55), fontSize: 20),
//
//             backgroundColor: Colors.white,
//             leading: IconButton(
//               onPressed: () {
//                 Get.back();
//               },
//               icon:   Icon(Icons.arrow_back_ios,   color: Color(0xFFFF9B55),),
//             ),centerTitle: true,
//             title: Text("NDR Delivery",),
//             // actions: [
//             //   IconButton(
//             //       onPressed: () {
//             //         setState(() {});
//             //       },
//             //       icon: Icon(Icons.menu))
//             // ],
//           ),
//           body: ndrDeliveryController.isLoading
//               ? SizedBox(
//                   height: MediaQuery.sizeOf(context).height,
//                   width: MediaQuery.sizeOf(context).width,
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.deepOrange.shade500,
//                     ),
//                   ),
//                 )
//               : ndrDeliveryController.ndrDeliveryResponse == null
//                   ? SizedBox(
//                       height: MediaQuery.sizeOf(context).height,
//                       width: MediaQuery.sizeOf(context).width,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Image.asset("assets/images/courier.png"),
//                           const SizedBox(height: 10),
//                           const Text("Sorry No Delivery Options are available",
//                               style: TextStyle(color: Colors.black))
//                         ],
//                       ),
//                     )
//                   : Container(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 12.w, vertical: 16.h),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 20),
//                           Container(
//                               width: MediaQuery.sizeOf(context).width,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       SizedBox(
//                                         width:
//                                             MediaQuery.sizeOf(context).width *
//                                                 0.74,
//                                         height: 54.h,
//                                         child: TextFormField(
//                                           // controller: TextEditingController(text: deliveryLocationController.scannedTrackingNumber.value),
//                                           // readOnly: true,
//                                           maxLines: 1,
//                                           textCapitalization:
//                                               TextCapitalization.characters,
//                                           controller: ndrDeliveryController
//                                               .trackingNumberController.value,
//                                           onFieldSubmitted: (value) async {
//                                             setState(() {
//                                               ndrDeliveryController.isLoading =
//                                                   true;
//                                             });
//                                             await ndrDeliveryController
//                                                 .validateTrackingNumber(
//                                                     value.trim());
//                                             setState(() {
//                                               ndrDeliveryController.isLoading =
//                                                   false;
//                                             });
//                                           },
//                                           style: TextStyle(
//                                             fontSize: 16.sp,
//                                             overflow: TextOverflow.ellipsis,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                           decoration: InputDecoration(
//                                               fillColor: const Color(
//                                                   0xFFFFFFFF), // Background color
//                                               filled: true,
//                                               labelStyle: TextStyle(
//                                                 color: const Color(0xff7A7A7A),
//                                                 fontSize: 16.sp,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                               enabledBorder: OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: Color(0xffE7E5ED)),
//                                                   borderRadius:
//                                                       BorderRadius.circular(5)),
//                                               focusedBorder: OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: Color(0xffE7E5ED)),
//                                                   borderRadius:
//                                                       BorderRadius.circular(5)),
//                                               labelText: "Tracking Number",
//                                               suffixIcon: InkWell(
//                                                 onTap: () async {
//                                                   await Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           MybatteryScanner(
//                                                         onDetect: (String val) {
//                                                           ndrDeliveryController
//                                                               .trackingNumberController
//                                                               .value
//                                                               .text = val;
//                                                         },
//                                                       ),
//                                                     ),
//                                                   );
//                                                   if (ndrDeliveryController
//                                                       .trackingNumberController
//                                                       .value
//                                                       .text
//                                                       .isNotEmpty) {
//                                                     setState(() {
//                                                       ndrDeliveryController
//                                                           .isLoading = true;
//                                                     });
//                                                     await ndrDeliveryController
//                                                         .validateTrackingNumber(
//                                                             ndrDeliveryController
//                                                                 .trackingNumberController
//                                                                 .value
//                                                                 .text);
//                                                     setState(() {
//                                                       ndrDeliveryController
//                                                           .isLoading = false;
//                                                     });
//                                                   }
//                                                 },
//                                                 child: Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       horizontal: 8.w,
//                                                       vertical: 4.h),
//                                                   child: Image.asset(
//                                                     "assets/images/barcode.png",
//                                                     height: 36.h,
//                                                     width: 36.w,
//                                                   ),
//                                                 ),
//                                               )),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             SizedBox(
//                                               height: 54.h,
//                                               // height: 40,
//                                               width: 65.w,
//                                               child: TextFormField(
//                                                 controller:
//                                                     TextEditingController(
//                                                         text: ndrDeliveryController
//                                                                 .scannedProductTrackingNumberList
//                                                                 .isEmpty
//                                                             ? "Count" // Display "Count" when the list is empty
//                                                             : ndrDeliveryController
//                                                                 .scannedProductTrackingNumberList
//                                                                 .length
//                                                                 .toString()),
//                                                 readOnly: true,
//                                                 style: TextStyle(
//                                                   color: ndrDeliveryController
//                                                           .scannedProductTrackingNumberList
//                                                           .isEmpty
//                                                       ? const Color(0xff7A7A7A)
//                                                       : Colors.black,
//                                                   fontSize: 16.sp,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   hintStyle: TextStyle(
//                                                     color:
//                                                         const Color(0xff7A7A7A),
//                                                     fontSize: 16.sp,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     fontWeight: FontWeight.w400,
//                                                   ),
//                                                   fillColor: const Color(
//                                                       0xFFF9F9F9), // Background color
//                                                   filled: true,
//                                                   enabledBorder: OutlineInputBorder(
//                                                       borderSide:
//                                                           const BorderSide(
//                                                               color: Color(
//                                                                   0xffE7E5ED)),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5)),
//                                                   focusedBorder: OutlineInputBorder(
//                                                       borderSide:
//                                                           const BorderSide(
//                                                               color: Color(
//                                                                   0xffE7E5ED)),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5)),
//                                                   hintText: "Count",
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),
//                                   /*
//                                                       Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                         children: [
//                                                           SizedBox(
//                                                             height: 30,
//                                                             width: MediaQuery.sizeOf(context).width/5,
//                                                             child: TextFormField(
//                               controller: TextEditingController(text: ndrDeliveryController.scannedBulkProductsList.length.toString()),
//                               readOnly: true,
//                               style:const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   overflow: TextOverflow.ellipsis
//                               ),
//                               decoration: InputDecoration(
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.black45),
//                                     borderRadius: BorderRadius.circular(5)
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.black45),
//                                     borderRadius: BorderRadius.circular(5)
//                                 ),
//                                 labelText: "Total Order",
//                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 30,
//                                                             width: MediaQuery.sizeOf(context).width/4,
//                                                             child: TextFormField(
//                               controller: TextEditingController(text: ndrDeliveryController.scannedBulkProductsList.length.toString()),
//                               readOnly: true,
//                               style:const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   overflow: TextOverflow.ellipsis
//                               ),
//                               decoration: InputDecoration(
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.black45),
//                                     borderRadius: BorderRadius.circular(5)
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(color: Colors.black45),
//                                     borderRadius: BorderRadius.circular(5)
//                                 ),
//                                 labelText: "Scan Count",
//                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ), */
//                                 ],
//                               )),
//                           Visibility(
//                               visible: ndrDeliveryController
//                                   .scannedBulkProductsList.isNotEmpty ,child: Container(height: 54.h,width: 336.w,decoration: BoxDecoration(
//                               color: Colors.white,
//
//                               border: Border.all(
//                                   color: const Color(0xffE7E5ED)),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                               padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 8.w),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     ndrDeliveryController
//                                         .scannedBulkProductsList[0].ndrReason.toString(),
//                                     maxLines: null,
//                                     style:   TextStyle(
//                                         fontSize: 13.sp,
//                                         color: Colors
//                                             .black,
//                                         fontWeight:
//                                         FontWeight
//                                             .w400),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           Visibility(
//                               visible: ndrDeliveryController
//                                   .isTrackingNumberValid.value,
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.vertical,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border.all(
//                                         color: const Color(0xffE7E5ED)),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               height: 36.h,
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: 8.w,
//                                               ),
//                                               decoration: const BoxDecoration(
//                                                   color: Color(0xFFF9F9F9),
//                                                   border: Border(
//                                                     right: BorderSide(
//                                                       color:
//                                                           Color(0xffE7E5ED),
//                                                       width: 0.5,
//                                                     ),
//                                                   ),
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                   8))),
//                                               child: const Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "Tracking Number",
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               height: 36.h,
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: 8.w,
//                                               ),
//                                               decoration: const BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.only(
//                                                         topRight:
//                                                             Radius.circular(
//                                                                 8)),
//                                                 border: Border(
//                                                   left: BorderSide(
//                                                     //                   <--- right side
//                                                     color: Color(0xffE7E5ED),
//                                                     width: 0.5,
//                                                   ),
//                                                 ),
//                                                 color: Color(0xFFF9F9F9),
//                                               ),
//                                               child: const Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     "NDR Reason",
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       ListView.builder(
//                                         itemCount: ndrDeliveryController
//                                             .scannedBulkProductsList.length,
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.vertical,
//                                         physics:
//                                             const ClampingScrollPhysics(),
//                                         itemBuilder: (context, index) {
//                                           return Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceBetween,
//                                             // crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   height: 36.h,
//                                                   padding:
//                                                       EdgeInsets.symmetric(
//                                                     horizontal: 8.w,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       border: Border(
//                                                         right: BorderSide(
//                                                           color: Color(
//                                                               0xffE7E5ED),
//                                                           width: 0.5,
//                                                         ),
//                                                       ),
//                                                       borderRadius: index !=
//                                                               ((ndrDeliveryController
//                                                                       .scannedBulkProductsList
//                                                                       .length) -
//                                                                   1)
//                                                           ? null
//                                                           : BorderRadius.only(
//                                                               bottomLeft: Radius
//                                                                   .circular(
//                                                                       8))),
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Container(
//                                                         decoration: BoxDecoration(
//                                                             border: Border.all(
//                                                                 color: Colors
//                                                                     .white)),
//                                                         child: Text(
//                                                           ndrDeliveryController
//                                                               .scannedBulkProductsList[
//                                                                   index]
//                                                               .trackingNumber
//                                                               .toString(),
//                                                           maxLines: null,
//                                                           style:   TextStyle(
//                                                               fontSize: 13.sp,
//                                                               color: Colors
//                                                                   .black,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   height: 36.h,
//
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       border: Border(
//                                                         right: BorderSide(
//                                                           color: Color(
//                                                               0xffE7E5ED),
//                                                           width: 0.5,
//                                                         ),
//                                                       ),
//                                                       borderRadius: index !=
//                                                               ((ndrDeliveryController
//                                                                       .scannedBulkProductsList
//                                                                       .length) -
//                                                                   1)
//                                                           ? null
//                                                           : BorderRadius.only(
//                                                               bottomRight: Radius
//                                                                   .circular(
//                                                                       8))),
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Container(
//                                                         height: 30.h,
//
//                                                         margin: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
//                                                         decoration: BoxDecoration(
//                                                             color: Color(
//                                                                 0xFFFF9B55),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         8)),
//                                                         child: Center(
//                                                           child: Text(
//                                                             ndrDeliveryController
//                                                                 .scannedBulkProductsList[
//                                                                     index]
//                                                                 .ndrReason
//                                                                 .toString(),
//                                                             style: TextStyle(
//                                                                 fontSize: 12.sp,
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400),
//                                                           ),
//                                                         ),
//                                                       ) // const SizedBox(height: 8.0),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )),
//                             SizedBox(height: 12.h),
//
//                           Visibility(
//                             visible: ndrDeliveryController.isTrackingNumberValid.value,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: InkWell(
//                                 onTap: () async {
//                                   debugPrint("Submit Bulk Pickup");
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) {
//                                       ndrDeliveryController.selectedUser.value = 'Select User';
//                                       ndrDeliveryController.userSearchController.text = '';
//                                       ndrDeliveryController.receiversSignatureBase64.value = "";
//                                       ndrDeliveryController.receiversSignatureImageByte.value =
//                                           Uint8List(0);
//                                       ndrDeliveryController.podImageByte.value = Uint8List(0);
//                                       return const ReceiverForm();
//                                     },
//                                   );
//                                 },
//                                 child: Container(
//                                   height: MediaQuery.sizeOf(context).height * 0.06,
//                                   width: 150.w,
//                                   padding: const EdgeInsets.only(
//                                       left: 22, top: 10, bottom: 10, right: 20),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     gradient: const LinearGradient(
//                                       colors: [
//                                         Color(0xFFFF9B55),
//                                         Color(0xFFE3622D)
//                                       ],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                     ),
//                                   ),
//                                   child: const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Text("Submit",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold)),
//
//                                       // Icon(Icons.arrow_forward,color: Colors.white,),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//         );
//     });
//   }
//
//   Widget callImageAdder(
//       Rx<Uint8List?> ImageBytes, Rx<File?> SelectedImage, String title) {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black45)),
//       child: InkWell(
//         onTap: () {
//           PickImage().showImagePickerOption(ImageBytes, SelectedImage, context);
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(width: 20),
//             ImageBytes.value!.isEmpty
//                 ? CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.rectangle,
//                         image: DecorationImage(
//                             image: AssetImage('assets/images/add-image.png'),
//                             fit: BoxFit.cover),
//                       ),
//                     ),
//                   )
//                 : CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.grey[200],
//                     child: Container(
//                         decoration: BoxDecoration(
//                             shape: BoxShape.rectangle,
//                             image: DecorationImage(
//                                 image: MemoryImage(ImageBytes.value!),
//                                 fit: BoxFit.fill))),
//                   ),
//             Expanded(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Flexible(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: title,
//                           style: const TextStyle(
//                               color: Colors.black54,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               overflow: TextOverflow.ellipsis),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }
