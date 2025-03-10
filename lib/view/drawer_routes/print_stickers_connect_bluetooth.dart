import 'dart:io';

import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/drawer_routes_controller/sticker_controller.dart';

class ConnectBluetooth extends StatefulWidget {
  const ConnectBluetooth({super.key});

  @override
  State<ConnectBluetooth> createState() => _ConnectBluetoothState();
}

class _ConnectBluetoothState extends State<ConnectBluetooth> {
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  FlutterBluePlus flutterBluePlus = FlutterBluePlus();
  var stickerController = Get.find<StickerController>();

  // BluetoothCharacteristic? characteristic;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      try {
        stickerController.availableDevices.clear();
        stickerController.selectedIndex = -1;
        stickerController.isPermissionGranted.value = false;
        disconnectAll();
        await call();
      } catch (e) {
        debugPrint("Error in bluetooth connectivity");
      }
    });
  }

  call() async {
    if (await FlutterBluePlus.isSupported == false) {
      debugPrint("Bluetooth not supported by this device");
      MyToast.myShowToast("Bluetooth is not supported on this device");
      return;
    } else {
      debugPrint("Bluetooth is supported");
    }

    var subscription = FlutterBluePlus.adapterState
        .listen((BluetoothAdapterState state) async {
      debugPrint("state - $state");
      if (state == BluetoothAdapterState.on) {
        Permission bluetoothScanPermission = Permission.bluetoothScan;
        Permission bluetoothPermission = Permission.bluetooth;
        Permission bluetoothConnect = Permission.bluetoothConnect;

        if (await bluetoothPermission.isGranted &&
            await bluetoothScanPermission.isGranted &&
            await bluetoothConnect.isGranted) {
          debugPrint("Bluetooth Permission Granted");
          stickerController.isPermissionGranted.value = true;
          scanAvailableDevices();
        } else {
          await bluetoothPermission.request();
          await bluetoothScanPermission.request();
          await bluetoothConnect.request();
          stickerController.isPermissionGranted.value = false;
        }
      } else {
        Permission bluetoothScanPermission = Permission.bluetoothScan;
        Permission bluetoothPermission = Permission.bluetooth;
        Permission bluetoothConnect = Permission.bluetoothConnect;

        if (await bluetoothPermission.isGranted &&
            await bluetoothScanPermission.isGranted &&
            await bluetoothConnect.isGranted) {
          debugPrint("Bluetooth Permission Granted");
          if (Platform.isAndroid) {
            await FlutterBluePlus.turnOn();
          }
        } else {
          await bluetoothPermission.request();
          await bluetoothScanPermission.request();
          await bluetoothConnect.request();
        }
      }
    });

    // subscription.cancel();
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
            children: [Text("Bluetooth")],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  call();
                },
                icon: const Icon(Icons.bluetooth))
          ],
        ),
        body: RefreshIndicator(
            color: Colors.deepOrange.shade500,
            backgroundColor: Colors.black,
            onRefresh: refresh,
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            child: stickerController.isPermissionGranted.value
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Available Devices",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            // height: MediaQuery.sizeOf(context).height*0.60,
                            padding: const EdgeInsets.all(10.0),
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
                            child: Obx(() {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount:
                                    stickerController.availableDevices.length,
                                itemBuilder: (context, index) {
                                  var device = stickerController
                                      .availableDevices[index].device;
                                  var deviceName =
                                      device.advName.toString().isEmpty
                                          ? "Device ${index + 1}"
                                          : device.advName;
                                  return GestureDetector(
                                    onTap: () async {
                                      debugPrint(
                                          "Trying to connect to $deviceName");
                                      stickerController.selectedIndex = index;
                                      connectToDevice(device);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 3,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                        title: Text(
                                          deviceName,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          device.advName.toString(),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.bluetooth,
                                          color:
                                              stickerController.selectedIndex ==
                                                      index
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ))
                : Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    color: Colors.white,
                    child: Container(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("Permission Not Granted")],
                      ),
                    ))),
        // bottomNavigationBar: Container(
        //   height: MediaQuery.sizeOf(context).height*.05,
        //   width: MediaQuery.sizeOf(context).width,
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       InkWell(
        //         onTap: () async {
        //           // print("Loading Calling");
        //           // Dialogs.lottieLoading(context, "assets/lottiee/bluetooth.json");
        //           // print("Loading Working");
        //
        //
        //           // Get.to(const ScanPrinters());
        //         },
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Container(
        //             height: 50,
        //             // padding:const  EdgeInsets.only(
        //             //     left: 22,
        //             //     top: 10,
        //             //     bottom: 10,
        //             //     right: 20
        //             // ),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               gradient: LinearGradient(
        //                   colors: [Colors.deepOrange.shade500,Colors.deepOrange],
        //                   begin: Alignment.topLeft,
        //                   end: Alignment.bottomCenter
        //               ),),
        //             child: const Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 Text("Print",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
        //                 SizedBox(width: 15),
        //                 // Icon(Icons.arrow_forward,color: Colors.white,),
        //
        //               ],
        //             ),
        //
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      );
    });
  }

  void disconnectAll() async {
    debugPrint("Checking if already connected, if yes disconnectiong all");
    List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
    // bool isAlreadyConnected = connectedDevices.any((d) => d.id == r.device.id);
    for (int i = 0; i < connectedDevices.length; i++) {
      await connectedDevices[i].disconnect();
    }
    debugPrint("Disconnected All Devices");
  }

  void scanAvailableDevices() async {
    try {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      debugPrint("Scanning for 4 seconds");
      var subscription = FlutterBluePlus.onScanResults.listen(
        (results) {
          if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            debugPrint(
                'Device found ${r.device.remoteId}: "${r.advertisementData.advName}" found!');

            if (r.advertisementData.advName.isNotEmpty) {
              if (!stickerController.availableDevices.contains(r)) {
                stickerController.availableDevices.add(r);
              }
            }
            stickerController.availableDevices.add(r);
            debugPrint("Added");
          }
        },
        onError: (e) => debugPrint("error: $e"),
      );

      FlutterBluePlus.cancelWhenScanComplete(subscription);
    } catch (e) {
      debugPrint("Error while scanning bluetooth");
    }
  }

  // void scanAvailableDevices()  async {
  // try{
  //   BluetoothState state = await flutterBlue.state.first;
  //   if (state != BluetoothState.on) {
  //     debugPrint("Bluetooth off");
  //     MyToast.myShowToast("Please Turn On your bluetooth");
  //   }
  //   else{
  //     MyToast.myShowToast("Please Wait while Scanning");
  //     flutterBlue.startScan(timeout: const Duration(seconds: 4 ));
  //     var subscription = flutterBlue.scanResults.listen((results) async {
  //       // do something with scan results
  //       for (ScanResult r in results) {
  //         debugPrint('${r.device.name} ${r.device.id} found! rssi: ${r.rssi}');
  //         if(r.device.name.isNotEmpty ){
  //           // ScanResult temp = printController.availableDevices.firstWhere((element) => element.device.id == r.device.id);
  //           if(!stickerController.availableDevices.contains(r)){
  //             stickerController.availableDevices.add(r);
  //           }
  //         }
  //       }
  //     });
  //     flutterBlue.stopScan();
  //     MyToast.myShowToast("Scan Complete");
  //   }
  // }
  // catch (e){
  //   debugPrint("Error while scaaning available bluetooth devices");
  // }
  // }

  // void connectToDevice(BluetoothDevice device) async {
  //   Dialogs.lottieLoading(context, "assets/lottiee/bluetooth.json");
  //   await device.connect();
  //   setState(() {
  //     connectedDevice = device;
  //   });
  //
  //   discoverServices(device);
  // }

  Future<void> refresh() async {
    debugPrint("Refreshing");
    stickerController.availableDevices.clear();
    disconnectAll();
    scanAvailableDevices();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      debugPrint("Trying......");
      Dialogs.lottieLoading(context, "assets/lottiee/bluetooth.json");
      await device.connect();

      // listen for disconnection
      var subscription =
          device.connectionState.listen((BluetoothConnectionState state) async {
        Get.find<StickerController>().connectionStatus.value = state;
        if (state == BluetoothConnectionState.connected) {
          debugPrint("Connected to ${device.advName}");
          stickerController.isPrinterConnected.value = true;
          connectedDevice = device;
          stickerController.isBluetoothConnected.value = true;
          discoverServices(device);
        }
        if (state == BluetoothConnectionState.disconnected) {
          // 1. typically, start a periodic timer that tries to
          //    reconnect, or just call connect() again right now
          // 2. you must always re-discover services after disconnection!
          debugPrint(
              "Disconnected ${device.disconnectReason?.code} ${device.disconnectReason?.description}");
        }
      });
    } catch (e) {
      MyToast.myShowToast("Error Connecting to device");
      Navigator.pop(context);
      debugPrint("Error connecting to device: $e");
    }
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      debugPrint("Services -> $service");
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.properties.write) {
          stickerController.characteristic.value = c;
          break;
        }
      }
    }
    Navigator.pop(context);
    Get.back();
  }
}
