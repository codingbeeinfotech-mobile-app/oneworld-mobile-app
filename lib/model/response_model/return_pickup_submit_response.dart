class ReturnPickupSubmitResponse {
  ReturnPickupSubmitResponse({
    required this.flag,
    required this.flagMessage,
  });

  final bool? flag;
  final String? flagMessage;

  factory ReturnPickupSubmitResponse.fromJson(Map<String, dynamic> json){
    return ReturnPickupSubmitResponse(
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
