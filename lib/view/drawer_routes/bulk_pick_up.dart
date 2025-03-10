import 'package:abhilaya/controller/drawer_routes_controller/bulkpickup_controller.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../controller/auth_controller/login_controller.dart';
import '../../utils/barcode_scanner.dart';
import '../bottom_nav_bar/bottom_nav_bar.dart';

class BulkPickUp extends StatefulWidget {
  const BulkPickUp({super.key});

  @override
  State<BulkPickUp> createState() => _BulkPickUpState();
}

class _BulkPickUpState extends State<BulkPickUp> {
  var bulkPickUpController = Get.find<BulkPickUpController>();
  var loginController = Get.find<LoginController>();
  GeneralMethods generalMethods = GeneralMethods();
  final MobileScannerController cameraController = MobileScannerController();
  final List<dynamic> list = []; // Replace with your actual list
  final AudioPlayer player = AudioPlayer();
  var controller = Get.find<NavigationController>();

  call() async {
    setState(() {
      bulkPickUpController.isLoading = true;
    });
    bulkPickUpController.bulkPickupResponse.value = null;
    bulkPickUpController.scannedTrackingNumber.value = "";
    bulkPickUpController.isTrackingNumberValid.value = false;
    bulkPickUpController.trackingNumberController.value.clear();
    bulkPickUpController.scannedBulkProductsList.clear();
    bulkPickUpController.scannedProductTrackingNumberList.clear();

    setState(() {
      bulkPickUpController.isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    call();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        setState(() {
          controller.changeIndex(selectedIndex: controller.lastIndex!.value!);        });
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 50.h,
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Color(0xffFF9B55),
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
            backgroundColor: Colors.white,
            // automaticallyImplyLeading: false,
            leading: Center(
              child: GestureDetector(
                onTap: () {setState(() {
                  controller.changeIndex(selectedIndex: controller.lastIndex!.value!);                  });

                },
                child: Container(
                  margin: EdgeInsets.only(left: 5.w),
                  height: 30.h,
                  width: 30.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black.withOpacity(0.2))),
                  child: Center(
                    child: Image.asset(
                      'assets/images/arrow.png',
                      height: 13.h,
                      width: 10.w,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              "Bulk Pickup",
              style: TextStyle(
                  color: Color(0xffFF9B55),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: bulkPickUpController.isLoading
              ? SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange.shade500,
              ),
            ),
          )
              :loginController.loginResponse!.userTypeId == 2
              ? Center(
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                "You don't have access to this module as per your user role.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: Color(0xff7A7A7A)),
              ),
            ),
          )
              : bulkPickUpController.bulkPickupResponse == null
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
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF), // Background color
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                        ).add(EdgeInsets.only(top: 20.h)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                  MediaQuery.sizeOf(context).width *
                                      0.74,
                                  height: 54.h,
                                  child: TextFormField(
                                    // controller: TextEditingController(text: deliveryLocationController.scannedTrackingNumber.value),
                                    // readOnly: true,
                                    maxLines: 1,
                                    textCapitalization:
                                    TextCapitalization.characters,
                                    controller: bulkPickUpController
                                        .trackingNumberController.value,
                                    onFieldSubmitted: (value) async {
                                      setState(() {
                                        bulkPickUpController.isLoading =
                                        true;
                                      });
                                      await bulkPickUpController
                                          .validateTrackingNumber(
                                          value.trim());
                                      setState(() {
                                        bulkPickUpController.isLoading =
                                        false;
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
                                          color: Color(0xff7A7A7A),
                                          fontSize: 16.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                        ),
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
                                        labelText: "Tracking No/Barcode",
                                        suffixIcon: InkWell(
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MybatteryScanner(
                                                      onDetect: (String val) {
                                                        bulkPickUpController
                                                            .trackingNumberController
                                                            .value
                                                            .text = val;
                                                      },
                                                    ),
                                              ),
                                            );
                                            if (bulkPickUpController
                                                .trackingNumberController
                                                .value
                                                .text
                                                .isNotEmpty) {
                                              setState(() {
                                                bulkPickUpController
                                                    .isLoading = true;
                                              });
                                              await bulkPickUpController
                                                  .validateTrackingNumber(
                                                  bulkPickUpController
                                                      .trackingNumberController
                                                      .value
                                                      .text);
                                              setState(() {
                                                bulkPickUpController
                                                    .isLoading = false;
                                              });
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
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 54.h,
                                        // height: 40,
                                        width: 65.w,
                                        child: TextFormField(
                                          controller:
                                          TextEditingController(
                                            text: bulkPickUpController
                                                .scannedProductTrackingNumberList
                                                .isEmpty
                                                ? "Count" // Display "Count" when the list is empty
                                                : bulkPickUpController
                                                .scannedProductTrackingNumberList
                                                .length
                                                .toString(),
                                          ),
                                          readOnly: true,
                                          style: TextStyle(
                                            color: bulkPickUpController
                                                .scannedProductTrackingNumberList
                                                .isEmpty
                                                ? Color(0xff7A7A7A)
                                                : Colors.black,
                                            fontSize: 16.sp,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              color: Color(0xff7A7A7A),
                                              fontSize: 16.sp,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            fillColor: const Color(
                                                0xFFF9F9F9), // Background color
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide:
                                                const BorderSide(
                                                    color: Color(
                                                        0xffE7E5ED)),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    5)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                const BorderSide(
                                                    color: Color(
                                                        0xffE7E5ED)),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    5)),
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
                          ],
                        ),
                      )),

                  // table view of the list
                  const SizedBox(height: 15),

                  Obx(()=>Visibility(
                    visible:
                    bulkPickUpController.isTrackingNumberValid.value,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12.w)
                                .add(EdgeInsets.only(bottom: 16.h)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
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
                                          borderRadius: BorderRadius.only(
                                              topRight:
                                              Radius.circular(8)),
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
                                              "Destination",
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
                                Container(
                                  height: 400.h,
                                  child: ListView.builder(
                                    itemCount: bulkPickUpController
                                        .scannedBulkProductsList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                    const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Row(
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
                                                    bottom: index !=
                                                        ((bulkPickUpController
                                                            .scannedBulkProductsList
                                                            .length) -
                                                            1)
                                                        ? BorderSide(
                                                      color: Color(
                                                          0xffE7E5ED),
                                                      width: 1,
                                                    )
                                                        : BorderSide.none,
                                                    right: BorderSide(
                                                      color: Color(
                                                          0xffE7E5ED),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  borderRadius: index !=
                                                      ((bulkPickUpController
                                                          .scannedBulkProductsList
                                                          .length) -
                                                          1)
                                                      ? null
                                                      : BorderRadius.only(
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
                                                  Text(
                                                    bulkPickUpController
                                                        .scannedBulkProductsList[
                                                    index]
                                                        .trackingNumber
                                                        .toString(),
                                                    maxLines: null,
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color:
                                                        Colors.black,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                                    bottom: index !=
                                                        ((bulkPickUpController
                                                            .scannedBulkProductsList
                                                            .length) -
                                                            1)
                                                        ? BorderSide(
                                                      color: Color(
                                                          0xffE7E5ED),
                                                      width: 1,
                                                    )
                                                        : BorderSide.none,
                                                    right: BorderSide(
                                                      color: Color(
                                                          0xffE7E5ED),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  borderRadius: index !=
                                                      ((bulkPickUpController
                                                          .scannedBulkProductsList
                                                          .length) -
                                                          1)
                                                      ? null
                                                      : BorderRadius.only(
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
                                                  Text(
                                                    bulkPickUpController
                                                        .scannedBulkProductsList[
                                                    index]
                                                        .dropLocationName!,
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color:
                                                        Colors.black,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400),
                                                  ) // const SizedBox(height: 8.0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            /// on press event is left for the original api
                            onPressed: /* ()async {
                                        setState(() {
                                          bulkPickUpController.isLoading = true;
                                        });
                                        await bulkPickUpController
                                            .validateTrackingNumber(
                                                bulkPickUpController
                                                    .trackingNumberController.value
                                                    .toString()
                                                    .trim());
                                        setState(() {
                                          bulkPickUpController.isLoading = false;
                                        });
                                      },*/
                                () {
                                  bulkPickUpController.callBulkPickUpSubmitApi();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: Container(
                              width: w * 0.40,
                              height: h * 0.050,
                              alignment: Alignment.center,
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
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ))),
    );
  }
}
