import 'package:abhilaya/controller/drawer_routes_controller/nprShipment_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller/login_controller.dart';
import '../../utils/general/alert_boxes.dart';
import '../../utils/general/general_methods.dart';
import '../bottom_nav_bar/bottom_nav_bar.dart';

class NprShipments extends StatefulWidget {
  const NprShipments({Key? key}) : super(key: key);

  @override
  State<NprShipments> createState() => _NprShipmentsState();
}

class _NprShipmentsState extends State<NprShipments> {
  var loginController = Get.find<LoginController>();
  var nprController = Get.find<NprShipmentsController>();
  GeneralMethods generalMethods = GeneralMethods();
  var vendorSearchController = TextEditingController();
  var pickupLocationSearchController = TextEditingController();
  var reasonSearchController = TextEditingController();
  var controller = Get.find<NavigationController>();

  @override
  void initState() {
    super.initState();

    call();
  }

  call() async {
    nprController.clearValues();
    setState(() {
      nprController.isLoading = true;
    });

    await nprController.callVendorListApi();
    await nprController.callGetNprReasonApi();
    setState(() {
      nprController.isLoading = false;
    });
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
              onTap: () {
                setState(() {
                  controller.changeIndex(
                      selectedIndex: controller.lastIndex!.value!);
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
            "NPR Shipments",
            style: TextStyle(
                color: Color(0xffFF9B55),
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: nprController.isLoading
            ? SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                ),
              )
            : loginController.loginResponse!.userTypeId == 2
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
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
                : nprController.vendorListResponse.value == null
                    ? SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/courier.png"),
                            const SizedBox(height: 10),
                            const Text("Sorry Shipment Options are available",
                                style: TextStyle(color: Colors.black))
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffE7E5ED)),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton2(
                                  isExpanded: true,
                                  underline: Container(),
                                  onChanged: (value) async {
                                    nprController.selectedVendor.value = value!;
                                    if (value != "Select Vendor") {
                                      Dialogs.lottieLoading(context,
                                          "assets/lottiee/abhi_loading.json");
                                      var temp = nprController.allVendorList
                                          .firstWhere((element) =>
                                              element.vendorName == value);
                                      nprController.selectedVendorId.value =
                                          temp.vendorId;
                                      nprController.selectedPickupLocation
                                          .value = "Pickup Location";
                                      nprController.selectedNprReason.value =
                                          "Select NPR";
                                      setState(() {});
                                      await nprController
                                          .callParticularVendorDataApi();
                                      setState(() {});
                                      nprController.allowVisibility.value =
                                          false;
                                      nprController
                                          .pickupLocationQuantity.value = 0;
                                      setState(() {});
                                      Navigator.pop(context);
                                      setState(() {});
                                    }
                                  },
                                  value: nprController.selectedVendor.value,
                                  items: nprController.allVendorList
                                      .toSet()
                                      .toList()
                                      .map((item) {
                                    return DropdownMenuItem(
                                        value: item.vendorName,
                                        child: Text(item.vendorName,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)));
                                  }).toList(),
                                  dropdownSearchData: DropdownSearchData(
                                      searchController: vendorSearchController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            // border: Border.all(color: Colors.deepOrange.shade500),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextFormField(
                                          controller: vendorSearchController,
                                          decoration: InputDecoration(
                                              hintText: 'Search',
                                              isDense: true,
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
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffE7E5ED)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              focusedErrorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffE7E5ED)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              border:
                                                  OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                                              suffixIcon: Icon(
                                                Icons.search,
                                                color:
                                                    Colors.deepOrange.shade500,
                                                size: 30,
                                              )),
                                        ),
                                      )),
                                  onMenuStateChange: ((isOpen) {
                                    vendorSearchController.clear();
                                    setState(() {});
                                  }),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffE7E5ED)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton2(
                                  isExpanded: true,
                                  underline: Container(),
                                  onChanged: (value) async {
                                    nprController.selectedPickupLocation.value =
                                        value!;
                                    if (value != "Pickup Location") {
                                      nprController.fetchPickupLocation();
                                      nprController.selectedNprReason.value =
                                          "Select NPR";
                                    }
                                  },
                                  value: nprController
                                      .selectedPickupLocation.value,
                                  items: nprController.pickupLocations
                                      .toSet()
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    String item = entry.value;

                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 3,
                                      ),
                                    );
                                  }).toList(),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController:
                                        pickupLocationSearchController,
                                    searchInnerWidgetHeight: 200,
                                    searchInnerWidget: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        controller:
                                            pickupLocationSearchController,
                                        decoration: InputDecoration(
                                          hintText: 'Search',
                                          isDense: true,
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
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xffE7E5ED)),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffE7E5ED)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xffE7E5ED)),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          suffixIcon: Icon(
                                            Icons.search,
                                            color: Colors.deepOrange.shade500,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 500,
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 15, bottom: 15),
                                    elevation: 4,
                                    direction: DropdownDirection.textDirection,
                                  ),
                                  onMenuStateChange: ((isOpen) {
                                    pickupLocationSearchController.clear();
                                    setState(() {});
                                  }),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Visibility(
                                visible: nprController.allowVisibility.value,
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
                                                    "Not Picked Shipment",
                                                    style: TextStyle(
                                                      color: Colors.black,
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
                                                    "NPR",
                                                    style: TextStyle(
                                                      color: Colors.black,
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
                                            MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 56.h,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: Color(0xffE7E5ED),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${nprController.pickupLocationQuantity.value} shipments",
                                                    maxLines: null,
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color:
                                                            Color(0xff7A7A7A),
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 56.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                    left: BorderSide(
                                                      color: Color(0xffE7E5ED),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.w),
                                                    width: 143.w,

                                                    // width: MediaQuery.sizeOf(context).width*0.45,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffE7E5ED)),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: DropdownButton2(
                                                      isExpanded: true,
                                                      underline: Container(),
                                                      onChanged: (value) async {
                                                        nprController
                                                            .selectedNprReason
                                                            .value = value!;
                                                        if (value !=
                                                            "Select Vendor") {
                                                          var temp = nprController
                                                              .nprReasonList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .codeDescription ==
                                                                      value);
                                                          nprController
                                                              .selectedNprReasonId
                                                              .value = temp.codeId;
                                                          debugPrint(
                                                              temp.toString());
                                                        }
                                                      },
                                                      value: nprController
                                                          .selectedNprReason
                                                          .value,
                                                      items: nprController
                                                          .nprReasonList
                                                          .toSet()
                                                          .toList()
                                                          .map((item) {
                                                        return DropdownMenuItem(
                                                            value: item
                                                                .codeDescription,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 4),
                                                              child: Text(
                                                                  item
                                                                      .codeDescription,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color: Color(
                                                                          0xff7A7A7A),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ));
                                                      }).toList(),
                                                      dropdownStyleData:
                                                          DropdownStyleData(
                                                              maxHeight: 400,
                                                              width: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .width *
                                                                  0.50),
                                                      dropdownSearchData:
                                                          DropdownSearchData(
                                                              searchController:
                                                                  reasonSearchController,
                                                              searchInnerWidgetHeight:
                                                                  50,
                                                              searchInnerWidget:
                                                                  Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        // border: Border.all(color: Colors.deepOrange.shade500),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      reasonSearchController,
                                                                  decoration: InputDecoration(
                                                                      disabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                                                                      errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                                                                      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                                                                      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                                                                      focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                                                                      border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                                                                      hintText: 'Search',
                                                                      isDense: true,
                                                                      suffixIcon: Icon(
                                                                        Icons
                                                                            .search,
                                                                        color: Colors
                                                                            .deepOrange
                                                                            .shade500,
                                                                        size:
                                                                            30,
                                                                      )),
                                                                ),
                                                              )),
                                                      onMenuStateChange:
                                                          ((isOpen) {
                                                        reasonSearchController
                                                            .clear();
                                                        setState(() {});
                                                      }),
                                                    ),
                                                  ), // const SizedBox(height: 8.0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Visibility(
                                  visible:
                                      nprController.selectedNprReason.value !=
                                          "Select NPR",
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {});
                                          debugPrint("Submit Npr Shipments");

                                          if (loginController
                                                  .connectionStatus.value ==
                                              "ConnectivityResult.none") {
                                            await generalMethods
                                                .initConnectivity();
                                          } else {
                                            setState(() {});
                                            await nprController
                                                .callSubmitNprApi(context);
                                            setState(() {});
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.06,
                                          width: 150.w,
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
                                                  Color(0xFFFF9B55),
                                                  Color(0xFFE3622D)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomCenter),
                                          ),
                                          child: Center(
                                            child: Text("Submit",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              // Visibility(
                              //   visible:true,
                              //   // visible: nprController.allowVisibility.value,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       SizedBox(
                              //           width:
                              //           MediaQuery.sizeOf(context).width * 0.40,
                              //           child: Text(
                              //             "${nprController.pickupLocationQuantity.value} shipments",
                              //             style: const TextStyle(
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 14),
                              //           )),
                              //       SizedBox(
                              //         width:
                              //         MediaQuery.sizeOf(context).width * 0.50,
                              //         child: Container(
                              //           // width: MediaQuery.sizeOf(context).width*0.45,
                              //           decoration: BoxDecoration(
                              //               border: Border.all(color: Colors.black),
                              //               color: Colors.white,
                              //               borderRadius:
                              //               BorderRadius.circular(10)),
                              //           child: DropdownButton2(
                              //             isExpanded: true,
                              //             underline: Container(),
                              //             onChanged: (value) async {
                              //               nprController.selectedNprReason.value =
                              //               value!;
                              //               if (value != "Select Vendor") {
                              //                 var temp = nprController.nprReasonList
                              //                     .firstWhere((element) =>
                              //                 element.codeDescription ==
                              //                     value);
                              //                 nprController.selectedNprReasonId
                              //                     .value = temp.codeId;
                              //                 debugPrint(temp.toString());
                              //               }
                              //             },
                              //             value:
                              //             nprController.selectedNprReason.value,
                              //             items: nprController.nprReasonList
                              //                 .toSet()
                              //                 .toList()
                              //                 .map((item) {
                              //               return DropdownMenuItem(
                              //                   value: item.codeDescription,
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.only(
                              //                         left: 4),
                              //                     child: Text(item.codeDescription,
                              //                         style: const TextStyle(
                              //                             fontSize: 13,
                              //                             overflow:
                              //                             TextOverflow.visible,
                              //                             color: Colors.black,
                              //                             fontWeight:
                              //                             FontWeight.w500)),
                              //                   ));
                              //             }).toList(),
                              //             dropdownStyleData: DropdownStyleData(
                              //                 maxHeight: 400,
                              //                 width:
                              //                 MediaQuery.sizeOf(context).width *
                              //                     0.50),
                              //             dropdownSearchData: DropdownSearchData(
                              //                 searchController:
                              //                 reasonSearchController,
                              //                 searchInnerWidgetHeight: 50,
                              //                 searchInnerWidget: Container(
                              //                   padding: const EdgeInsets.all(10),
                              //                   decoration: BoxDecoration(
                              //                     // border: Border.all(color: Colors.deepOrange.shade500),
                              //                       borderRadius:
                              //                       BorderRadius.circular(15)),
                              //                   child: TextFormField(
                              //                     controller:
                              //                     reasonSearchController,
                              //                     decoration: InputDecoration(
                              //                         disabledBorder: OutlineInputBorder(
                              //                             borderSide: const BorderSide(
                              //                                 color: Color(
                              //                                     0xffE7E5ED)),
                              //                             borderRadius: BorderRadius.circular(
                              //                                 5)),
                              //                         errorBorder: OutlineInputBorder(
                              //                             borderSide: const BorderSide(
                              //                                 color: Color(
                              //                                     0xffE7E5ED)),
                              //                             borderRadius:
                              //                             BorderRadius.circular(
                              //                                 5)),
                              //                         enabledBorder: OutlineInputBorder(
                              //                             borderSide: const BorderSide(
                              //                                 color: Color(
                              //                                     0xffE7E5ED)),
                              //                             borderRadius:
                              //                             BorderRadius.circular(
                              //                                 5)),
                              //                         focusedBorder: OutlineInputBorder(
                              //                             borderSide: const BorderSide(
                              //                                 color: Color(0xffE7E5ED)),
                              //                             borderRadius: BorderRadius.circular(5)),
                              //                         focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                              //                         border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE7E5ED)), borderRadius: BorderRadius.circular(5)),
                              //                         hintText: 'Search',
                              //                         isDense: true,
                              //                         suffixIcon: Icon(
                              //                           Icons.search,
                              //                           color: Colors
                              //                               .deepOrange.shade500,
                              //                           size: 30,
                              //                         )),
                              //                   ),
                              //                 )),
                              //             onMenuStateChange: ((isOpen) {
                              //               reasonSearchController.clear();
                              //               setState(() {});
                              //             }),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
