class ValidatePrintTrackingNumberRequest {
  ValidatePrintTrackingNumberRequest({
    required this.trackingNo,
  });

  final String? trackingNo;

  factory ValidatePrintTrackingNumberRequest.fromJson(Map<String, dynamic> json){
    return ValidatePrintTrackingNumberRequest(
      trackingNo: json["TrackingNo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "TrackingNo": trackingNo,
  };

  @override
  String toString(){
    return "$trackingNo, ";
  }
}
