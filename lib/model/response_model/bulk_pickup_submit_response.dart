class BulkPickUpSubmitResponse {
  BulkPickUpSubmitResponse({
    required this.flag,
    required this.flagMessage,
  });

  final bool? flag;
  final dynamic flagMessage;

  factory BulkPickUpSubmitResponse.fromJson(Map<String, dynamic> json){
    return BulkPickUpSubmitResponse(
      flag: json["Flag"],
      flagMessage: json["FlagMessage"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "FlagMessage": flagMessage,
  };

  @override
  String toString(){
    return "$flag, $flagMessage, ";
  }
}
