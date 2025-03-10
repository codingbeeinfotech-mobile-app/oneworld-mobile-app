import 'package:abhilaya/controller/auth_controller/login_controller.dart';
import 'package:abhilaya/view/dashboard/Dashboard.dart';
import 'package:abhilaya/view/dashboard/dashboard_routes/delivered_pages/available_deliveries.dart';
import 'package:abhilaya/view/drawer_routes/npr_shipments.dart';
import 'package:abhilaya/view/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../drawer_routes/bulk_pick_up.dart';

class NavigationController extends GetxController {
  var index = Rxn<int>();
  var lastIndex = Rxn<int>();
  changeIndex({required int selectedIndex}) {
    lastIndex.value = index.value;
    print("last index ${lastIndex.value}");
    index.value = selectedIndex;
  }
}

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var controller = Get.find<NavigationController>();
  var loginController = Get.find<LoginController>();

  RxList<Widget> pages = [
    Dashboard(),
    BulkPickUp(),
    DeliveryList(),
    NprShipments(),
    Menu(),
  ].obs;

  late double deviceWidth;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      controller.changeIndex(selectedIndex: 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Obx(() => pages[controller.index.value ?? 0]),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        width: deviceWidth,
        height: 80.h,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE6EBF3).withOpacity(0.5),
                offset: Offset(0, -10.45),
                blurRadius: 32.22,
                spreadRadius: 0.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(13.6))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            bottomNavBarTile(
              image: "assets/images/dashboard.png",
              index: 0,
              title: 'Dashboard',
            ),
            bottomNavBarTile(
              image: "assets/images/bulkpickup_navitem.png",
              index: 1,
              title: 'Bulk Pickup',
            ),
            bottomNavBarTile(
              image: "assets/images/delivery_navitem.png",
              index: 2,
              title: 'Delivery',
            ),
            bottomNavBarTile(
              image: "assets/images/ndr_shipments.png",
              index: 3,
              title: 'NPR Shipments',
            ),
            bottomNavBarTile(
              image: "assets/images/menu.png",
              index: 4,
              title: 'Menu',
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNavBarTile({
    required int index,
    required String title,
    required String image,
  }) {
    var controller = Get.find<NavigationController>();

    return GestureDetector(
      onTap: () {
        setState(() {
          controller.changeIndex(selectedIndex: index);
        });
      },
      child: Obx(
        () => Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              top: 18.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  color: (controller.index.value == index)
                      ? Color(0xFFFF9B55)
                      : Color(0xff7A7A7A),
                  image,
                  height: 22.5.h,
                  width: 22.5.w,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: (controller.index.value == index)
                            ? Color(0xFFFF9B55)
                            : Color(0xFF7A7A7A),
                        fontSize: 10.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
