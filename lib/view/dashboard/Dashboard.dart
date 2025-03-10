import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/dashboard_controller.dart';
import 'package:abhilaya/controller/force_update_controller.dart';
import 'package:abhilaya/controller/notification_controller.dart';
import 'package:abhilaya/model/response_model/notification_response.dart';
import 'package:abhilaya/utils/dashboard_utils/DashboardDrawer.dart';
import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/delivered_pages/available_deliveries.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/undelivered_pages/undelivered_location.dart';
import 'package:abhilaya/view/dashboard/notification.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/general/general_methods.dart';
import '../../utils/toast.dart';

//TODO: As we have moved to new Dashboard UI, delete unnecessary image assets used in this file from assets folder
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GeneralMethods generalMethods = GeneralMethods();
  var forceUpdate = Get.find<ForceUpdateController>();
  var loginController = Get.find<LoginController>();
  var dashboardController = Get.find<DashboardController>();
  var notificationController = Get.find<NotificationController>();

  call() async {
    dashboardController.driverStatusResponse.value = null;
    await dashboardController.callDashboardApi();
    await dashboardController.callDriverStatusApi();
    await notificationController.callNotification();
    _isOnDuty =    dashboardController.isOnDuty.value
        ? true
        : false;
    dashboardController.toggleCheckbox(dashboardController.isOnDuty.value);
    dashboardController.loading.value = false;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(seconds: 0),
      () async {
        dashboardController.loading.value = true;

        await forceUpdate.getAppVersion(context);
        await call();
      },
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   var forceUpdate = Get.find<ForceUpdateController>();
    //   forceUpdate.getAppVersion(context);
    //   call();
    //   dashboardController.loading.value = true;
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //   ]);
  // }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    dashboardController.timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  bool _isOnDuty = false;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<NotificationItem> notifications = [];
        if (notificationController.notificationResponse.value != null) {
          notifications =
              notificationController.notificationResponse.value!.notifications;
        }
        return PopScope(
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
                          title: const Text('Hey User'),
                          content: const Text('Are you sure you want to exit?'),
                          actions: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.deepOrange.shade500),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.deepOrange.shade500),
                                onPressed: () {
                                  // Get.offAll(LoginPage());
                                  exit(0);
                                },
                                child: const Text('Exit')),
                          ],
                        ),
                      ));
              return;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70.h,
              backgroundColor: Color(0xFFFF9B55),
              leadingWidth: 120.w, // Space for the left-side logo
              leading: Transform.translate(
                offset: const Offset(10, 0),
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Image.asset(
                    "assets/images/abhi_logo.png",
                    height: 60,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
              title: Center(
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Obx(() {
                            return Text(
                              dashboardController.isOnDuty.value
                                  ?   _formatDuration(
                                  dashboardController.workingTime.value) :  '00:00:00',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }),
                          Obx(() {
                            return Text(
                              dashboardController.isOnDuty.value
                                  ? "On Duty Since"
                                  : "Off Duty",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 15.w,
                  ),
                  child: Container(
                    width: 98.w,
                    child: Center(
                      child: AnimatedToggleSwitch.dual(
                        height: 32.h,
                        indicatorSize: Size(28.w, 28.h),
                        style: ToggleStyle(
                          backgroundColor: Color(0xFFE5E5EA),
                          indicatorColor: Colors.white,
                          indicatorBoxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              spreadRadius: 0,
                              blurRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          indicatorBorder: Border.all(
                            color: Colors.black.withOpacity(0.04),
                            width: 0.5,
                          ),
                          borderColor: Colors.white,
                        ),
                        current: _isOnDuty,
                        borderWidth: 1,
                        first: false,
                        second: true,
                        onChanged: (value) async {
                          setState(() {
                            _isOnDuty = value;
                          });

                          if (loginController.connectionStatus.value ==
                              "ConnectivityResult.none") {
                            await generalMethods.initConnectivity();
                          } else {
                            if (value) {
                              await Dialogs.locationPermissionDialog(context);
                              debugPrint(
                                  "Duty ${dashboardController.isOnDuty.value}");
                              if (dashboardController.isLocationFetched.value) {
                                await dashboardController.callDutyStatusApi();
                                if (dashboardController.isDutyFetched.value) {
                                  await dashboardController
                                      .callDriverStatusApi();
                                }
                              }
                            } else {
                              dashboardController.isOnDuty.value = value;
                              debugPrint(
                                  "Duty ${dashboardController.isOnDuty.value}");
                              await dashboardController.callDutyStatusApi();
                            }
                            dashboardController.toggleCheckbox(
                                dashboardController.isOnDuty.value);
                          } _formatDuration(
                              dashboardController.workingTime.value);
                        },
                        textMargin: EdgeInsets.zero,
                        textBuilder: (value) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            value
                                ? Text(
                                    "On Duty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff667085),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : Text(
                                    "Off Duty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff667085),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: (!dashboardController.loading.value)
                ? RefreshIndicator(
                    color: Colors.deepOrange.shade500,
                    backgroundColor: Colors.black,
                    onRefresh: refresh,
                    notificationPredicate: (ScrollNotification notification) {
                      return notification.depth == 1;
                    },
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height,
                        child: ListView(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      color: Colors.white,
                                      margin: EdgeInsets.only(bottom: 5.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h),
                                            child: Text(
                                              "Action",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20.sp,
                                                  color: Color(0xff7A7A7A)),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h, horizontal: 8.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      // Dialogs.updateDialogBox(context);
                                                      // Get.offAll(Dashboard());
                                                      if (loginController.loginResponse!.userTypeId == 2) {
                                                        MyToast.myShowToast(
                                                          "You don't have access to this module as per your user role.",);
                                                      } else {
                                                        MyToast.myShowToast(
                                                          "Service Unavailable as of now");
                                                      }
                                                    },
                                                    child: MainMenuWidgets(
                                                      myIcon: Icons.flight,
                                                      title:
                                                          // "${AppLocalizations.of(context)!.addLeadTitle}",
                                                          "Order Assigned",
                                                      image:
                                                          "assets/images/order_assigned.png",
                                                      color: MyColor.whiteColor,
                                                      description: dashboardController
                                                                      .dashboardResponse
                                                                      .value !=
                                                                  null &&
                                                              dashboardController
                                                                      .dashboardResponse
                                                                      .value!
                                                                      .data !=
                                                                  null
                                                          ? dashboardController
                                                              .dashboardResponse
                                                              .value!
                                                              .data
                                                              .orderAllocated
                                                              .toString()
                                                          : "0",
                                                    )),
                                                GestureDetector(
                                                    onTap: () async {
                                                      // Dialogs.paymentSuccessLottie(context, "assets/lottiee/payment_success.json");
                                                      if (loginController.loginResponse!.userTypeId == 2) {
                                                        MyToast.myShowToast(
                                                          "You don't have access to this module as per your user role.",);
                                                      } else {
                                                        MyToast.myShowToast(
                                                          "Service Unavailable as of now");
                                                      }
                                                    },
                                                    child: MainMenuWidgets(
                                                        myIcon: Icons.warehouse,
                                                        title: "Picked",
                                                        image:
                                                            "assets/images/picked.png",
                                                        description: dashboardController
                                                                        .dashboardResponse
                                                                        .value !=
                                                                    null &&
                                                                dashboardController
                                                                        .dashboardResponse
                                                                        .value!
                                                                        .data
                                                                        .orderPicked !=
                                                                    null
                                                            ? dashboardController
                                                                .dashboardResponse
                                                                .value!
                                                                .data
                                                                .orderPicked
                                                                .toString()
                                                            : "0",
                                                        color: MyColor
                                                            .whiteColor)),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (loginController.loginResponse!.userTypeId == 2) {
                                                        MyToast.myShowToast(
                                                          "You don't have access to this module as per your user role.",);
                                                      } else {
                                                        if (dashboardController
                                                            .isOnDuty.value) {
                                                          if (loginController
                                                                  .connectionStatus
                                                                  .value ==
                                                              "ConnectivityResult.none") {
                                                            await generalMethods
                                                                .initConnectivity();
                                                          } else {
                                                            Get.to(
                                                                const DeliveryList());
                                                          }
                                                        } else {
                                                          MyToast.myShowToast(
                                                              "Kindly Switch on the duty first");
                                                        }
                                                      }
                                                      // Get.to(() => AssetTrackCard());
                                                    },
                                                    child: MainMenuWidgets(
                                                        myIcon: Icons.nightlife,
                                                        title: "Delivered",
                                                        image:
                                                            "assets/images/delivery.png",
                                                        description: dashboardController
                                                                        .dashboardResponse
                                                                        .value !=
                                                                    null &&
                                                                dashboardController
                                                                        .dashboardResponse
                                                                        .value!
                                                                        .data
                                                                        .orderDelivered !=
                                                                    null
                                                            ? dashboardController
                                                                .dashboardResponse
                                                                .value!
                                                                .data
                                                                .orderDelivered
                                                                .toString()
                                                            : "0",
                                                        color: MyColor
                                                            .whiteColor)),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (loginController.loginResponse!.userTypeId == 2) {
                                                      MyToast.myShowToast(
                                                        "You don't have access to this module as per your user role.",);
                                                    } else  {
                                                      if (dashboardController
                                                          .isOnDuty.value) {
                                                        if (loginController
                                                                .connectionStatus
                                                                .value ==
                                                            "ConnectivityResult.none") {
                                                          await generalMethods
                                                              .initConnectivity();
                                                        } else {
                                                          Get.to(() =>
                                                              const UndeliveredLocation());
                                                        }
                                                      } else {
                                                        MyToast.myShowToast(
                                                            "Kindly Switch on the duty first");
                                                      }
                                                    }
                                                  },
                                                  child: MainMenuWidgets(
                                                      myIcon:
                                                          Icons.pan_tool_sharp,
                                                      title:
                                                          // "${AppLocalizations.of(context)!.payReqTitle}",
                                                          "Undelivered ",
                                                      image:
                                                          "assets/images/undelivered.png",
                                                      description: dashboardController
                                                                      .dashboardResponse
                                                                      .value !=
                                                                  null &&
                                                              dashboardController
                                                                      .dashboardResponse
                                                                      .value!
                                                                      .data
                                                                      .orderUnDelivered !=
                                                                  null
                                                          ? dashboardController
                                                              .dashboardResponse
                                                              .value!
                                                              .data
                                                              .orderUnDelivered
                                                              .toString()
                                                          : "0",
                                                      color:
                                                          MyColor.whiteColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.h, horizontal: 9.w),
                                      color: const Color(0xffF9F9F9),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          TodayShipmentWidget(
                                              title: "Today Prepaid Shipments",
                                              image:
                                                  "assets/images/prepaid_shipments.png",
                                              value:
                                                  "${dashboardController.dashboardResponse.value != null && dashboardController.dashboardResponse.value!.data != null ? dashboardController.dashboardResponse.value!.data.todayPrepaidShipments.toString() : "0"}\nItems"),
                                          TodayShipmentWidget(
                                              title: "Today CODs Shipments",
                                              image:
                                                  "assets/images/cod_shipments.png",
                                              value:
                                                  "${dashboardController.dashboardResponse.value != null && dashboardController.dashboardResponse.value!.data != null ? dashboardController.dashboardResponse.value!.data.todayCodShipments.toString() : "0"}\nItems"),
                                          TodayShipmentWidget(
                                              title: "Today's Earning",
                                              image:
                                                  "assets/images/earning.png",
                                              value:
                                                  "₹\n${dashboardController.dashboardResponse.value != null && dashboardController.dashboardResponse.value!.data != null ? dashboardController.dashboardResponse.value!.data.todayCodAmountCollected.toInt().toString() : "0"}"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.h, horizontal: 9.w),
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.h,
                                                    horizontal: 2.w),
                                                isLabelVisible:
                                                    notifications.isNotEmpty
                                                        ? true
                                                        : false,
                                                label: Text(notifications.length
                                                    .toString()),
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10.5.sp,
                                                    color: Colors.white),
                                                textColor: Colors.white,
                                                backgroundColor: Colors.red,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 12.w),
                                                  child: Center(
                                                    child: Text(
                                                      "Notifications",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.sp,
                                                          color: Color(
                                                              0xff7A7A7A)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (notifications.isNotEmpty)
                                                TextButton(
                                                    onPressed: () {if (loginController.loginResponse!.userTypeId == 2) {
                                                      MyToast.myShowToast(
                                                        "You don't have access to this module as per your user role.",);
                                                    } else {
                                                      Get.to(NotificationScreen(
                                                          notifications));
                                                    }
                                                    },
                                                    child: Text(
                                                      "View All",
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color:
                                                              Color(0xFFFF9B55),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                            ],
                                          ),
                                          if (notificationController
                                                  .notificationResponse.value ==
                                              null)
                                            Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          if (notificationController
                                                      .notificationResponse
                                                      .value !=
                                                  null &&
                                              notifications.isEmpty)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 15.h),
                                              child: const Text(
                                                  "No new notifications."),
                                            ),
                                          if (notifications.isNotEmpty)
                                            SizedBox(
                                              height: 110.h *
                                                  (notifications.length > 3
                                                      ? 4
                                                      : (notifications.length +
                                                          1)),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    notifications.length > 3
                                                        ? 3
                                                        : notifications.length,
                                                itemBuilder: (context, index) {
                                                  var notification =
                                                      notifications[index];

                                                  return NotificationWidget(
                                                      notification:
                                                          notification);
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.deepOrange.shade500,
                    color: Colors.transparent,
                    child: Center(
                      child: Lottie.asset(
                        'assets/lottiee/abhi_loading.json',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.height * 0.2,
                      ),
                      // child: CircularProgressIndicator(),
                    ),
                  ),
            drawer: (!dashboardController.loading.value)
                ? const DashboardDrawer()
                : null,
            //   bottomNavigationBar: (!dashboardController.loading.value)
            //       ? BottomNavBar()
            //       /*
            // BottomAppBar(
            //         color: Colors.transparent,
            //         child: SizedBox(
            //           height: MediaQuery.of(context).orientation ==
            //                   Orientation.landscape
            //               ? MediaQuery.sizeOf(context).height * 0.25
            //               : MediaQuery.sizeOf(context).height * 0.10,
            //           // padding: EdgeInsets.symmetric(vertical: 5),
            //           child: Card(
            //             color: Colors.deepOrange.shade500,
            //             elevation: 7,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 buildNavItem(
            //                   label: "Today Prepaid \n Shipment",
            //                   value:
            //                       dashboardController.dashboardResponse.value !=
            //                                   null &&
            //                               dashboardController
            //                                       .dashboardResponse
            //                                       .value!
            //                                       .data
            //                                       .todayPrepaidShipments !=
            //                                   null
            //                           ? dashboardController.dashboardResponse
            //                               .value!.data.todayPrepaidShipments
            //                               .toString()
            //                           : "0",
            //                 ),
            //                 verticalDivider(),
            //                 buildNavItem(
            //                   label: "Today CODs \nShipment",
            //                   value:
            //                       dashboardController.dashboardResponse.value !=
            //                                   null &&
            //                               dashboardController
            //                                       .dashboardResponse
            //                                       .value!
            //                                       .data
            //                                       .todayCodShipments !=
            //                                   null
            //                           ? dashboardController.dashboardResponse
            //                               .value!.data.todayCodShipments
            //                               .toString()
            //                           : "0",
            //                 ),
            //                 verticalDivider(),
            //                 buildNavItem(
            //                   label: "Today's\n Earning",
            //                   value: dashboardController
            //                                   .dashboardResponse.value !=
            //                               null &&
            //                           dashboardController.dashboardResponse.value!
            //                                   .data.codAmountCollected !=
            //                               null
            //                       ? " ₹ ${dashboardController.dashboardResponse.value!.data.todayCodAmountCollected.toString()} "
            //                       : "0",
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            // */
            //       : Container(
            //           height: 0,
            //         ),
          ),
        );
      },
    );
  }

  Widget verticalDivider() {
    return Container(
      height: 35,
      width: 1,
      color: Colors.black,
    );
  }

  Widget buildNavItem({required String label, required String value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 2),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Flexible(
          child: Text(
            value.isEmpty ? "0" : value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> refresh() async {
    debugPrint("Refreshing");
    await forceUpdate.getAppVersion(context);
    await dashboardController.callDashboardApi();
    await dashboardController.callDriverStatusApi();
    await dashboardController.callDriverStatusApi();
  }

  lottieLoading(BuildContext context) {
    call();
    return Container(
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
    );
  }
}

class MyColor {
  static String ox = "0xff";
  static int whiteColor = int.parse('${ox}FFFFFF');
  static int petrolBlue = int.parse('${ox}144473');
  static int boxShadowLight = int.parse('0xff144473');
  static int idCardGreen = int.parse('0xff3d9c4c');
  static int grey = int.parse('0xffa4cd39');
}

class MainMenuWidgets extends StatelessWidget {
  const MainMenuWidgets({
    super.key,
    required this.myIcon,
    required this.title,
    required this.image,
    required this.description,
    required this.color,
  });

  final IconData myIcon;
  final String title;
  final String image;
  final String description;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        border: Border.all(
          color: Color(0xffE7E5ED),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xffE7E5ED).withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4, // changes position of shadow
          ),
        ],
      ),
      height: 80.h,
      width: 78.w,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 4,
              child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    image,
                    height: 28.h,
                    width: 28.w,
                    fit: BoxFit.fill,
                    // color: Color(MyColor.petrolBlue),
                  ))),
          Expanded(
              flex: 3,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontFamily: 'fonts'),
              )),
          Expanded(
              flex: 3,
              child: Text(
                "$description Items",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff7A7A7A),
                    fontFamily: 'fonts'),
              )),
        ],
      ),
    );
  }
}

