import 'package:abhilaya/controller/dashboard_routes_controller/undelivered_loaction_controller.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/dashboard/Dashboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../controller/auth_controller/login_controller.dart';
import '../../../../utils/barcode_scanner.dart';
import '../../../../utils/general/general_methods.dart';

class UndeliveredLocation extends StatefulWidget {
  const UndeliveredLocation({super.key});

  @override
  State<UndeliveredLocation> createState() => _UndeliveredLocationState();
}

class _UndeliveredLocationState extends State<UndeliveredLocation> {
  var undeliveredLocationController = Get.find<UndeliveredLocationController>();
  var loginController = Get.find<LoginController>();
  GeneralMethods generalMethods = GeneralMethods();

  call() async {
    undeliveredLocationController.scannedNdrDeliveries.clear();
    undeliveredLocationController.ndrLocationList.clear();
    undeliveredLocationController.trackingNumberController.value.clear();
    undeliveredLocationController.selectedNdrLocation.value =
        "Select NDR Location";
    undeliveredLocationController.isTrackingNumberValid.value = false;
    await undeliveredLocationController.callNdrLocationAPI();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 0),
      () {
        call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    final MobileScannerController cameraController = MobileScannerController();
    final List<dynamic> list = []; // Replace with your actual list
    final AudioPlayer player = AudioPlayer();

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
            children: [Text("NDR Location")],
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         setState(() {});
          //       },
          //       icon: Icon(Icons.menu))
          // ],
        ),
        body: undeliveredLocationController.ndrByLocationResponse.value == null
            ? SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange.shade500,
                  ),
                ),
              )
            : undeliveredLocationController
                        .ndrByLocationResponse.value!.result!.flag ==
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
                : undeliveredLocationController
                        .ndrByLocationResponse.value!.data.isEmpty
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
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 15, bottom: 15),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black45),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton2(
                                  isExpanded: true,
                                  underline: Container(),
                                  value: undeliveredLocationController
                                      .selectedNdrLocation.value,
                                  onChanged: (selected) {
                                    setState(() {
                                      undeliveredLocationController
                                          .selectedNdrLocation
                                          .value = selected!;
                                      undeliveredLocationController
                                          .trackingNumberController.value
                                          .clear();
                                    });
                                  },
                                  items: undeliveredLocationController
                                      .ndrLocationList
                                      .toSet()
                                      .map((items) {
                                    return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(fontSize: 11),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ));
                                  }).toList(),
                                  dropdownSearchData: DropdownSearchData(
                                      searchController: searchController,
                                      searchInnerWidgetHeight: 30,
                                      searchInnerWidget: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            // border: Border.all(color: Colors.deepOrange.shade500),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: SizedBox(
                                          child: TextFormField(
                                            controller: searchController,
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
                                    searchController.clear();
                                    setState(() {});
                                  }),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Visibility(
                                  visible: undeliveredLocationController
                                          .selectedNdrLocation.value !=
                                      "Select NDR Location",
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 15,
                                          bottom: 15),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            // height: 60,
                                            child: TextFormField(
                                              controller: TextEditingController(
                                                  text:
                                                      undeliveredLocationController
                                                          .selectedNdrLocation
                                                          .value),
                                              readOnly: true,
                                              maxLines: null,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Colors
                                                                  .black45),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Colors
                                                                  .black45),
                                                      borderRadius: BorderRadius
                                                          .circular(5)),
                                                  labelText:
                                                      "Delivery Location Name",
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      MapsLauncher.launchQuery(
                                                          undeliveredLocationController
                                                              .selectedNdrLocation
                                                              .value);
                                                    },
                                                    child: const Icon(
                                                      Icons.location_on,
                                                      color: Colors.deepOrange,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                // height: 40,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.60,
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  // controller: TextEditingController(text: deliveryLocationController.scannedTrackingNumber.value),
                                                  // readOnly: true,
                                                  controller:
                                                      undeliveredLocationController
                                                          .trackingNumberController
                                                          .value,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .characters,
                                                  onFieldSubmitted:
                                                      (value) async {
                                                    if (loginController
                                                            .connectionStatus
                                                            .value ==
                                                        "ConnectivityResult.none") {
                                                      await generalMethods
                                                          .initConnectivity();
                                                    } else {
                                                      await undeliveredLocationController
                                                          .callValidatePickUpTrackingNumberApi(
                                                              value);
                                                    }
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .black45),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .black45),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      labelText:
                                                          "Tracking Number",
                                                      suffixIcon: InkWell(
                                                        onTap: () async {
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MybatteryScanner(
                                                                onDetect:
                                                                    (String
                                                                        code) {
                                                                  undeliveredLocationController
                                                                      .scannedTrackingNumber
                                                                      .value = code;
                                                                  undeliveredLocationController
                                                                      .trackingNumberController
                                                                      .value
                                                                      .text = code;
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                          if (undeliveredLocationController
                                                              .trackingNumberController
                                                              .value
                                                              .text
                                                              .isNotEmpty) {
                                                            await undeliveredLocationController
                                                                .callValidatePickUpTrackingNumberApi(
                                                                    undeliveredLocationController
                                                                        .trackingNumberController
                                                                        .value
                                                                        .text);
                                                          }
                                                        },
                                                        child: const Icon(
                                                            Icons.qr_code),
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    // height: 40,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.25,
                                                    child: TextFormField(
                                                      controller: TextEditingController(
                                                          text: undeliveredLocationController
                                                              .scannedNdrDeliveries
                                                              .length
                                                              .toString()
                                                              .trim()),
                                                      readOnly: true,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      maxLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black45),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black45),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        labelText: "Scan Count",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          ///Total Order Row
                                          /*
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: MediaQuery.sizeOf(context).width/5,
                                  child: TextFormField(
                                    controller: TextEditingController(text: undeliveredLocationController.scannedNDRDeliveries.length.toString()),
                                    readOnly: true,
                                    style:const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
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
                                      labelText: "Total Order",
                                    ),
                                  ),
                                ),
                                // const SizedBox(width: 15),
                                /*
                                Container(
                                  height: 30,
                                  width: MediaQuery.sizeOf(context).width/4,
                                  child: TextFormField(
                                    controller: undeliveredLocationController.amountController.value,
                                    readOnly: true,
                                    style:const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black45),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black45),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      labelText: "Amount",
                                    ),
                                  ),
                                ),
                                */

                              ],
                            ),
                            const SizedBox(height:10),
                             */
                                        ],
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 15),
                              Visibility(
                                  visible: undeliveredLocationController
                                      .isTrackingNumberValid.value,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10,
                                          top: 15,
                                          bottom: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                "Tracking Number",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Status",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ListView.builder(
                                            itemCount:
                                                undeliveredLocationController
                                                    .scannedNdrDeliveries
                                                    .length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                              height: 20.0),
                                                          Text(
                                                            undeliveredLocationController
                                                                .scannedNdrDeliveries[
                                                                    index]
                                                                .trackingNumber
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                              height: 20.0),
                                                          Text(
                                                            undeliveredLocationController
                                                                .scannedNdrDeliveries[
                                                                    index]
                                                                .transporterId
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 13.0,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ) // const SizedBox(height: 8.0),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                      color: Colors.grey),
                                                  const SizedBox(height: 7)
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
        bottomNavigationBar: Visibility(
          visible: undeliveredLocationController.isTrackingNumberValid.value,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                if (loginController.connectionStatus.value ==
                    "ConnectivityResult.none") {
                  await generalMethods.initConnectivity();
                } else {
                  if (undeliveredLocationController
                      .scannedNdrDeliveries.isNotEmpty) {
                    Dialogs.signUpLoading(context);
                    await undeliveredLocationController.callSubmitNdrApi();
                    Navigator.pop(context);
                  }
                  if (undeliveredLocationController
                          .submitNdrResponse.value!.flag ==
                      true) {
                    MyToast.myShowToast("success");
                    Get.offAll(  BottomNavBar());
                  }
                }
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.06,
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.only(
                    left: 22, top: 10, bottom: 10, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [Colors.deepOrange.shade500, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 15),
                    // Icon(Icons.arrow_forward,color: Colors.white,),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
