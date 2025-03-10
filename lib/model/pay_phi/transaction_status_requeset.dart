class PayPhiTransactionStatusRequest {
  PayPhiTransactionStatusRequest({
    required this.merchantId,
    required this.merchantTxnNo,
    required this.originalTxnNo,
    required this.transactionType,
    required this.secureHash,
  });

  final String? merchantId;
  final String? merchantTxnNo;
  final String? originalTxnNo;
  final String? transactionType;
  final String? secureHash;

  factory PayPhiTransactionStatusRequest.fromJson(Map<String, dynamic> json){
    return PayPhiTransactionStatusRequest(
      merchantId: json["merchantId"],
      merchantTxnNo: json["merchantTxnNo"],
      originalTxnNo: json["originalTxnNo"],
      transactionType: json["transactionType"],
      secureHash: json["secureHash"],
    );
  }

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId,
    "merchantTxnNo": merchantTxnNo,
    "originalTxnNo": originalTxnNo,
    "transactionType": transactionType,
    "secureHash": secureHash,
  };

  @override
  String toString(){
    return "$merchantId, $merchantTxnNo, $originalTxnNo, $transactionType, $secureHash, ";
  }
}
