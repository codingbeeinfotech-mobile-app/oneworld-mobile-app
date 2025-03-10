import 'dart:convert';

import 'package:abhilaya/controller/drawer_routes_controller/sticker_controller.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/view/drawer_routes/print_stickers_connect_bluetooth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanTrackingNumber extends StatefulWidget {
  const ScanTrackingNumber({super.key});

  @override
  State<ScanTrackingNumber> createState() => _ScanTrackingNumberState();
}

class _ScanTrackingNumberState extends State<ScanTrackingNumber> {
  var stickerController = Get.find<StickerController>();
  final MobileScannerController cameraController = MobileScannerController();
  final List<dynamic> list = [];
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    stickerController.printTrackingNumber.value.clear();
    stickerController.selectedIndex = -1;
    stickerController.isBluetoothConnected.value = false;
    stickerController.validatePrintTrackingNumberResponse.value = null;
    stickerController.isTrackingNumberScanned.value = false;
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
            children: [Text("Print Sticker")],
          ),
          // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          color: Colors.white,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  controller: stickerController.printTrackingNumber.value,
                  onFieldSubmitted: (value) async {
                    Dialogs.lottieLoading(
                        context, "assets/lottiee/abhi_loading.json");
                    await stickerController
                        .callValidateTrackingNumberApi(value);
                    Navigator.pop(context);
                  },
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black45),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black45),
                          borderRadius: BorderRadius.circular(5)),
                      labelText: "Tracking Number",
                      suffixIcon: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyBatteryScanner(
                                cameraController: cameraController,
                                list: list,
                                player: player,
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.qr_code),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => InkWell(
                    onTap: () async {
                      debugPrint("Scanning Printers");
                      setState(() {
                        Get.to(const ConnectBluetooth());
                      });
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: stickerController.connectionStatus.value ==
                                BluetoothConnectionState.connected
                            ? Colors.lightGreenAccent
                            : Colors.grey.shade300,
                        border: Border.all(color: Colors.black45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            stickerController.connectionStatus.value ==
                                    BluetoothConnectionState.connected
                                ? "Connected"
                                : "Connect to Printer",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.bluetooth, color: Colors.blue.shade900)
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 10),
              Visibility(
                  visible: stickerController.isTrackingNumberScanned.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Tracking Number",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Quantity",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                stickerController.scannedTrackingNumber.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              stickerController
                                      .validatePrintTrackingNumberResponse
                                      .value
                                      ?.obj
                                      ?.childNumber
                                      .length
                                      .toString() ??
                                  'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: stickerController.connectionStatus.value ==
                  BluetoothConnectionState.connected &&
              stickerController.isTrackingNumberScanned.value,
          child: InkWell(
            onTap: () async {
              sendCPCLCommand();
              // Get.to(const ScanPrinters());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
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
                    Text("Print",
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

  // 2.5 * 1 meter
  void sendCPCLCommand() async {
    debugPrint("Printing");
    if (stickerController.characteristic.value != null) {
      String masterNo = stickerController
          .validatePrintTrackingNumberResponse.value!.obj!.masterNumber!
          .toString();
      String from = stickerController
          .validatePrintTrackingNumberResponse.value!.obj!.fromCity
          .toString();
      String to = stickerController
          .validatePrintTrackingNumberResponse.value!.obj!.toCity
          .toString();
      String qty = stickerController
          .validatePrintTrackingNumberResponse.value!.obj!.childNumber.length
          .toString();

      int? length = stickerController
          .validatePrintTrackingNumberResponse.value!.obj!.childNumber.length;
      // int? length = 1;
      for (int i = 0; i < length; i++) {
        String odnNo = stickerController.validatePrintTrackingNumberResponse
            .value!.obj!.childNumber[i].awbNo
            .toString();

        // String all = "! 0 200 200 200 1\r\nBARCODE 128 1 1 50 100 0 $masterNo\r\nTEXT 7 0 15 55 Master No: $masterNo\r\nTEXT 7 0 15 80 From: $from\r\nTEXT 7 0 250 80 To: $to\r\nTEXT 7 0 15 125 AwbNo: $odnNo\r\nTEXT 7 0 250 125 Qty: ${i+1}/$qty\r\nPRINT\r\n"; // Print command
        String all = """
! 0 200 200 200 1
BARCODE 128 1 1 50 100 0 $masterNo
TEXT 7 0 40 60 Master No: $masterNo
TEXT 7 0 10 90 From: $from
TEXT 7 0 200 90 To: $to
TEXT 7 0 15 135 AwbNo: $odnNo
TEXT 7 0 200 135 Qty: ${i + 1}/$qty
FORM
PRINT
""";

        List<int> bytes = utf8.encode(all);
        await stickerController.characteristic.value!.write(bytes);

        if (i + 1 == length) {
          // Get.offAll(const Dashboard());
        }
      }

      // String all = "! 0 200 200 200 1\r\n" + // Set page size
      //     "BARCODE 128 1 1 50 100 0 " + masterNo + "\r\n" + // Centered barcode at top
      //     "TEXT 7 0 15 55 Master No: " + masterNo + "\r\n" + // Master No text below barcode
      //     "TEXT 7 0 15 80 From: " + from + "\r\n" + // Left column
      //     "TEXT 7 0 250 80 To: " + to + "\r\n" + // Right column
      //     "TEXT 7 0 15 125 AwbNo: " + masterNo + "\r\n" + // Left column
      //     "TEXT 7 0 250 125 Qty: " + qty + "\r\n" + // Right column
      //     "PRINT\r\n"; // Print command
      //
      // // print(all);
    }
  }
}

class MyBatteryScanner extends StatefulWidget {
  var list;
  var player;
  MyBatteryScanner(
      {super.key,
      required this.cameraController,
      required this.list,
      required this.player});

  final MobileScannerController cameraController;

  @override
  State<MyBatteryScanner> createState() => _MyBatteryScannerState();
}

class _MyBatteryScannerState extends State<MyBatteryScanner> {
  AudioPlayer player = AudioPlayer();
  bool isBarcodeScanned = false; // Add this flag
  var stickerController = Get.find<StickerController>();

  @override
  void initState() {
    super.initState();
  }

  void handleBarcode(String code) async {
    if (isBarcodeScanned) return;
    isBarcodeScanned = true;
    try {
      await player.setAsset('assets/sounds/success.mp3');
      player.play();
    } catch (e) {
      debugPrint("Error while playing audio");
    }

    stickerController.scannedTrackingNumber.value = code;
    stickerController.printTrackingNumber.value.text = code;
    // stickerController.isTrackingNumberScanned.value = true;
    await stickerController.callValidateTrackingNumberApi(code);
    setState(() {});
    Get.back(); // Navigate back once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
