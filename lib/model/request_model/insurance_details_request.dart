class InsurancePdfRequest {
  InsurancePdfRequest({
    required this.clientId,
    required this.clientName,
    required this.contactNumberOfDriver,
    required this.driverId,
  });

  final String? clientId;
  final String? clientName;
  final String? contactNumberOfDriver;
  final String? driverId;

  factory InsurancePdfRequest.fromJson(Map<String, dynamic> json){
    return InsurancePdfRequest(
      clientId: json["CLIENT_ID"],
      clientName: json["CLIENT_NAME"],
      contactNumberOfDriver: json["Contact_Number_Of_Driver"],
      driverId: json["Driver_ID"],
    );
  }

  Map<String, dynamic> toJson() => {
    "CLIENT_ID": clientId,
    "CLIENT_NAME": clientName,
    "Contact_Number_Of_Driver": contactNumberOfDriver,
    "Driver_ID": driverId,
  };

  @override
  String toString(){
    return "$clientId, $clientName, $contactNumberOfDriver, $driverId, ";
  }
}
