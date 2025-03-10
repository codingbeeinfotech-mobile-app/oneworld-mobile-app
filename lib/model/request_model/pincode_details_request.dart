class PinCodeRequest {
  PinCodeRequest({
    required this.pincode,

  });

  final String? pincode;


  factory PinCodeRequest.fromJson(Map<String, dynamic> json){
    return PinCodeRequest(
      pincode: json["Pincode"],

    );
  }

  Map<String, dynamic> toJson() => {
    "Pincode": pincode,

  };

  @override
  String toString(){
    return "$pincode,   ";
  }
}