class TodayShipmentWidget extends StatelessWidget {
  const TodayShipmentWidget({
    super.key,
    required this.title,
    required this.image,
    required this.value,
  });

  final String title;
  final String image;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        border: Border.all(
          color: Color(0xffE7E5ED),
          width: 1,
        ),
      ),
      margin: EdgeInsets.only(bottom: 8.w),
      padding: EdgeInsets.all(8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: Color(0xFFFF9B55).withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(8.sp)),
            ),
            child: Center(
              child: Image.asset(
                image,
                height: 40.h,
                width: 40.w,
                fit: BoxFit.fill,
                // color: Color(MyColor.petrolBlue),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'fonts'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Color(0xffE7E5ED),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                    ),
                    width: 45.w,
                    height: 45.h,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontFamily: 'fonts'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.notification,
  });

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          margin: EdgeInsets.only(bottom: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sp),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF4735E2).withOpacity(0.05),
                spreadRadius: 0,
                blurRadius: 3.77,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(notification.title,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'fonts')),
                  InkWell(
                      onTap: () {
                        // Get.to(const NotificationScreen());
                      },
                      child: Text(
                        "View",
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Color(0xFFFF9B55),
                            fontWeight: FontWeight.w400),
                      )),
                ],
              ),
              Text(notification.body,
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff7A7A7A),
                      fontFamily: 'fonts')),
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Tracking Number: ",
                            style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontFamily: 'fonts')),
                        Text(notification.trackingNumber,
                            style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'fonts')),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Warehouse Id: ",
                            style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontFamily: 'fonts')),
                        Text(notification.warehouseId.toString(),
                            style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'fonts')),
                      ],
                    ),
                    Flexible(
                      child: Text("12/01/2025 11:11 am",
                          style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff7A7A7A),
                              fontFamily: 'fonts')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
