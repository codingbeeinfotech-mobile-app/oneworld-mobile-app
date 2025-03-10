import 'package:abhilaya/utils/general/alert_boxes.dart';
import 'package:abhilaya/view/drawer_routes/insurance_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';

import '../../utils/toast.dart';

class InsuranceDetails extends StatefulWidget {
  const InsuranceDetails({super.key});

  @override
  State<InsuranceDetails> createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
  var printController = Get.find<InsuranceDetailsController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      call();
    });
  }

  call() async {
   // await printController.callGetInsurancePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade500,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("Insurance Details")],
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {});
        //       },
        //       icon: const Icon(Icons.menu))
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "TDS",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buildTDSRow(context, "First Quarter TDS", Colors.deepOrange,
                () async {
              if (printController.insurancePdfResponse.value != null &&
                  printController.insurancePdfResponse.value!.result!.flag ==
                      "1" &&
                  printController.insurancePdfResponse.value!.data!
                      .tdsDocument1!.isNotEmpty) {
                downloadPDF(
                    fileName: "First Quarter TDS",
                    url: printController
                        .insurancePdfResponse.value!.data!.tdsDocument1
                        .toString());
              } else {
                MyToast.myShowToast("No PDF Available");
              }
            },
                (printController.insurancePdfResponse.value != null &&
                        printController.insurancePdfResponse.value!.result !=
                            null &&
                        printController
                                .insurancePdfResponse.value!.result!.flag ==
                            "1" &&
                        printController.insurancePdfResponse.value!.data!
                            .tdsDocument1!.isNotEmpty)
                    ? printController
                        .insurancePdfResponse.value!.data!.tdsDocument1
                        .toString()
                    : ""),
            const SizedBox(height: 15),
            buildTDSRow(context, "Second Quarter TDS", Colors.deepOrange,
                () async {
              if (printController.insurancePdfResponse.value != null &&
                  printController.insurancePdfResponse.value!.result != null &&
                  printController.insurancePdfResponse.value!.result!.flag ==
                      "1" &&
                  printController.insurancePdfResponse.value!.data!
                      .tdsDocument2!.isNotEmpty) {
                downloadPDF(
                    fileName: "Second Quarter TDS",
                    url: printController
                        .insurancePdfResponse.value!.data!.tdsDocument2
                        .toString());
              } else {
                MyToast.myShowToast("No PDF Available");
              }
            },
                (printController.insurancePdfResponse.value != null &&
                        printController.insurancePdfResponse.value!.result !=
                            null &&
                        printController
                                .insurancePdfResponse.value!.result!.flag ==
                            "1" &&
                        printController.insurancePdfResponse.value!.data!
                            .tdsDocument2!.isNotEmpty)
                    ? printController
                        .insurancePdfResponse.value!.data!.tdsDocument2
                        .toString()
                    : ""),
            const SizedBox(height: 15),
            buildTDSRow(context, "Third Quarter TDS", Colors.deepOrange,
                () async {
              if (printController.insurancePdfResponse.value != null &&
                  printController.insurancePdfResponse.value!.result != null &&
                  printController.insurancePdfResponse.value!.result!.flag ==
                      "1" &&
                  printController.insurancePdfResponse.value!.data!
                      .tdsDocument3!.isNotEmpty) {
                downloadPDF(
                    fileName: "Third Quarter TDS",
                    url: printController
                        .insurancePdfResponse.value!.data!.tdsDocument3
                        .toString());
              } else {
                MyToast.myShowToast("No PDF Available");
              }
            },
                (printController.insurancePdfResponse.value != null &&
                        printController.insurancePdfResponse.value!.result !=
                            null &&
                        printController
                                .insurancePdfResponse.value!.result!.flag ==
                            "3" &&
                        printController.insurancePdfResponse.value!.data!
                            .tdsDocument1!.isNotEmpty)
                    ? printController
                        .insurancePdfResponse.value!.data!.tdsDocument3
                        .toString()
                    : ""),
            const SizedBox(height: 15),
            buildTDSRow(context, "Fourth Quarter TDS", Colors.deepOrange,
                () async {
              if (printController.insurancePdfResponse.value != null &&
                  printController.insurancePdfResponse.value!.result != null &&
                  printController.insurancePdfResponse.value!.result!.flag ==
                      "1" &&
                  printController.insurancePdfResponse.value!.data!
                      .tdsDocument4!.isNotEmpty) {
                downloadPDF(
                    fileName: "Fourth Quarter TDS",
                    url: printController
                        .insurancePdfResponse.value!.data!.tdsDocument4
                        .toString());
              } else {
                MyToast.myShowToast("No PDF Available");
              }
            },
                (printController.insurancePdfResponse.value != null &&
                        printController.insurancePdfResponse.value!.result !=
                            null &&
                        printController
                                .insurancePdfResponse.value!.result!.flag ==
                            "1" &&
                        printController.insurancePdfResponse.value!.data!
                            .tdsDocument4!.isNotEmpty)
                    ? printController
                        .insurancePdfResponse.value!.data!.tdsDocument4
                        .toString()
                    : ""),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "E-Card",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buildTDSRow(context, "E Card", Colors.deepOrange, () async {
              // downloadPDF(fileName: "E Card", url: "https://grofers.isoping.com:8090/One_World_Hyperlocal/Twms/Uploaded_Excel/82358123_DESPK0874M.pdf");
              if (printController.insurancePdfResponse.value != null &&
                  printController.insurancePdfResponse.value!.result != null &&
                  printController.insurancePdfResponse.value!.result!.flag ==
                      "1" &&
                  printController.insurancePdfResponse.value!.data!
                      .ecardDocument!.isNotEmpty) {
                downloadPDF(
                    fileName: "E Card",
                    url: printController
                        .insurancePdfResponse.value!.data!.ecardDocument
                        .toString());
              } else {
                MyToast.myShowToast("No PDF Available");
              }
            },
                (printController.insurancePdfResponse.value != null &&
                        printController.insurancePdfResponse.value!.result !=
                            null &&
                        printController
                                .insurancePdfResponse.value!.result!.flag ==
                            "1" &&
                        printController.insurancePdfResponse.value!.data!
                            .ecardDocument!.isNotEmpty)
                    ? printController
                        .insurancePdfResponse.value!.data!.ecardDocument
                        .toString()
                    : ""),
          ],
        ),
      ),
    );
  }

  Widget buildTDSRow(BuildContext context, String title, Color color,
      VoidCallback onPressed, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              debugPrint("Tapped");
              // Dialogs.pdfViewer(context, "https://grofers.isoping.com:8090/One_World_Hyperlocal/Twms/Uploaded_Excel/DESPK0874M_Q1_2023-24.pdf");
              Dialogs.pdfViewer(context, url);
            },
            icon: Icon(Icons.picture_as_pdf, color: color, size: 30),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: onPressed,
            child: const Row(
              children: [
                Text("Download"),
                SizedBox(width: 5),
                Icon(Icons.download),
              ],
            ),
          ),
        ],
      ),
    );
  }

  downloadPDF({required String fileName, required String url}) async {
    var printController = Get.find<InsuranceDetailsController>();

    FileDownloader.downloadFile(
        url: url,
        name: fileName,
        notificationType: NotificationType.all,
        downloadDestination: DownloadDestinations.publicDownloads,
        onDownloadCompleted: (String path) {
          // Navigator.pop(context);

          debugPrint('FILE DOWNLOADED TO PATH: $path');
          Get.snackbar(
            'Download Complete',
            '$fileName downloaded',
            mainButton: TextButton(
                onPressed: () async {
                  if (url == null || url == "") {
                    MyToast.myShowToast("No Pdf");
                  } else {
                    // printController.pdfDocument.value =
                    //     await PDFDocument.fromURL(url);
                    // Get.to(const ViewPdf());
                  }
                },
                child: const Text('View')),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.deepOrange.shade500,
            colorText: Colors.white,
          );
        },
        onDownloadError: (String error) {
          Navigator.pop(context);
          debugPrint('DOWNLOAD ERROR: $error');
          MyToast.myShowToast2("..");
        });
  }
}

class ViewPdf extends StatelessWidget {
  const ViewPdf({super.key});

  @override
  Widget build(BuildContext context) {
    var pdfController = Get.find<InsuranceDetailsController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade500,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("PDF"),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                )
              ],
            ))
          ],
        ),
      ),
      // body: PDFViewer(document: pdfController.pdfDocument.value!),
    );
  }
}
