import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:abhilaya/controller/drawer_routes_controller/returnpickup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  var returnPickUpController = Get.find<ReturnPickupController>();
  void showImagePickerOption(Rx<Uint8List?> imageBytes, Rx<File?> selectedImage,
      BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                30), // Set border radius for the container
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          pickImageFromGallery(imageBytes, selectedImage);
                          Navigator.of(context).pop();
                        },
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 25),
                            SizedBox(height: 5),
                            Text('Add image from Gallery',
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          await pickImageFromCamera(imageBytes, selectedImage);
                          Navigator.of(context).pop();
                        },
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera, size: 25),
                            SizedBox(height: 5),
                            Text('Click from camera',
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future pickImageFromGallery(
      Rx<Uint8List?> imageBytes, Rx<File?> selectedImage) async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    selectedImage.value = File(returnImage.path);
    imageBytes.value = File(returnImage.path).readAsBytesSync();

    if (returnPickUpController.isReturnPickupImage.value) {
      Rx<Int8List?> productImageIntList = Int8List(0).obs;
      productImageIntList.value = Int8List.fromList(imageBytes.value!.toList());

      returnPickUpController.productImageIntList.add(productImageIntList.value);
      returnPickUpController.productImageList.add(imageBytes.value!);

      var imgUrl = "";
      imgUrl = base64Encode(imageBytes.value!.toList());

      returnPickUpController.productImageBase64List.add(imgUrl);
      debugPrint("IMG URL : $imgUrl");
    }
  }

  Future pickImageFromCamera(
      Rx<Uint8List?> imageBytes, Rx<File?> selectedImage) async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    selectedImage.value = File(returnImage.path);
    imageBytes.value = File(returnImage.path).readAsBytesSync();

    if (returnPickUpController.isReturnPickupImage.value) {
      Rx<Int8List?> productImageIntList = Int8List(0).obs;
      productImageIntList.value = Int8List.fromList(imageBytes.value!.toList());

      returnPickUpController.productImageIntList.add(productImageIntList.value);
      returnPickUpController.productImageList.add(imageBytes.value!);

      var imgUrl = "";
      imgUrl = base64Encode(imageBytes.value!.toList());

      returnPickUpController.productImageBase64List.add(imgUrl);

      debugPrint("IMG URL : $imgUrl");
    }

    // return imageBytes;
  }
}
