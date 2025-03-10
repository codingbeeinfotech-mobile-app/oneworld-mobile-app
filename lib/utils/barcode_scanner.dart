// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MybatteryScanner extends StatefulWidget {
  // var list;
  // var player;
  // TextEditingController textController;

  void Function(String val) onDetect;

  MybatteryScanner({
    super.key,
    // required this.cameraController,
    // required this.list,
    // required this.player,
    required this.onDetect,
  });

  @override
  State<MybatteryScanner> createState() => _MybatteryScannerState();
}

class _MybatteryScannerState extends State<MybatteryScanner> {
  late AudioPlayer player;
  bool isBarcodeScanned = false;
  late MobileScannerController cameraController;
  final List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
    player = AudioPlayer();
    // print(widget.textController.value.text);
  }

  @override
  void dispose() {
    cameraController.dispose();
    player.dispose();
    print("disposed");
    super.dispose();
  }

  void handleBarcode(String code) async {
    if (isBarcodeScanned) return; // Prevent multiple navigations
    isBarcodeScanned = true;
    widget.onDetect(code);
    // widget.textController.text = code;
    debugPrint("CODE $code");
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
        backgroundColor:Colors.deepOrange.shade500,
        title: const Text('Barcode Scanner'),
      ),
      body: MobileScanner(
        controller: cameraController,
        errorBuilder: (context, error, child) {
          print(error);
          return Container(
            width: MediaQuery.sizeOf(context).width * 0.90,
            height: MediaQuery.sizeOf(context).height * 0.50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
          );
        },
        overlayBuilder: (context, constraints) {
          return Container(
            width: MediaQuery.sizeOf(context).width * 0.90,
            height: MediaQuery.sizeOf(context).height * 0.50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
          );
        },

        onDetect: (barcodeCapture) {
          if (isBarcodeScanned) return; // Ignore further scans

          final List<Barcode> barcodes = barcodeCapture.barcodes;
          if (barcodes.isNotEmpty) {
            String code = barcodes.first.rawValue ?? "No value";
            handleBarcode(code);
          } else {
            debugPrint("Failed to Scan Barcode");
          }
        },
      ),
    );
  }
}
