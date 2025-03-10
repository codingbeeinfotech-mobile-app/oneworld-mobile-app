import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:abhilaya/api/master_api/api_url.dart';
import 'package:abhilaya/model/pay_phi/qrGeneratorRequest.dart';
import 'package:abhilaya/model/pay_phi/transaction_status_requeset.dart';
import 'package:abhilaya/model/response_model/token_response.dart';
import 'package:abhilaya/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

import '../../utils/general/shared_preferences_keys.dart'; // Import XML package

class CallMasterApi {
  //OWL180060

  static Future postApiCall(String url, dynamic model, String token) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(model.toJson()),
      );
      log('API response Master: $url   ');
      log('API response Master:1  ${model.toJson()} ');

      log('API response Master2:   ${jsonDecode(response.body)}');

      if (response.statusCode == 200 || response.statusCode == 400) {
        debugPrint('API call response.statusCode: ${response.statusCode}');

        var data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint('API call failed from Master: $e $s');
    }
  }
  static Future postApiCallWithoutBody(String url,  String token) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

      );
      log('API response Master: $url   ');


      log('API response Master2:   ${jsonDecode(response.body)}');

      if (response.statusCode == 200 || response.statusCode == 400) {
        debugPrint('API call response.statusCode: ${response.statusCode}');

        var data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e, s) {
      debugPrint('API call failed from Master: $e $s');
    }
  }

  static Future getApiCall(String url, String token) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('API response Master: $url   ${jsonDecode(response.body)}');

      if (response.statusCode == 200 || response.statusCode == 400) {
        debugPrint('API call response.statusCode: ${response.statusCode}');

        var data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e, s) {
      debugPrint('API call failed from Master: $e $s');
    }
  }

  static Future getDatBody ({required Uri uri, required String token, Map<String, dynamic>? body, // Optional JSON body for GET requests
  }) async {
    try {
      debugPrint("_getData URL=-=-=-=-::: $uri");

      var request = http.Request('GET', uri);
      request.headers.addAll(
 {        'Content-Type': 'application/json',
   'Authorization': 'Bearer $token',}
      );

      // If body is provided, encode it as JSON
      if (body != null) {
        request.body = jsonEncode(body);
        debugPrint("_getData Body=-=-=-=-::: ${request.body}");
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseString = await response.stream.bytesToString();
        debugPrint('Response.statusCode is ${response.statusCode} $responseString');

        dynamic map = json.decode(responseString);
        return map;
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e, s) {
      debugPrint('API call failed from Master: $e $s');
    }
    return null;
  }


  static Future<LoginTokenResponse?> tokenApi(String url) async {
    try {
      final tokenResponse = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'grant_type=password&username=admin&password=admin',
      );

      debugPrint('Raw token response: ${tokenResponse.body}');

      if (tokenResponse.statusCode == 200) {
        debugPrint("Token Generated Successfully");
        var res = jsonDecode(tokenResponse.body);
        LoginTokenResponse tokenData = LoginTokenResponse.fromJson(res);
        return tokenData;
      } else {
        debugPrint(
            'Token API call failed with status code: ${tokenResponse.statusCode}');
        debugPrint('Error response: ${tokenResponse.body}');
        throw Exception('Token API call failed');
      }
    } catch (e) {
      debugPrint("Token API Call Failed: $e");
    }
    return null;
  }

  static Future postApiCallWithoutToken(String url) async {
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        debugPrint("Api Called Successfully");
        var res = jsonDecode(response.body);
        return res;
      } else {
        throw Exception('Token Api call failed');
      }
    } catch (e) {
      debugPrint("Token API Call Failed");
    }
  }

  static Future postApiCallBasicAuth(String url, model) async {
    debugPrint("Request URL: $url");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = 'ISOURSE';
    String password = 'gariCR8gD+jhARov4uL2UIkn712JTrfSekjvzlYuDaU=';
    String basicAuth = 'Bearer ${prefs.getString(Strings.token)}';
    debugPrint("Authorization Header: ${basicAuth}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': basicAuth,
        },
        body: json.encode(model.toJson()),
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 404) {
        return json.decode(response.body);
      } else {
        MyToast.myShowToast("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      MyToast.myShowToast("Network or server error.");
    }
  }

  static Future postApiCallFormUrlEncoded(
      String url, PayPhiGenerateQrRequest model) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, dynamic> formMap = {
      'merchantId': ApiUrl.payPhiMerchantId,
      'merchantRefNo': model.merchantRefNo,
      'amount': model.amount,
      'Currency': model.currency,
      'emailID': model.emailId,
      'mobileNo': model.mobileNo,
      'secureHash': model.secureHash,
      'addlparam1': model.addlparam1,
      'requestType': model.requestType
    };

    String formData = formMap.keys.map((key) {
      return '${Uri.encodeComponent(key)}=${Uri.encodeComponent(formMap[key].toString())}';
    }).join('&');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: formData,
        encoding: Encoding.getByName('utf-8')!,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // MyToast.myShowToast("Internal Server Error");
      }
    } catch (e) {
      debugPrint("QR Api Call Failed");
    }
  }

  static Future postApiCallForPaymentStatusCheck(
      String url, PayPhiTransactionStatusRequest model) async {
    debugPrint("Status Check API");
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    Map<String, dynamic> formMap = {
      'merchantID': ApiUrl.payPhiMerchantId,
      'merchantTxnNo': model.merchantTxnNo,
      'originalTxnNo': model.originalTxnNo,
      'transactionType': model.transactionType,
      'secureHash': model.secureHash,
    };
    String formData = formMap.keys.map((key) {
      return '${Uri.encodeComponent(key)}=${Uri.encodeComponent(formMap[key].toString())}';
    }).join('&');

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: formData,
        encoding: Encoding.getByName('utf-8')!,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint("Check 1");
        return data;
      } else {
        // MyToast.myShowToast("Internal Server Error");
      }
    } catch (e) {
      debugPrint("Transaction Status Api Call Failed");
    }
  }

  /* static Future<dynamic> generateQR() async {
    final url = 'https://qa.phicommerce.com/pg/api/generateQR';
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'merchantId': 'T_24746',
      'merchantRefNo': '347775121',
      'amount': '100.12',
      'Currency': '356',
      'emailID': 'chaitanya.somani@phicommerce.com',
      'mobileNo': '9325436206',
      'secureHash': '741e1fdf18e90793025dab6e8f25b391534b25ed6158f597b2e252ab2ccf36ab',
      'addlparam1': 'test1',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        var errorData = jsonDecode(response.body);
        debugPrint('API call failed with status: ${response.statusCode}');
        debugPrint('Error data: $errorData');
        throw Exception('API Call Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      MyToast.myShowToast("Internal Server Error");
      debugPrint('API call failed from generateQR: $e');
      throw Exception('Internal Server Error');
    }
  } */

  // static Future<dynamic> callPostUrlEncodedApiNoToken(
  //     String url, Map<String, dynamic> fieldsMap, Map<String, File> filesMap) async {
  //   try {
  //     debugPrint("called");
  //
  //     String username = '61de7148fd264d5808bf3d6e4d51a480a3e855e374d202d0';
  //     String password = '62bad4a33a72cf2546ed67ef8e71d5823353fd4ea87bb9c2';
  //     String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
  //
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     request.headers['Authorization'] = basicAuth;
  //
  //     fieldsMap.forEach((key, value) {
  //       request.fields[key] = value.toString();
  //     });
  //
  //     if (filesMap.isNotEmpty) {
  //       for (var entry in filesMap.entries) {
  //         String fieldName = entry.key;
  //         File file = entry.value;
  //         request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
  //       }
  //     }
  //
  //     var response = await request.send();
  //     var responseBody = await response.stream.bytesToString();
  //
  //     if (response.statusCode == 200 || response.statusCode == 202) {
  //       var xmlDocument = xml.XmlDocument.parse(responseBody);
  //       debugPrint("API Response: $xmlDocument");
  //       MyToast.myShowToast("Calling....");
  //       return xmlDocument;
  //     }
  //     else if (response.statusCode == 400) {
  //       var xmlDocument = xml.XmlDocument.parse(responseBody);
  //       debugPrint("API Response: $xmlDocument");
  //       MyToast.myShowToast("Something went wrong");
  //       return xmlDocument;
  //     }
  //     else if (response.statusCode == 401) {
  //       var xmlDocument = xml.XmlDocument.parse(responseBody);
  //
  //       var message = xmlDocument.findAllElements('Message').map((element) => element.text).first;
  //
  //       debugPrint("Error Message: $message");
  //       MyToast.myShowToast(message);
  //     }
  //     else if (response.statusCode == 402) {
  //       MyToast.myShowToast("0 credit left for Exotel Services, Please Recharge");
  //     }
  //     else if (response.statusCode == 403) {
  //       var xmlDocument = xml.XmlDocument.parse(responseBody);
  //       var message = xmlDocument.findAllElements('Message').map((element) => element.text).first;
  //       debugPrint("Error Message: $message");
  //       MyToast.myShowToast("Phone Number not registered");
  //     }
  //     else if (response.statusCode == 429) {
  //       MyToast.myShowToast("Too Many Requests - You are calling our APIs more frequently than we allow.");
  //     }
  //     else {
  //       MyToast.myShowToast("Something went wrong");
  //       throw Exception("Error ${response.statusCode}: $responseBody");
  //     }
  //   } catch (e) {
  //     MyToast.myShowToast("Something went wrong");
  //     debugPrint("API Call Failed: $e");
  //     return null; // Return null on failure
  //   }
  // }

  static Future<dynamic> callPostUrlEncodedApiNoToken(String url,
      Map<String, dynamic> fieldsMap, Map<String, File> filesMap) async {
    try {
      debugPrint("called");

      String username = '61de7148fd264d5808bf3d6e4d51a480a3e855e374d202d0';
      String password = '62bad4a33a72cf2546ed67ef8e71d5823353fd4ea87bb9c2';
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$username:$password'))}';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = basicAuth;

      fieldsMap.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (filesMap.isNotEmpty) {
        for (var entry in filesMap.entries) {
          String fieldName = entry.key;
          File file = entry.value;
          request.files
              .add(await http.MultipartFile.fromPath(fieldName, file.path));
        }
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint("Response Status: ${response.statusCode}"); // Log status code

      switch (response.statusCode) {
        case 200:
        case 202:
          var xmlDocument = xml.XmlDocument.parse(responseBody);
          debugPrint("API Response: $xmlDocument");
          MyToast.myShowToast("Calling....");
          return xmlDocument;

        case 400:
          var xmlDocument = xml.XmlDocument.parse(responseBody);
          debugPrint("API Response: $xmlDocument");
          MyToast.myShowToast("Something went wrong");
          return xmlDocument;

        case 401:
          var xmlDocument = xml.XmlDocument.parse(responseBody);
          var message = xmlDocument
              .findAllElements('Message')
              .map((element) => element.text)
              .first;
          debugPrint("Error Message: $message");
          MyToast.myShowToast(message);
          return null;

        case 402:
          MyToast.myShowToast(
              "0 credit left for Exotel Services, Please Recharge");
          return null;

        case 403:
          var xmlDocument = xml.XmlDocument.parse(responseBody);
          var message = xmlDocument
              .findAllElements('Message')
              .map((element) => element.text)
              .first;
          debugPrint("Error Message: $message");
          MyToast.myShowToast("Phone Number not registered");
          return null;

        case 429:
          MyToast.myShowToast(
              "Too Many Requests - You are calling our APIs more frequently than we allow.");
          return null;

        default:
          MyToast.myShowToast("Something went wrong");
          debugPrint("Error ${response.statusCode}: $responseBody");
          throw Exception("Error ${response.statusCode}: $responseBody");
      }
    } catch (e) {
      MyToast.myShowToast("Something went wrong");
      debugPrint("API Call Failed: $e");
      return null; // Return null on failure
    }
  }
}
