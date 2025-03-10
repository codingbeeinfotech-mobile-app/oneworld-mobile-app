
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/force_update_controller.dart';


class ForceUpdateDialog {
  var count = 0;
  var one = false;

  ForceUpdateController forceUpdateController = Get.find<ForceUpdateController>();


  forceUpdateDialog(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async{
            count++;
            await press(context, count);
          },
          child: Obx(
                () => Visibility(
              visible: forceUpdateController.forceDialogVisibility.value,
              child: AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                content: Builder(
                  builder: (context) {
                    var height = MediaQuery.of(context).size.height / 4;
                    var width = MediaQuery.of(context).size.width - 10;

                    return Container(
                      color: Colors.white,
                      width: width - 20,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height / 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0,
                                  right: 20,
                                  top: 0,
                                  bottom: 20),
                              child: SizedBox(
                                height:
                                MediaQuery.of(context).size.height / 14,
                                child: Image.asset(
                                    "assets/images/app_logo/abhi_logo.png"),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                "You are using older version of Abhilaya .\nKindly Update The App",
                                textScaler: TextScaler.linear(1.0),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 17,
                            ),
                            GestureDetector(
                              onTap: () async {
                                forceUpdateController.forceUpdateCount.value = 1;
                                try {
                                  StoreRedirect.redirect(androidAppId: "com.isourse.abhilaya",iOSAppId: "");
                                } catch (e) {
                                  launchURL(
                                      "https://play.google.com/store/apps/details?id=com.isourse.abhilaya&hl=en_IN${forceUpdateController.packageName.value}");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Card(
                                  elevation: 5.0,
                                  color: Colors.deepOrange.shade500,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    height: 35,
                                    alignment: Alignment.center,
                                    width:
                                    MediaQuery.of(context).size.width -
                                        40,
                                    child: Text(
                                      "Update now",
                                      textScaler: TextScaler.linear(1.0),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 14,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }

  Future<bool> press(BuildContext context, int count) async {
    if (forceUpdateController.appVersion.value != forceUpdateController.apiVersion.value && count >= 2) {
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
                      backgroundColor: Colors.deepOrange.shade500),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade500),
                onPressed: () {
                  exit(0);
                },
                child: const Text('exit'),
              ),
            ],
          ),
        ),
      );
      return true;
    } else {
      return false;
    }
  }
  static launchURL(String uri) async {
    if (await launchUrl( Uri.parse(uri))) {
      launchUrl(Uri.parse(uri));
    } else {
      throw 'Could not launch $uri';
    }
  }

}


