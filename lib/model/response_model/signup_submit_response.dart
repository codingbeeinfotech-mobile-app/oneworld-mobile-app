class SubmitSignupResponse {
  SubmitSignupResponse({
    required this.insertId,
    required this.response,
    required this.responseMsg,
  });

  final int? insertId;
  final dynamic response;
  final dynamic responseMsg;

  factory SubmitSignupResponse.fromJson(Map<String, dynamic> json){
    return SubmitSignupResponse(
      insertId: json["InsertId"],
      response: json["Response"],
      responseMsg: json["ResponseMsg"],
    );
  }

  Map<String, dynamic> toJson() => {
    "InsertId": insertId,
    "Response": response,
    "ResponseMsg": responseMsg,
  };

  @override
  String toString(){
    return "$insertId, $response, $responseMsg, ";
  }
}
