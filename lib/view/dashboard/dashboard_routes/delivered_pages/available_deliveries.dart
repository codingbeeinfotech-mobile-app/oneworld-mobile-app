import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/dashboard_controller.dart';
import 'package:abhilaya/controller/dashboard_routes_controller/delivery_location_controller.dart';
import 'package:abhilaya/model/response_model/delivery_list_response.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/delivered_pages/submit_delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/barcode_scanner.dart';

class DeliveryList extends StatefulWidget {
  const DeliveryList({Key? key}) : super(key: key);

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  var deliveryLocationController = Get.find<DeliveryLocationController>();
  var dashboardController = Get.find<DashboardController>();
  TextEditingController searchController = TextEditingController();
  List<Data> filterList = <Data>[];
  var loginController = Get.find<LoginController>();
  GeneralMethods generalMethods = GeneralMethods();
  var controller = Get.find<NavigationController>();

  call() async {
    searchController.clear();
    deliveryLocationController.trackingDetailsList.clear();
    filterList.clear();
    deliveryLocationController.transactionId.value = "";
    deliveryLocationController.doesDataExist.value = true;
    await deliveryLocationController.getDeliveryLocationList();
    setState(() {
      filterList = deliveryLocationController.trackingDetailsList;
    });
    deliveryLocationController.isOtpDialogBoxOpened.value = false;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () async {
      await call();
    });
    // call();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  void filterSearchResults(String query) {
    List<Data> dummySearchList =
        List<Data>.from(deliveryLocationController.trackingDetailsList);
    if (query.isNotEmpty) {
      List<Data> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.trackingNumber!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
          deliveryLocationController.doesDataExist.value = true;
        } else {
          if (dummyListData.isEmpty) {
            debugPrint("data empty");
            deliveryLocationController.doesDataExist.value = false;
          }
        }
      }
      setState(() {
        filterList = dummyListData;
      });
      return;
    } else {
      setState(() {
        filterList =
            List<Data>.from(deliveryLocationController.trackingDetailsList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        setState(() {
          controller.changeIndex(selectedIndex: controller.lastIndex!.value!);


        });
      },
      child: Obx(() {
        return Scaffold(
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
                onTap: () {
                  setState(() {
                    controller.changeIndex(selectedIndex: controller.lastIndex!.value!);
                  });
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
              "Delivery",
              style: TextStyle(
                  color: Color(0xffFF9B55),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: deliveryLocationController.deliveryListResponse.value == null
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepOrange.shade500),
                  ),
                )
              : loginController.loginResponse!.userTypeId == 2
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
              :deliveryLocationController
                          .deliveryListResponse.value!.result!.flag ==
                      false
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
                  : filterList.isEmpty &&
                          deliveryLocationController.doesDataExist.value
                      ? SizedBox(
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: Colors.deepOrange.shade500),
                          ),
                        )
                      : filterList.isEmpty &&
                              !deliveryLocationController.doesDataExist.value
                          ? SizedBox(
                              height: MediaQuery.sizeOf(context).height,
                              width: MediaQuery.sizeOf(context).width,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w)
                                            .add(EdgeInsets.only(top: 20.h)),
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(minHeight: 54.h),
                                      child: TextFormField(
                                        maxLines: 1,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        controller: searchController,
                                        focusNode: deliveryLocationController
                                            .searchTrackingNumberFocusNode.value,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          focusColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xffE7E5ED)),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xffE7E5ED)),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          label: Text.rich(
                                            TextSpan(
                                              children: <InlineSpan>[
                                                WidgetSpan(
                                                  child: Text(
                                                      'Search Tracking No',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: deliveryLocationController
                                                                  .searchTrackingNumberFocusNode
                                                                  .value
                                                                  .hasFocus
                                                              ? Colors.black45
                                                              : Colors.black45)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          labelStyle: TextStyle(
                                            color: Color(0xff7A7A7A),
                                            fontSize: 16.sp,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          suffixIcon: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 4.h),
                                            child: Image.asset(
                                              "assets/images/barcode.png",
                                              height: 36.h,
                                              width: 36.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: MediaQuery.sizeOf(context).height *
                                          0.20),
                                  Image.asset(
                                    "assets/images/nodata.png",
                                    height: 100,
                                    width: 200,
                                    color: Colors.deepOrange.shade500,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "No such Data Exists",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w)
                                            .add(EdgeInsets.only(top: 20.h)),
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(minHeight: 54.h),
                                      child: TextFormField(
                                        controller: searchController,
                                        focusNode: deliveryLocationController
                                            .searchTrackingNumberFocusNode.value,
                                        maxLines: 1,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            focusColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xffE7E5ED)),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            labelStyle: TextStyle(
                                              color: Color(0xff7A7A7A),
                                              fontSize: 16.sp,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xffE7E5ED)),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            label: Text.rich(
                                              TextSpan(
                                                children: <InlineSpan>[
                                                  WidgetSpan(
                                                    child: Text(
                                                        'Search Tracking No',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16.sp,
                                                            color: Color(
                                                                0xff7A7A7A))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            suffixIcon: GestureDetector(
                                              onTap: () async {
                                                searchController.clear();
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MybatteryScanner(
                                                      onDetect: (String val) {
                                                        if (val.isNotEmpty) {
                                                          searchController.text =
                                                              val;
                                                        }
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                );
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
                                  ),
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12.w)
                                              .add(EdgeInsets.only(top: 20.h)),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: filterList.length,
                                        itemBuilder: (context, index) {
                                          var deliveryData = filterList[index];

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 90.h,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5.h),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      left: 0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12.0),
                                                          border: Border.all(
                                                            color:
                                                                Color(0xFFE7E6E4),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        height: 84.h,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                8.w),
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/images/delivery_location.png",
                                                                      height:
                                                                          28.h,
                                                                      width: 28.w,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      // color: Color(MyColor.petrolBlue),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      deliveryData
                                                                          .transporterLocation
                                                                          .toString(),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .visible,
                                                                      style: TextStyle(
                                                                          fontSize: 12
                                                                              .sp,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                if (loginController
                                                                        .connectionStatus
                                                                        .value ==
                                                                    "ConnectivityResult.none") {
                                                                  await generalMethods
                                                                      .initConnectivity();
                                                                } else {
                                                                  setState(() {
                                                                    deliveryLocationController
                                                                        .selectedDeliveryLocation
                                                                        .value = filterList[
                                                                            index]
                                                                        .transporterLocation!;
                                                                    deliveryLocationController
                                                                        .trackingNumberController
                                                                        .value
                                                                        .clear();
                                                                    deliveryLocationController
                                                                        .amountController
                                                                        .value
                                                                        .clear();
                                                                    deliveryLocationController
                                                                        .isTrackingNumberValid
                                                                        .value = false;

                                                                    if (filterList[index]
                                                                                .orderType
                                                                                .toString()
                                                                                .toLowerCase() ==
                                                                            "ppd" ||
                                                                        filterList[index]
                                                                                .orderType
                                                                                .toString()
                                                                                .trim()
                                                                                .toLowerCase() ==
                                                                            "prepaid") {
                                                                      deliveryLocationController
                                                                          .isOrderCOD
                                                                          .value = false;
                                                                    } else {
                                                                      deliveryLocationController
                                                                          .isOrderCOD
                                                                          .value = true;
                                                                    }
                                                                  });
                                                                  Get.to(
                                                                      const SubmitDelivery());
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 84.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xffFF9B55),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .horizontal(
                                                                    right: Radius
                                                                        .circular(
                                                                            10.sp),
                                                                  ),
                                                                ),
                                                                width: 52.w,
                                                                child: const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_sharp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -2.h,
                                                      left: 8.w,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await Clipboard.setData(
                                                              ClipboardData(
                                                                  text: deliveryData
                                                                      .trackingNumber
                                                                      .toString()));
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12.w),
                                                          color: Colors.white,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: Text(
                                                              deliveryData
                                                                  .trackingNumber
                                                                  .toString(),
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  fontSize: 16.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
          // bottomNavigationBar: BottomNavBar(),
        );
      }),
    );
  }
}
