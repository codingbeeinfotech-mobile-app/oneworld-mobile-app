import 'dart:async';
import 'dart:ui';

import 'package:abhilaya/controller/dashboard_routes_controller/delivery_location_controller.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/delivered_pages/submit_delivery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayPhiQrCodeGenerator extends StatefulWidget {
  const PayPhiQrCodeGenerator({super.key});

  @override
  State<PayPhiQrCodeGenerator> createState() => _PayPhiQrCodeGeneratorState();
}

class _PayPhiQrCodeGeneratorState extends State<PayPhiQrCodeGenerator> {
  var deliveryLocationController = Get.find<DeliveryLocationController>();
  Timer? timer;
  Duration duration = const Duration(seconds: 0);
  int maxTime = 180;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      call();
    });
  }

  call() async {
    maxTime = 180;
    deliveryLocationController.isPaymentPageOpened.value = true;
    await deliveryLocationController.callPayPhiQrGeneratorApi();
    if (deliveryLocationController.payPhiGenerateQrResponse.value != null &&
        deliveryLocationController
                .payPhiGenerateQrResponse.value!.respHeader!.returnCode ==
            200) {
      setState(() {});

      if (deliveryLocationController
                  .payPhiGenerateQrResponse.value!.respBody!.upiQr !=
              null &&
          deliveryLocationController
                  .payPhiGenerateQrResponse.value!.respBody!.upiQr !=
              "") {
        startTimer();
        deliveryLocationController.checkStatusPeriodically(context);
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        maxTime--;
        if (maxTime == 0) {
          stopTimer();
        }
        duration = duration + const Duration(seconds: 1);
      });
    });
  }

  stopTimer() {
    setState(() {});
    timer!.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.offAll(const SubmitDelivery());
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.deepOrange.shade500,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Payment")],
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         // Get.to(DeliveryList());
          //       },
          //       icon: const Icon(Icons.menu))
          // ],
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (!didPop) {
              showDialog(
                  context: context,
                  builder: (context) => BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: AlertDialog(
                          contentPadding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white,
                          title: Column(
                            children: [
                              Image.asset(
                                "assets/images/upi.png",
                                height:
                                    MediaQuery.sizeOf(context).height * 0.10,
                                width: MediaQuery.sizeOf(context).width * 0.50,
                              ),
                            ],
                          ),
                          content: const Text(
                            'Are you sure you want to cancel the transaction?',
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            ButtonBar(
                              alignment: MainAxisAlignment
                                  .spaceEvenly, // Align buttons evenly
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueGrey),
                                  onPressed: () {
                                    Get.offAll(const SubmitDelivery());
                                  },
                                  child: const Text('Exit'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueGrey),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
              return;
            }
          },
          child: deliveryLocationController.payPhiGenerateQrResponse.value ==
                  null
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(
                        alignment: Alignment.center,
                        // color: Colors.red,
                        height: MediaQuery.sizeOf(context).height / 2,
                        width: MediaQuery.sizeOf(context).width,
                        child: Lottie.asset("assets/lottiee/abhi_loading.json",
                            height: MediaQuery.sizeOf(context).height,
                            width: MediaQuery.sizeOf(context).width),
                      )),

                      const SizedBox(height: 10),
                      // const Text("Please Wait",style: TextStyle(color: Colors.black,fontSize: 20))
                    ],
                  ),
                )
              : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/upi.png",
                        height: MediaQuery.sizeOf(context).height * 0.15,
                        width: MediaQuery.sizeOf(context).width * 0.40,
                      ),
                      Visibility(
                          visible: deliveryLocationController
                                      .payPhiGenerateQrResponse
                                      .value!
                                      .respBody ==
                                  null &&
                              deliveryLocationController
                                      .payPhiGenerateQrResponse
                                      .value!
                                      .respHeader!
                                      .returnCode !=
                                  200,
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.40,
                            width: MediaQuery.sizeOf(context).width,
                            child: const Center(
                                child: Text("QR Generation Failed")),
                          )),
                      Visibility(
                          visible: deliveryLocationController
                                  .payPhiGenerateQrResponse
                                  .value!
                                  .respHeader!
                                  .returnCode ==
                              200,
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.30,
                            width: MediaQuery.sizeOf(context).width,
                            child: Center(
                                child: deliveryLocationController
                                                .payPhiGenerateQrResponse
                                                .value!
                                                .respBody !=
                                            null &&
                                        deliveryLocationController
                                                .payPhiGenerateQrResponse
                                                .value!
                                                .respBody!
                                                .upiQr! !=
                                            ""
                                    ? QrImageView(
                                        data: deliveryLocationController
                                            .payPhiGenerateQrResponse
                                            .value!
                                            .respBody!
                                            .upiQr!
                                            .toString(),
                                        // embeddedImage: AssetImage("assets/images/abhi_logo.png"),
                                        // embeddedImageStyle: QrEmbeddedImageStyle(
                                        //   size: Size(80, 80),
                                        // ),
                                      )
                                    : Image.asset(
                                        "assets/images/invalidQr.png")),
                          )),
                      const SizedBox(height: 20),
                      Text(
                        deliveryLocationController.payPhiGenerateQrResponse
                                        .value!.respBody !=
                                    null &&
                                deliveryLocationController
                                        .payPhiGenerateQrResponse
                                        .value!
                                        .respBody!
                                        .upiQr! !=
                                    ""
                            ? "QR Code for the Transaction"
                            : "QR Code can't be generated \n Please Try Again Later",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: deliveryLocationController.isTimeLeft.value,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  width: MediaQuery.sizeOf(context).width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Colors.deepOrange.shade500, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Please wait for $maxTime seconds ",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !deliveryLocationController.isTimeLeft.value,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  width: MediaQuery.sizeOf(context).width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Colors.deepOrange.shade500, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          deliveryLocationController
                              .generateStatusCheckSecureHashCode(
                                  "P_32395",
                                  "151253952716",
                                  "151253952716",
                                  "STATUS",
                                  "dab36a06ca064106a4ae442e0baac82e");
                          // await deliveryLocationController.callPayPhiCheckStatusApi(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Check Status",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
