class SubmitNprResponse {
  SubmitNprResponse({
    required this.flag,
    required this.flagMsg,
  });

  final int flag;
  final String flagMsg;

  factory SubmitNprResponse.fromJson(Map<String, dynamic> json){
    return SubmitNprResponse(
      flag: json["Flag"] ?? 0,
      flagMsg: json["Flag_Msg"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Flag": flag,
    "Flag_Msg": flagMsg,
  };

  @override
  String toString(){
    return "$flag, $flagMsg, ";
  }
}
