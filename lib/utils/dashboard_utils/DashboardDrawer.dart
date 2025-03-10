import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/auth_controller/logout_controller.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/undelivered_pages/undelivered_location.dart';
import 'package:abhilaya/view/drawer_routes/bulk_pick_up.dart';
import 'package:abhilaya/view/drawer_routes/insurance_details.dart';
import 'package:abhilaya/view/drawer_routes/ndr_delivery.dart';
import 'package:abhilaya/view/drawer_routes/print_sticker_scan_tracking_number.dart';
import 'package:abhilaya/view/drawer_routes/return_pickup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controller.dart';
import '../../view/dashboard/dashboard_routes/delivered_pages/available_deliveries.dart';
import '../../view/drawer_routes/npr_shipments.dart';
import '../general/alert_boxes.dart';

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({Key? key}) : super(key: key);

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  var loginController = Get.find<LoginController>();
  GeneralMethods generalMethods = GeneralMethods();
  var dashboardController = Get.find<DashboardController>();
  var logOutController = Get.find<LogoutController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.70,
        color: Colors.white,
        child: Column(
          children: [
            // Fixed Logo at the top
            Padding(
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 20, bottom: 10),
              child: Image.asset("assets/images/abhi_logo.png"),
            ),
            const Divider(color: Colors.black, thickness: 1),
            // Scrollable content in the middle
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildDrawerItem(
                      iconPath: "assets/images/dutyon.png",
                      text: "Duty",
                      onTap: () async {
                        Navigator.pop(context);
                        MyToast.myShowToast("Switch your Duty");
                        dashboardController.dutySwitchFocusNode.requestFocus();
                      },
                      switchWidget: Obx(
                        () => Switch(
                          focusNode: dashboardController.dutySwitchFocusNode,
                          value: dashboardController.isOnDuty.value,
                          activeTrackColor: Colors.black,
                          activeColor: Colors.grey,
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          onChanged: (isCheck) async {
                            if (loginController.connectionStatus.value ==
                                "ConnectivityResult.none") {
                              await generalMethods.initConnectivity();
                            } else {
                              if (isCheck) {
                                await Dialogs.locationPermissionDialog(context);
                                if (dashboardController
                                    .isLocationFetched.value) {
                                  await dashboardController.callDutyStatusApi();
                                  if (dashboardController.isDutyFetched.value) {
                                    await dashboardController
                                        .callDriverStatusApi();
                                  }
                                }
                              } else {
                                dashboardController.isOnDuty.value = isCheck;
                                await dashboardController.callDutyStatusApi();
                              }
                              dashboardController.toggleCheckbox(
                                  dashboardController.isOnDuty.value);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildDrawerItem(
                      iconPath: "assets/images/bulkpickup.png",
                      text: "Bulk Pickup",
                      onTap: () async {
                        if (dashboardController.isOnDuty.value) {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            Navigator.pop(context);
                            Get.to(const BulkPickUp());
                          }
                        } else {
                          MyToast.myShowToast(
                              "Kindly Switch On the duty first");
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // buildDrawerItem(
                    //   iconPath: "assets/images/picking.png",
                    //   text: "Picking",
                    //   onTap: () {
                    //     MyToast.myShowToast("This Option is Not available as of Now");
                    //   },
                    // ),
                    // const SizedBox(height: 10),
                    buildDrawerItem(
                      iconPath: "assets/images/deliveryIcon.png",
                      text: "Delivery",
                      onTap: () async {
                        if (dashboardController.isOnDuty.value) {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            Navigator.pop(context);
                            Get.to(const DeliveryList());
                          }
                        } else {
                          MyToast.myShowToast(
                              "Kindly Switch on the duty first");
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    buildDrawerItem(
                      iconPath: "assets/images/deliveryIcon.png",
                      text: "NPR Shipments",
                      onTap: () async {
                        if (dashboardController.isOnDuty.value) {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            Navigator.pop(context);
                            Get.to(NprShipments());
                          }
                        } else {
                          MyToast.myShowToast(
                              "Kindly Switch on the duty first");
                        }
                        // Get.to(NprShipments());
                      },
                    ),
                    const SizedBox(height: 10),
                    buildDrawerItem(
                      iconPath: "assets/images/deliveryIcon.png",
                      text: "NDR Delivery",
                      onTap: () async {
                        if (dashboardController.isOnDuty.value) {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            Navigator.pop(context);
                            Get.to( NDRDelivery());
                          }
                        } else {
                          MyToast.myShowToast(
                              "Kindly Switch on the duty first");
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    buildDrawerItem(
                      iconPath: "assets/images/insurance.png",
                      text: "Insurance Detail",
                      onTap: () async {
                        if (dashboardController.isOnDuty.value) {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            Get.to(const InsuranceDetails());
                          }
                        } else {
                          MyToast.myShowToast(
                              "Kindly Switch on the duty first");
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    buildDrawerItem(
                      iconPath: "assets/images/returnPickup.png",
                      text: "Return Pickup",
                      onTap: () async {
                        if (dashboardController.isOnDuty.value) {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            Navigator.pop(context);
                            Get.to(const ReturnPickup());
                          }
                        } else {
                          MyToast.myShowToast(
                              "Kindly Switch on the duty first");
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    buildDrawerItem(
                      iconPath: "assets/images/print.png",
                      text: "Print Sticker",
                      onTap: () async {
                        if (dashboardController.isOnDuty.value) {
                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            Navigator.pop(context);
                            Get.to(const ScanTrackingNumber());
                          }
                        } else {
                          MyToast.myShowToast(
                              "Kindly Switch on the duty first");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Fixed Logout at the bottom
            Column(
              children: [
                const Divider(color: Colors.black45, thickness: 2),
                InkWell(
                  onTap: () async {
                    await logOutController.callLogoutApi(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.logout,
                              color: Colors.deepOrange.shade500),
                        ),
                        const SizedBox(width: 10),
                        const Text("LogOut"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(
      {required String iconPath,
      required String text,
      required VoidCallback onTap,
      Widget? switchWidget}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(1),
                    child: Image.asset(
                      iconPath,
                      // color:  Color(MyColors.primaryColor),
                      height: 40,
                      width: 40,
                      fit: BoxFit.fitHeight,
                      // color: Color(MyColor.petrolBlue),
                    )),
                const SizedBox(width: 10),
                Text(text),
              ],
            ),
            if (switchWidget != null) switchWidget,
          ],
        ),
      ),
    );
  }
}
