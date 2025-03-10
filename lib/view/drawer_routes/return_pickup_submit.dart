import 'dart:io';
import 'dart:typed_data';

import 'package:abhilaya/utils/toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../controller/auth_controller/login_controller.dart';
import '../../controller/drawer_routes_controller/returnpickup_controller.dart';
import '../../utils/general/general_methods.dart';
import '../../utils/image_picker.dart';

class ReturnPickupSubmit extends StatefulWidget {
  const ReturnPickupSubmit({super.key});

  @override
  State<ReturnPickupSubmit> createState() => _ReturnPickupSubmitState();
}

class _ReturnPickupSubmitState extends State<ReturnPickupSubmit> {
  var returnPickupController = Get.find<ReturnPickupController>();

  call() async {
    returnPickupController.ndrAPIResponseList.clear();
    returnPickupController.selectedNdrCodeValue.value = "0";
    returnPickupController.ndrResponseList.clear();
    returnPickupController.qcCheckValue.value = "0";
    returnPickupController.scannedBarcode.value.clear();
    returnPickupController.selectedQcFailedReasonValue.value = "0";

    await returnPickupController.callValidateReturnPickupApi(
        returnPickupController.selectedReturnProductTrackingNumber.value);
    await returnPickupController.callNDRListApi();
    await returnPickupController.callQcFailedReasonApi();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () async {
      await call();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController locationSearchController = TextEditingController();
    final MobileScannerController cameraController = MobileScannerController();
    final List<dynamic> list = []; // Replace with your actual list
    final AudioPlayer player = AudioPlayer();
    var loginController = Get.find<LoginController>();
    GeneralMethods generalMethods = GeneralMethods();

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange.shade500,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Return Pickup")],
          ),
          // actions: [
            // IconButton(
            //     onPressed: () {
            //       setState(() {});
            //     },
            //     icon: const Icon(Icons.menu))
          // ],
        ),
        body: returnPickupController.validatePickupResponse.value == null
            ? SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Center(
                  child: CircularProgressIndicator(
                      color: Colors.deepOrange.shade500),
                ),
              )
            : returnPickupController
                        .validatePickupResponse.value!.result!.flag ==
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
                : returnPickupController.temp.value == null
                    ? SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Colors.deepOrange.shade500),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black45),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: AbsorbPointer(
                                  absorbing: true,
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    underline: Container(),
                                    focusNode: returnPickupController
                                        .selectedReturnProductPickupAddressFocusNode
                                        .value,
                                    value: returnPickupController
                                        .selectedReturnProductPickupAddress
                                        .value,
                                    onChanged: (selected) async {
                                      List<String>? tempTrackingNumberList = [];
                                      tempTrackingNumberList =
                                          returnPickupController.map[selected];
                                      returnPickupController
                                          .callValidateReturnPickupApi(
                                              tempTrackingNumberList![0]);
                                      returnPickupController
                                          .selectedReturnProductTrackingNumber
                                          .value = tempTrackingNumberList[0];
                                      returnPickupController
                                          .scannedBarcode.value
                                          .clear();
                                      setState(() {
                                        returnPickupController
                                            .selectedReturnProductPickupAddress
                                            .value = selected!;
                                      });
                                    },
                                    items: returnPickupController
                                        .returnPickupLocationList
                                        .toSet()
                                        .toList()
                                        .map((items) {
                                      return DropdownMenuItem(
                                          value: items.toString(),
                                          child: Text(
                                            items.toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                overflow: TextOverflow.visible,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ));
                                    }).toList(),
                                    dropdownSearchData: DropdownSearchData(
                                        searchController:
                                            locationSearchController,
                                        searchInnerWidgetHeight: 30,
                                        searchInnerWidget: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              // border: Border.all(color: Colors.deepOrange.shade500),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: SizedBox(
                                            child: TextFormField(
                                              controller:
                                                  locationSearchController,
                                              decoration: InputDecoration(
                                                  hintText: 'Search',
                                                  isDense: true,
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black45)),
                                                  suffixIcon: Icon(
                                                    Icons.search,
                                                    color: Colors
                                                        .deepOrange.shade500,
                                                    size: 30,
                                                  )),
                                            ),
                                          ),
                                        )),
                                    onMenuStateChange: ((isOpen) {
                                      locationSearchController.clear();
                                      setState(() {});
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  SizedBox(
                                    // height:50,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.50,
                                    child: TextFormField(
                                        controller: TextEditingController(
                                            text: returnPickupController
                                                .selectedReturnProductTrackingNumber
                                                .value),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            overflow: TextOverflow.visible,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.black45)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .deepOrange.shade500)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.black45)),
                                          label: const Text.rich(
                                            TextSpan(
                                              children: <InlineSpan>[
                                                WidgetSpan(
                                                  child: Text('Tracking Number',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color:
                                                              Colors.black45)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          // height:50,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.30,
                                          child: TextFormField(
                                              readOnly: true,
                                              controller: TextEditingController(
                                                  text: returnPickupController
                                                      .temp
                                                      .value!
                                                      .qualityCheck),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .black45)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .deepOrange
                                                                .shade500)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black45)),
                                                label: const Text.rich(
                                                  TextSpan(
                                                    children: <InlineSpan>[
                                                      WidgetSpan(
                                                        child: Text('QC Check',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                // height:50,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                    readOnly: true,
                                    maxLines: null,
                                    controller: TextEditingController(
                                        text: returnPickupController
                                            .temp.value!.productDescription),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black45)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.deepOrange.shade500)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black45)),
                                      label: const Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                              child: Text('Product Description',
                                                  style: TextStyle(
                                                      color: Colors.black45)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                // height:50,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                    readOnly: true,
                                    maxLines: null,
                                    controller: TextEditingController(
                                        text: returnPickupController
                                            .temp.value!.returnReason
                                            .toString()
                                            .capitalizeFirst),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black45)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.deepOrange.shade500)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black45)),
                                      label: const Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                              child: Text('Return Reason',
                                                  style: TextStyle(
                                                      color: Colors.black45)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                // height: 50,
                                child: TextFormField(
                                  // controller: TextEditingController(text: deliveryLocationController.scannedTrackingNumber.value),
                                  // readOnly: true,
                                  controller: returnPickupController
                                      .scannedBarcode.value,
                                  focusNode: returnPickupController
                                      .scannedBarcodeFocusNode.value,
                                  maxLines: 1,
                                  onFieldSubmitted: (value) async {
                                    returnPickupController
                                        .scannedBarcode.value.text = value;
                                  },
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.black),
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black45),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black45),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Barcode",
                                      labelStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black45),
                                      suffixIcon: InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyBarcodeScanner(
                                                cameraController:
                                                    cameraController,
                                                list: list,
                                                player: player,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(Icons.qr_code,
                                            color: Colors.deepOrange.shade500),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Visibility(
                                visible: returnPickupController
                                    .isProductImageAvailable.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black45),
                                  ),
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.15,
                                  width: MediaQuery.sizeOf(context).width,
                                  child: CarouselSlider.builder(
                                    itemCount: 1,
                                    itemBuilder: (context, index, realIndex) {
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Image.network(
                                                  returnPickupController
                                                      .temp.value!.productImage
                                                      .toString(),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  returnPickupController
                                                      .temp.value!.productImage
                                                      .toString()),
                                              fit: BoxFit.fill,
                                              onError: (exception, stackTrace) {
                                                // MyToast.myShowToast("Image Link Invalid");
                                                setState(() {
                                                  Image.asset(
                                                      "assets/images/abhi_logo.png");
                                                  returnPickupController
                                                      .isProductImageAvailable
                                                      .value = false;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.15,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      aspectRatio: 30 / 15,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      viewportFraction: 0.9,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                  visible:
                                      returnPickupController.isQcPassed.value,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              "QC Status",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black45),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black45),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.40,
                                            child: DropdownButton(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              menuMaxHeight: 100,
                                              isExpanded: true,
                                              underline: Container(),
                                              focusNode: returnPickupController
                                                  .selectedQcCheckFocusNode
                                                  .value,
                                              value: returnPickupController
                                                  .selectedQcCheck.value,
                                              onChanged: (selected) {
                                                returnPickupController
                                                    .selectedQcCheck
                                                    .value = selected!;
                                                if (selected == "Select QC") {
                                                  returnPickupController
                                                      .selectedQcFailedReasonValue
                                                      .value = "0";
                                                } else if (selected == "Pass") {
                                                  returnPickupController
                                                      .selectedQcFailedReasonValue
                                                      .value = "0";
                                                }
                                              },
                                              items: [
                                                "Select QC",
                                                "Pass",
                                                "Fail"
                                              ].map((items) {
                                                return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        overflow: TextOverflow
                                                            .visible));
                                              }).toList(),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      ),
                                      Visibility(
                                        visible: returnPickupController
                                                .selectedQcCheck.value ==
                                            "Fail",
                                        child: Expanded(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15.0),
                                                  child: Text(
                                                    "QC Reason",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.black45),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.40,
                                                  child: DropdownButton(
                                                    focusNode:
                                                        returnPickupController
                                                            .selectedQcFailedReasonFocusNode
                                                            .value,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    isExpanded: true,
                                                    underline: Container(),
                                                    value: returnPickupController
                                                        .selectedQcFailedReason
                                                        .value,
                                                    onChanged: (value) {
                                                      returnPickupController
                                                          .selectedQcFailedReason
                                                          .value = value!;
                                                      returnPickupController
                                                          .getQcFailReasonValue(
                                                              value);
                                                    },
                                                    items:
                                                        returnPickupController
                                                            .qcFailedReasonList
                                                            .toSet()
                                                            .map((items) {
                                                      return DropdownMenuItem(
                                                          value: items,
                                                          child: Text(items,
                                                              maxLines: null,
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)));
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                      )
                                    ],
                                  )),
                              Visibility(
                                visible:
                                    !returnPickupController.isQcPassed.value ||
                                        returnPickupController
                                                .selectedQcCheck.value ==
                                            "Select QC",
                                child: Container(
                                  // height: 50,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black45),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: MediaQuery.sizeOf(context).width,
                                  child: DropdownButton(
                                    menuMaxHeight:
                                        MediaQuery.sizeOf(context).height *
                                            0.25,
                                    borderRadius: BorderRadius.circular(15),
                                    underline: Container(),
                                    isExpanded: true,
                                    value: returnPickupController
                                        .selectedNpr.value,
                                    focusNode: returnPickupController
                                        .selectedNdrFocusNode.value,
                                    onChanged: (selected) {
                                      returnPickupController.selectedNpr.value =
                                          selected!;
                                      returnPickupController
                                          .getNdrReasonValue(selected);
                                    },
                                    items: returnPickupController
                                        .ndrResponseList
                                        .map((items) {
                                      return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.black45),
                                          ));
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              callImageAdder(
                                  returnPickupController.productImageByte,
                                  returnPickupController
                                      .productSelectedImageByte,
                                  "Upload Photo"),
                              const SizedBox(height: 15),
                              Container(
                                color: Colors.black12,
                                padding: const EdgeInsets.all(10),
                                height:
                                    MediaQuery.sizeOf(context).height * 0.20,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemCount: returnPickupController
                                      .productImageList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                      image: MemoryImage(
                                                          returnPickupController
                                                                  .productImageList[
                                                              index]),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: -10,
                                                bottom: 0,
                                                child: Container(
                                                  height: 30,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors
                                                        .black, // Background color
                                                    shape: BoxShape
                                                        .circle, // Circular background
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      returnPickupController
                                                          .productImageList
                                                          .removeAt(index);
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.10,
          child: InkWell(
            onTap: () async {
              if (validateReturnPickupDetails()) {
                if (loginController.connectionStatus.value ==
                    "ConnectivityResult.none") {
                  await generalMethods.initConnectivity();
                } else {
                  returnPickupController.callSubmitReturnPickupApi(context);
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.only(
                      // left: 22,
                      // top: 10,
                      // bottom: 10,
                      // right: 20
                      ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Colors.deepOrange.shade500, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget callImageAdder(
      Rx<Uint8List?> ImageBytes, Rx<File?> SelectedImage, String title) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black45)),
      child: InkWell(
        onTap: () {
          returnPickupController.isReturnPickupImage.value = true;
          PickImage().showImagePickerOption(ImageBytes, SelectedImage, context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/add-image.png'),
                      fit: BoxFit.cover),
                ),
              ),
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

  bool validateReturnPickupDetails() {
    if (returnPickupController
        .selectedReturnProductPickupAddress.value.isEmpty) {
      MyToast.myShowToast("Select Valid Pickup Address");
      returnPickupController.selectedReturnProductPickupAddressFocusNode.value
          .requestFocus();
      return false;
    } else if (returnPickupController.isQcPassed.value) {
      if (returnPickupController.selectedQcCheck.value == "Select QC") {
        if (returnPickupController.selectedNpr.value == "Please Select NPR") {
          MyToast.myShowToast("Please Select NPR Reason");
          return false;
        }
      }

      if (returnPickupController.selectedQcCheck.value.toLowerCase() ==
              "fail" &&
          returnPickupController.selectedQcFailedReason.value ==
              "Select QC Reason") {
        MyToast.myShowToast("Please Select QR Reason");
        returnPickupController.selectedQcFailedReasonFocusNode.value
            .requestFocus();
        return false;
      }
    }
    // else if (returnPickupController.isQcPassed.value &&
    //     (returnPickupController.selectedQcCheck.value.toLowerCase() ==
    //         'select qc') && (returnPickupController.selectedNdr.value == "Please Select NPR")) {
    //
    //     MyToast.myShowToast("Please Select NPR Reason");
    //     return false;
    //
    // }
    // else if(!returnPickupController.isQcPassed.value || returnPickupController.selectedQcCheck.value == "Select QC"){
    //   if(returnPickupController.selectedNdr.value == "Please Select NDR"){
    //     MyToast.myShowToast("Please Select a NDR Reason");
    //     returnPickupController.selectedNdrFocusNode.value.requestFocus();
    //     return false;
    //   }
    // }

    return true;
  }
}

class MyBarcodeScanner extends StatefulWidget {
  var list;
  var player;

  MyBarcodeScanner(
      {super.key,
      required this.cameraController,
      required this.list,
      required this.player});

  final MobileScannerController cameraController;

  @override
  State<MyBarcodeScanner> createState() => _MyBarcodeScannerState();
}

class _MyBarcodeScannerState extends State<MyBarcodeScanner> {
  AudioPlayer player = AudioPlayer();
  bool isBarcodeScanned = false; // Add this flag
  var deliveryLocationController = Get.find<ReturnPickupController>();

  @override
  void initState() {
    super.initState();
  }

  void handleBarcode(String code) async {
    if (isBarcodeScanned) return; // Prevent multiple navigations
    isBarcodeScanned = true;
    // // Play sound on barcode scan
    // await player.setAsset('assets/sounds/success.mp3');
    // player.play();
    deliveryLocationController.scannedBarcode.value.text = code;
    // await deliveryLocationController.callValidateReturnPickupApi(code);
    // deliveryLocationController.selectedReturnProductTrackingNumber.value =
    //     deliveryLocationController.scannedBarcode.value.text.toString();
    // deliveryLocationController.trackingNumberController.value.text = code;
    // deliveryLocationController.validateTrackingNumber();
    setState(() {});
    Get.back(); // Navigate back once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Barcode Scanner'),
      ),
      body: MobileScanner(
        controller: widget.cameraController,
        onDetect: (barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          if (barcodes.isEmpty) {
            debugPrint("Failed to Scan Barcode");
          } else {
            // Extract the raw value from the first barcode in the list
            String code = barcodes.first.rawValue ?? "No value";
            handleBarcode(code); // Handle barcode and navigate back
          }
        },
      ),
    );
  }

  callBarcodeScanner(
      MobileScannerController cameraController, var list, var player) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Barcode Scanner'),
      ),
      body: MobileScanner(
        controller: widget.cameraController,
        onDetect: (barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          if (barcodes.isEmpty) {
            debugPrint("Failed to Scan Barcode");
          } else {
            // Extract the raw value from the first barcode in the list
            String code = barcodes.first.rawValue ?? "No value";
            handleBarcode(code); // Handle barcode and navigate back
          }
        },
      ),
    );
  }
}
