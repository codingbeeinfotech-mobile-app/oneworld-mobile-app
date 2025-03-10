// ignore_for_file: unnecessary_null_comparison

class SendOtpResponse {
  late String status;
  late String mobilenumbers;
  late String remainingcredits;
  late String msgcount;
  late String selectedRoute;
  late String refid;
  late String senttime;
  late List<Response> response;

  SendOtpResponse(
      {required this.status,
      required this.mobilenumbers,
      required this.remainingcredits,
      required this.msgcount,
      required this.selectedRoute,
      required this.refid,
      required this.senttime,
      required this.response});

  SendOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? '';
    mobilenumbers = json['mobilenumbers'] ?? '';
    remainingcredits = json['remainingcredits'] ?? '';
    msgcount = json['msgcount'] ?? '';
    selectedRoute = json['selectedRoute'] ?? '';
    refid = json['refid'] ?? '';
    senttime = json['senttime'] ?? '';
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response.add(Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['mobilenumbers'] = mobilenumbers;
    data['remainingcredits'] = remainingcredits;
    data['msgcount'] = msgcount;
    data['selectedRoute'] = selectedRoute;
    data['refid'] = refid;
    data['senttime'] = senttime;
    if (response != null) {
      data['response'] = response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  late String mobileNumber;
  late String uniqueId;

  Response({required this.mobileNumber, required this.uniqueId});

  Response.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobile_number'] ?? '';
    uniqueId = json['unique_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_number'] = mobileNumber;
    data['unique_id'] = uniqueId;
    return data;
  }
}
