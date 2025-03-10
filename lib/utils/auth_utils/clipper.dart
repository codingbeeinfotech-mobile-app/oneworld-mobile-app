import 'package:flutter/cupertino.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width*0.8960000,size.height*0.1020000);
    path.quadraticBezierTo(size.width*0.5485000,size.height*0.2785000,size.width*0.5210000,size.height*0.3660000);
    path.cubicTo(size.width*0.5182500,size.height*0.4320000,size.width*0.5397500,size.height*0.9470000,size.width*0.5460000,size.height*0.9840000);
    path.cubicTo(size.width*0.6250000,size.height*1.0085000,size.width*0.9350000,size.height*0.9055000,size.width*0.9990000,size.height*0.9880000);
    path.quadraticBezierTo(size.width*0.9990000,size.height*0.9260000,size.width*0.9990000,size.height*0.1000000);

    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
