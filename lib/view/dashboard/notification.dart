import 'package:abhilaya/controller/notification_controller.dart';
import 'package:abhilaya/model/response_model/notification_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {

  final List<NotificationItem> notifications;

  const NotificationScreen(this.notifications, {super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // var notificationController = Get.find<NotificationController>();
  @override
  void initState() {
    super.initState();
    // notificationController.callNotification();

  }
  @override
  Widget build(BuildContext context) {

    var w = MediaQuery.sizeOf(context).width;
    var h = MediaQuery.sizeOf(context).height;

    /*  if (notificationController.notificationResponse.value == null) {
      return const Center(child: CircularProgressIndicator());
    }*/

    var notifications = widget.notifications;


    return Scaffold(
        body: Container(
          margin: const EdgeInsets.only(left: 12, right: 12,top: 20, bottom: 20),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: w,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0,
                              3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey
                            .withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ Text(notifications[index].title,  style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'fonts')),
                        const SizedBox(height: 3,),
                        Text(notifications[index].body, style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff7A7A7A),
                            fontFamily: 'fonts')),
                        const SizedBox(height: 6,),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Tracking Number: ",  style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontFamily: 'fonts')),
                                    Text(notifications[index].trackingNumber,  style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily: 'fonts')),
                                  ],
                                ),
                                const SizedBox(height: 2,),
                                Row(
                                  children: [
                                    const Text("Warehouse Id: ",style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontFamily: 'fonts')),
                                    Text(notifications[index].warehouseId.toString(),style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily: 'fonts')),
                                  ],
                                ),
                              ],
                            ),
                            Text("12/01/2025 11:11 am" ,style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff7A7A7A),
                                fontFamily: 'fonts')),

                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
          ),
        ),
      appBar: AppBar(centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.deepOrange.shade500,fontSize: 20),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
           Navigator.pop(context);
          },child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 5.w),
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black.withOpacity(0.2))),
              child: Center(
                child: Image.asset(
                  'assets/images/arrow.png',
                  height: 13.h,
                  width: 10.w,
                ),
              ),
            ),
          ),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("Notifications")],
        ),

      ),
      );
  }
}
