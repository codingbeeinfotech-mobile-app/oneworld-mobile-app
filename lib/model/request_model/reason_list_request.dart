class ReasonListRequest {
  ReasonListRequest({
    required this.codeTypeId,
  });

  final String codeTypeId;

  factory ReasonListRequest.fromJson(Map<String, dynamic> json){
    return ReasonListRequest(
      codeTypeId: json["CodeTypeId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "CodeTypeId": codeTypeId,
  };

  @override
  String toString(){
    return "$codeTypeId, ";
  }
}
