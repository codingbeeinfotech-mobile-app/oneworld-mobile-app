class SubmitDeliveryResponse {
  SubmitDeliveryResponse({
    required this.flag,
    required this.flagMessage,
  });

  final bool? flag;
  final String? flagMessage;

  factory SubmitDeliveryResponse.fromJson(Map<String, dynamic> json){
    return SubmitDeliveryResponse(
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
