class PayPhiGenerateQrRequest {
  PayPhiGenerateQrRequest({
    required this.merchantId,
    required this.merchantRefNo,
    required this.amount,
    required this.currency,
    required this.emailId,
    required this.mobileNo,
    required this.requestType,
    required this.secureHash,
    required this.addlparam1,
  });

  final String? merchantId;
  final String? merchantRefNo;
  final double? amount;
  final int? currency;
  final String? emailId;
  final String? mobileNo;
  final String? requestType;
  final String? secureHash;
  final String? addlparam1;

  factory PayPhiGenerateQrRequest.fromJson(Map<String, dynamic> json){
    return PayPhiGenerateQrRequest(
      merchantId: json["merchantId"],
      merchantRefNo: json["merchantRefNo"],
      amount: json["amount"],
      currency: json["currency"],
      emailId: json["emailId"],
      mobileNo: json["mobileNo"],
      requestType: json["requestType"],
      secureHash: json["secureHash"],
      addlparam1: json["addlparam1"],
    );
  }

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId,
    "merchantRefNo": merchantRefNo,
    "amount": amount,
    "currency": currency,
    "emailId": emailId,
    "mobileNo": mobileNo,
    "requestType": requestType,
    "secureHash": secureHash,
    "addlparam1": addlparam1,
  };

  @override
  String toString(){
    return "$merchantId, $merchantRefNo, $amount, $currency, $emailId, $mobileNo, $requestType, $secureHash, $addlparam1, ";
  }
}
