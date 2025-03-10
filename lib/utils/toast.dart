import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class MyToast{

  static Future<bool?> myShowToast(String text) {
    return Fluttertoast.showToast(
      msg: text,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,toastLength: Toast.LENGTH_SHORT,
      backgroundColor:Colors.black,
      textColor: Colors.white,
    );
  }
  static Future<bool?> myShowToast2(String text) {
    return Fluttertoast.showToast(
      msg: text,toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 12.0,
      backgroundColor:Colors.black,
      textColor: Colors.white,
    );
  }
  static Future<bool?> myShowToast3(String text) {
    return Fluttertoast.showToast(
      msg: text,
      gravity: ToastGravity.TOP,
      fontSize: 16.0,toastLength: Toast.LENGTH_SHORT,
      backgroundColor:Colors.black,
      textColor: Colors.white,
    );
  }
}