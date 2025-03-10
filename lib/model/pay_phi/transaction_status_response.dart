class PayPhiTransactionStatusResponse {
  PayPhiTransactionStatusResponse({
    required this.txnRespDescription,
    required this.secureHash,
    required this.amount,
    required this.txnResponseCode,
    required this.txnAuthId,
    required this.respDescription,
    required this.paymentMode,
    required this.responseCode,
    required this.txnStatus,
    required this.paymentSubInstType,
    required this.merchantId,
    required this.merchantTxnNo,
    required this.addlParam1,
    required this.paymentDateTime,
    required this.txnId,
  });

  final String? txnRespDescription;
  final String? secureHash;
  final String? amount;
  final String? txnResponseCode;
  final String? txnAuthId;
  final String? respDescription;
  final String? paymentMode;
  final String? responseCode;
  final String? txnStatus;
  final String? paymentSubInstType;
  final String? merchantId;
  final String? merchantTxnNo;
  final String? addlParam1;
  final String? paymentDateTime;
  final String? txnId;

  factory PayPhiTransactionStatusResponse.fromJson(Map<String, dynamic> json){
    return PayPhiTransactionStatusResponse(
      txnRespDescription: json["txnRespDescription"] ?? "",
      secureHash: json["secureHash"] ?? "",
      amount: json["amount"] ?? "",
      txnResponseCode: json["txnResponseCode"] ?? "",
      txnAuthId: json["txnAuthID"] ?? "",
      respDescription: json["respDescription"] ?? "",
      paymentMode: json["paymentMode"] ?? "",
      responseCode: json["responseCode"] ?? "",
      txnStatus: json["txnStatus"] ?? "",
      paymentSubInstType: json["paymentSubInstType"] ?? "",
      merchantId: json["merchantId"] ?? "",
      merchantTxnNo: json["merchantTxnNo"] ?? "",
      addlParam1: json["addlParam1"] ?? "",
      paymentDateTime: json["paymentDateTime"] ?? "",
      txnId: json["txnID"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "txnRespDescription": txnRespDescription,
    "secureHash": secureHash,
    "amount": amount,
    "txnResponseCode": txnResponseCode,
    "txnAuthID": txnAuthId,
    "respDescription": respDescription,
    "paymentMode": paymentMode,
    "responseCode": responseCode,
    "txnStatus": txnStatus,
    "paymentSubInstType": paymentSubInstType,
    "merchantId": merchantId,
    "merchantTxnNo": merchantTxnNo,
    "addlParam1": addlParam1,
    "paymentDateTime": paymentDateTime,
    "txnID": txnId,
  };

  @override
  String toString(){
    return "$txnRespDescription, $secureHash, $amount, $txnResponseCode, $txnAuthId, $respDescription, $paymentMode, $responseCode, $txnStatus, $paymentSubInstType, $merchantId, $merchantTxnNo, $addlParam1, $paymentDateTime, $txnId, ";
  }
}
