import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/drawer_routes_controller/returnpickup_controller.dart';
import 'package:abhilaya/model/response_model/return_pickup_response.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/view/drawer_routes/return_pickup_submit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReturnPickup extends StatefulWidget {
  const ReturnPickup({super.key});

  @override
  State<ReturnPickup> createState() => _ReturnPickupState();
}

class _ReturnPickupState extends State<ReturnPickup> {
  var returnPickupController = Get.find<ReturnPickupController>();
  TextEditingController searchController = TextEditingController();
  var loginController = Get.find<LoginController>();
  List<Datum> filterList = <Datum>[];
  GeneralMethods generalMethods = GeneralMethods();

  call() async {
    returnPickupController.returnPickupProductList.clear();
    filterList.clear();
    await returnPickupController.callReturnPickupApi();
    setState(() {
      filterList = returnPickupController.returnPickupProductList;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 0),
      () async {
        await call();
      },
    );
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  void filterSearchResults(String query) {
    List<Datum> dummySearchList =
        List<Datum>.from(returnPickupController.returnPickupProductList);
    if (query.isNotEmpty) {
      List<Datum> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.trackingNumber!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filterList = dummyListData;
      });
      return;
    } else {
      setState(() {
        filterList =
            List<Datum>.from(returnPickupController.returnPickupProductList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            //   IconButton(
            //       onPressed: () {
            //         setState(() {});
            //       },
            //       icon: Icon(Icons.menu))
            // ],
          ),
          body: returnPickupController.returnPickupResponse.value == null
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Colors.deepOrange.shade500),
                  ),
                )
              : returnPickupController
                          .returnPickupResponse.value!.result!.flag ==
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
                  : returnPickupController.returnPickupProductList.isEmpty
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
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Material(
                                  elevation: 10.0, // Adjust elevation as needed
                                  borderRadius: BorderRadius.circular(10.0),
                                  shadowColor: Colors.black,
                                  child: TextFormField(
                                    controller: searchController,
                                    focusNode: returnPickupController
                                        .searchTrackingNumberFocusNode.value,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
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
                                          borderSide: const BorderSide(
                                              color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.black45)),
                                      label: Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                              child: Text(
                                                  'Search Tracking Number...',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: returnPickupController
                                                              .searchTrackingNumberFocusNode
                                                              .value
                                                              .hasFocus
                                                          ? Colors.black45
                                                          : Colors.black45)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      prefixIcon:
                                          const Icon(Icons.search, size: 20),
                                    ),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                padding: const EdgeInsets.all(10),
                                scrollDirection: Axis.vertical,
                                physics: const ClampingScrollPhysics(),
                                itemCount: filterList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  // height:50,

                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.40,
                                                  child: TextFormField(
                                                      controller:
                                                          TextEditingController(
                                                              text: filterList[
                                                                      index]
                                                                  .trackingNumber
                                                                  .toString()),
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        enabled: false,
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black45)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .deepOrange
                                                                    .shade500)),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black45)),
                                                        label: const Text.rich(
                                                          TextSpan(
                                                            children: <InlineSpan>[
                                                              WidgetSpan(
                                                                child: Text(
                                                                    'Tracking Number',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black45)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      SizedBox(
                                                        // height:50,
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.40,
                                                        child: TextFormField(
                                                            enabled: false,
                                                            maxLines: null,
                                                            controller: TextEditingController(
                                                                text: filterList[
                                                                        index]
                                                                    .pickupCustomerName
                                                                    .toString()
                                                                    .capitalizeFirst),
                                                            style: const TextStyle(
                                                                fontSize: 13,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              Colors.black45)),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          10),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .deepOrange
                                                                          .shade500)),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              Colors.black45)),
                                                              label: const Text
                                                                  .rich(
                                                                TextSpan(
                                                                  children: <InlineSpan>[
                                                                    WidgetSpan(
                                                                      child: Text(
                                                                          'Customer Name',
                                                                          style:
                                                                              TextStyle(color: Colors.black45)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            SizedBox(
                                              // height:70,
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              child: TextFormField(
                                                controller:
                                                    TextEditingController(
                                                        text: filterList[index]
                                                            .pickupLocation
                                                            .toString()
                                                            .capitalizeFirst),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                  enabled: false,
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
                                                          child: Text(
                                                              'Pickup Location',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                maxLines: null,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            InkWell(
                                              onTap: () async {
                                                returnPickupController
                                                    .selectedReturnProductPickupAddress
                                                    .value = filterList[
                                                        index]
                                                    .pickupLocation!;
                                                debugPrint(
                                                    "current value from back ${returnPickupController.selectedReturnProductPickupAddress.value}");
                                                returnPickupController
                                                    .selectedReturnProductTrackingNumber
                                                    .value = filterList[
                                                        index]
                                                    .trackingNumber!;
                                                returnPickupController
                                                        .selectedNpr.value =
                                                    "Please Select NPR";
                                                returnPickupController
                                                    .selectedQcCheck
                                                    .value = "Select QC";
                                                returnPickupController
                                                    .selectedQcFailedReason
                                                    .value = "Select QC Reason";
                                                returnPickupController
                                                    .productImageList
                                                    .clear();
                                                returnPickupController
                                                    .isQcPassed.value = false;
                                                setState(() {});
                                                // CustomLoader.circularLoading(context);
                                                if (loginController
                                                        .connectionStatus
                                                        .value ==
                                                    "ConnectivityResult.none") {
                                                  await generalMethods
                                                      .initConnectivity();
                                                } else {
                                                  Get.to(
                                                      const ReturnPickupSubmit());
                                                }
                                              },
                                              child: Container(
                                                // height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.deepOrange
                                                            .shade500,
                                                        Colors.deepOrange
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomCenter),
                                                ),
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.05,
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("Pick",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15)
                                    ],
                                  );
                                },
                              ),
                              /* ListView.builder(
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                itemCount: returnPickupController.returnPickupProductList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print("Number of values for key ${returnPickupController.map.keys.elementAt(index)}: ${returnPickupController.map.values.elementAt(index).length}");
                  print("Number ${returnPickupController.map[returnPickupController.returnPickupProductList[index].pickupLocation.toString()]?.length}");
                  return
                    Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
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
                                        "${returnPickupController.map[returnPickupController.returnPickupProductList[index].pickupLocation.toString()]?.length}",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange.shade500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text("Available Deliveries",style: TextStyle(fontSize: 15,color: Colors.black45),)
                                  ],
                                ),

                              ],
                            ),
                            const SizedBox(height:15),
                            Row(
                              children: [
                                Container(
                                  height:50,
                                  width: MediaQuery.sizeOf(context).width*0.40,
                                  child: TextFormField(
                                      controller: TextEditingController(text: returnPickupController.returnPickupProductList[index].trackingNumber.toString().capitalizeFirst),
                                      style:const TextStyle(
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis ,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide:const BorderSide(
                                                color: Colors.black45)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide:
                                            BorderSide(color:Colors.deepOrange.shade500)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const  BorderSide(
                                                color: Colors.black45)
                                        ),
                                        label:const Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              WidgetSpan(
                                                child: Text('Tacking Number',
                                                    style: TextStyle(
                                                        color:  Colors.black45)),
                                              ),
                                            ],
                                          ),
                                        ),

                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        // height:50,
                                        width: MediaQuery.sizeOf(context).width*0.40,
                                        child: TextFormField(
                                          maxLines: null,
                                            controller: TextEditingController(text: returnPickupController.returnPickupProductList[index].pickupCustomerName.toString().capitalizeFirst),
                                            style:const TextStyle(
                                              fontSize: 13,
                                              overflow: TextOverflow.ellipsis ,
                                              color: Colors.black,
                                                fontWeight: FontWeight.w500
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide:const BorderSide(
                                                      color: Colors.black45)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide:
                                                  BorderSide(color:Colors.deepOrange.shade500)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: const  BorderSide(
                                                      color: Colors.black45)
                                              ),
                                              label:const Text.rich(
                                                TextSpan(
                                                  children: <InlineSpan>[
                                                    WidgetSpan(
                                                      child: Text('Customer Name',
                                                          style: TextStyle(
                                                              color:  Colors.black45)),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height:15),
                            Container(
                              // height:70,
                              width: MediaQuery.sizeOf(context).width,
                              child: TextFormField(
                                  controller: TextEditingController(text: returnPickupController.returnPickupProductList[index].pickupLocation.toString().capitalizeFirst),
                                  style:const TextStyle(
                                      fontSize: 13,
                                      overflow: TextOverflow.visible ,
                                      color: Colors.black,
                                    fontWeight: FontWeight.w500
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:const BorderSide(
                                            color: Colors.black45)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                        BorderSide(color:Colors.deepOrange.shade500)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const  BorderSide(
                                            color: Colors.black45)
                                    ),
                                    label:const Text.rich(
                                      TextSpan(
                                        children: <InlineSpan>[
                                          WidgetSpan(
                                            child: Text('Pickup Location',
                                                style: TextStyle(
                                                    color:  Colors.black45)),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                maxLines: null,
                              ),
                            ),
                            const SizedBox(height:15),
                            InkWell(
                              onTap: ()  async{
                                returnPickupController.selectedReturnProductPickupAddress.value = returnPickupController.returnPickupProductList[index].pickupLocation.toString() ;
                                returnPickupController.selectedReturnProductTrackingNumber.value = returnPickupController.returnPickupProductList[index].trackingNumber.toString() ;
                                returnPickupController.selectedNdr.value = "Please Select NDR";
                                returnPickupController. selectedQcFailedReason.value = "Select QC Reason";
                                returnPickupController.productImageList.clear();
                                returnPickupController.isQcPassed.value = false;
                                setState(() {
                                });
                                // CustomLoader.circularLoading(context);
                                if(loginController.connectionStatus.value == "ConnectivityResult.none"){
                                  await generalMethods.initConnectivity();
                                }
                                else{
                                  Get.to(const ReturnPickupSubmit());
                                }
                              },
                              child: Container(
                                // height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [Colors.deepOrange.shade500,Colors.deepOrange],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter
                                  ),),
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height*0.05,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(

                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Pick",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15)
                    ],
                  );
                },) */
                            ],
                          ),
                        ));
    });
  }
}
