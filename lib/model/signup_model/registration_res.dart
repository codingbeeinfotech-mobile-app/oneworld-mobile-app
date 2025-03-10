class RegistrationRes {
  late int insertId;
  late int aPIKEY;
  late String response;

  RegistrationRes({required this.insertId, required this.aPIKEY, required this.response});

  RegistrationRes.fromJson(Map<String, dynamic> json) {
    insertId = json['InsertId'];
    aPIKEY = json['APIKEY'];
    response = json['Response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InsertId'] = insertId;
    data['APIKEY'] = aPIKEY;
    data['Response'] = response;
    return data;
  }
}