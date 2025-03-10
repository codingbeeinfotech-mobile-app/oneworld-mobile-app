import 'package:abhilaya/api/master_api/api_call.dart';
import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../model/request_model/app_version_request.dart';
import '../model/response_model/app_version_response.dart';
import '../utils/update_dialog_box.dart';

class ForceUpdateController extends GetxController {
  RxBool forceDialogVisibility = true.obs;
  var forceUpdateCount = 0.obs;
  var appVersion = ''.obs;
  var apiVersion = '1.0.0'.obs;
  var packageName = "com.isourse.abhilaya".obs;

  getAppVersion(BuildContext context) async {
    // MyToast.myShowToast('hello'.tr);
    debugPrint('app version api call');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    appVersion.value = version;
    packageName.value = packageInfo.packageName;
    AppVersionRequest versionReq =
        AppVersionRequest(apikey: "", clientId: "8", clientName: "", type: "");

    var url = 'checkVersion';

    ///Test
    var res = await CallMasterApi.postApiCall(
        ApiUrl.baseUrl + ApiUrl.getAppVersion, versionReq, "");
    var data = AppVersionResponse.fromJson(res);
    if (res != null) {
      apiVersion.value = data.flutterVersion.toString();
      // String apiVersion = data.result[0].appVersion;/// for android
      // String apiVersion = data.result[0].iosAppVersion;/// for ios
      debugPrint('App version --$appVersion');

      debugPrint(int.parse(apiVersion.substring(4)).toString());
      debugPrint(int.parse(appVersion.substring(4)).toString());

      // debugPrint('App version --${apiVersion}');
      if (int.parse(apiVersion.substring(4)) >
          int.parse(appVersion.substring(4))) {
        ForceUpdateDialog forceUpdateDialog = ForceUpdateDialog();
        debugPrint("\n\n\n\ Again \n\n\n");
        // forceUpdateDialog.forceUpdateDialog(context);
      }
    }
  }
}
