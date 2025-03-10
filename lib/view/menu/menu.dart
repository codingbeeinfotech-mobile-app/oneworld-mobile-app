import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/controller/auth_controller/logout_controller.dart';
import 'package:abhilaya/controller/dashboard_controller.dart';
import 'package:abhilaya/utils/general/general_methods.dart';
import 'package:abhilaya/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:abhilaya/view/drawer_routes/insurance_details.dart';
import 'package:abhilaya/view/drawer_routes/print_sticker_scan_tracking_number.dart';
import 'package:abhilaya/view/drawer_routes/return_pickup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/toast.dart';
import '../drawer_routes/ndr_delivery.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var controller = Get.find<NavigationController>();

  var loginController = Get.find<LoginController>();
  GeneralMethods generalMethods = GeneralMethods();
  var dashboardController = Get.find<DashboardController>();
  var logOutController = Get.find<LogoutController>();
  // {"UserName":"D1097","UserId":"1003",
  // "MobileNo":"7021692009","ClientId":"1",
  // "ClientName":"One world","CompanyId":"2",
  // "WareHouseId":"11","RoleId":"1","FlagMsg":"Login Successfully done.","IsLogin":"0"}
//{ClientId: 1, ClientName: One world, CompanyId: 2, DriverId: 1003, VendorId: , WarehouseId: 11}
  //{Result: {Flag: true, FlagMessage: Duty found, CurrentStatus: On},
  // Data: [{Duty: On, DriverId: D1097, DriverName: BHARAT ONKAR DHIWAR,
  // TotalTime: 4:45:34, EntryDate: 23 Jan 25, EntryTime: 10:18:28,
  // Latitude: 28.7227859, Longitude: 77.2647247}]}
  @override
  void initState() {
    super.initState();

/*    Future.delayed(
      Duration(seconds: 0),
      () async {
        await call();
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          right: false,
          left: false,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 12.w),
                color: Color(0xffFF9B55),
                height: 155.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.transparent,
                            size: 25.h,
                          ),
                          onPressed: () async {},
                        ),
                        Container(
                          height: 68.h,
                          width: 68.w,
                          child: CircleAvatar(
                            radius: 34.sp,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              "assets/images/user_icon.png",
                              height: 32.29.h,
                              width: 28.25.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 25.h,
                          ),
                          onPressed: () async {
                            await logOutController.callLogoutApi(context);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.sp),
                      child: Column(
                        children: [
                          Text(
                            "Hello!",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            dashboardController.driverStatusResponse.value !=
                                    null
                                ? dashboardController.driverStatusResponse
                                    .value!.data!.first.driverName!
                                : loginController.loginResponse!.cLIENTNAME!,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                          Text(
                            "ID: ${dashboardController.driverStatusResponse.value != null ? dashboardController.driverStatusResponse.value!.data!.first.driverId : loginController.loginResponse!.uSERID}",
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 8.w,
                children: [
                  MenuGridWidget(
                    dashboardController: dashboardController,
                    generalMethods: generalMethods,
                    loginController: loginController,
                    index: 0,
                    title: "Duty's",
                    image: "assets/images/duties.png",
                  ),
                  if (loginController.loginResponse!.userTypeId != 7)
                    MenuGridWidget(
                      dashboardController: dashboardController,
                      generalMethods: generalMethods,
                      loginController: loginController,
                      index: 1,
                      title: "NDR Delivery",
                      image: "assets/images/ndr_delivery.png",
                    ),
                  MenuGridWidget(
                    dashboardController: dashboardController,
                    generalMethods: generalMethods,
                    loginController: loginController,
                    index: 2,
                    title: "Return Pickup",
                    image: "assets/images/returnPickup.png",
                  ),
                  MenuGridWidget(
                    dashboardController: dashboardController,
                    generalMethods: generalMethods,
                    loginController: loginController,
                    index: 3,
                    title: "Print Sticker",
                    image: "assets/images/print_sticker.png",
                  ),
                  MenuGridWidget(
                    dashboardController: dashboardController,
                    generalMethods: generalMethods,
                    loginController: loginController,
                    index: 4,
                    title: "Insurance Detail",
                    image: "assets/images/insurance_detail.png",
                  ),
                  MenuGridWidget(
                    dashboardController: dashboardController,
                    generalMethods: generalMethods,
                    loginController: loginController,
                    index: 5,
                    title: "Statements & Reports",
                    image: "assets/images/statement_reports.png",
                  ),
                ],
              ),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Your Earning",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily: 'fonts'),
                                ),
                                Text(
                                  "Today, ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily: 'fonts'),
                                ),
                              ],
                            ),
                            Text(
                              "₹${dashboardController.dashboardResponse.value!.data.codAmountCollected}",
                              style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff019E6F),
                                  fontFamily: 'fonts'),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          MenuCardWidget(
                              title: "Incentives",
                              subtitle: "Earn more with Abhilaya incentives",
                              additionInfo: "5 more task to ₹500",
                              image: "assets/images/incentives.png"),
                          MenuCardWidget(
                              title: "Weekly Overview",
                              subtitle:
                                  "Your earning across this week and beyond.",
                              additionInfo: "₹1500 Till Now",
                              image: "assets/images/weekly_overview.png"),
                          MenuCardWidget(
                              title: "Payouts",
                              subtitle: "Get paid every week on Monday",
                              additionInfo: "Paid on Mon, 13 Jan",
                              image: "assets/images/payouts.png"),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavBar()
    );
  }
}

class MenuGridWidget extends StatelessWidget {
  MenuGridWidget({
    super.key,
    required this.index,
    required this.title,
    required this.image,
    required this.generalMethods,
    required this.loginController,
    required this.dashboardController,
  });
  GeneralMethods generalMethods;
  LoginController loginController;
  DashboardController dashboardController;

  final int index;
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        switch (index) {
          case 0:
            MyToast.myShowToast("Duty's");
          case 1:

              if (dashboardController.isOnDuty.value) {
                if (loginController.connectionStatus.value ==
                    "ConnectivityResult.none") {
                  await generalMethods.initConnectivity();
                } else {
                  Get.to(NDRDelivery());
                }
              } else {
                MyToast.myShowToast("Kindly Switch on the duty first");
              }

          case 2: if (loginController.loginResponse!.userTypeId == 2) {
            MyToast.myShowToast(
                "You don't have access to this module as per your user role.",);
          } else {
            if (dashboardController.isOnDuty.value) {
              if (loginController.connectionStatus.value ==
                  "ConnectivityResult.none") {
                await generalMethods.initConnectivity();
              } else {
                Get.to(const ReturnPickup());
              }
            } else {
              MyToast.myShowToast("Kindly Switch on the duty first");
            }  }
          case 3:if (loginController.loginResponse!.userTypeId == 2) {
            MyToast.myShowToast(
                "You don't have access to this module as per your user role.");
          } else {
            if (dashboardController.isOnDuty.value) {
              if (loginController.connectionStatus.value ==
                  "ConnectivityResult.none") {
                await generalMethods.initConnectivity();
              } else {
                Get.to(const ScanTrackingNumber());
              }
            } else {
              MyToast.myShowToast("Kindly Switch on the duty first");
            }
            }
          case 4:if (loginController.loginResponse!.userTypeId == 2) {
            MyToast.myShowToast(
                "You don't have access to this module as per your user role.");
          } else {
            if (dashboardController.isOnDuty.value) {
              if (loginController.connectionStatus.value ==
                  "ConnectivityResult.none") {
                await generalMethods.initConnectivity();
              } else {
                Get.to(const InsuranceDetails());
              }
            } else {
              MyToast.myShowToast("Kindly Switch on the duty first");
            }
            }
          case 5:
            MyToast.myShowToast("Statements & Reports");
        }
      },
      child: Column(
        children: [
          Container(
            height: 96.h,
            margin: EdgeInsets.only(top: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.sp),
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
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
            width: 105.33.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  image,
                  height: 40.h,

                  // color: Color(MyColor.petrolBlue),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff7A7A7A),
                            fontFamily: 'fonts',
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 12.w,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCardWidget extends StatelessWidget {
  const MenuCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.additionInfo,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String additionInfo;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0.sp),
        boxShadow: [
          BoxShadow(
            color: Color(0xffE7E5ED).withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4, // changes position of shadow
          ),
        ],
        border: Border.all(
          color: Color(0xFFE7E5ED),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'fonts'),
              ),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff7A7A7A),
                    fontFamily: 'fonts'),
              ),
              Text(
                additionInfo,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFF9B55),
                    fontFamily: 'fonts'),
              ),
            ],
          ),
          Image.asset(
            image,
            height: 64.h,
            width: 64.w,
            fit: BoxFit.fill,
            // color: Color(MyColor.petrolBlue),
          ),
        ],
      ),
    );
  }
}
