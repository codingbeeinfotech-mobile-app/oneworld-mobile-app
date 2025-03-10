import 'package:flutter/material.dart';

class CustomLoader{

  static Future<dynamic> circularLoading(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            height: 70,
            width: 70,
            child: CircularProgressIndicator(
              color: Colors.deepOrange.shade500,
            ),
          );
        });
  }
}