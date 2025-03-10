class MasterRequest {
  late String cLIENTID;
  late String cLIENTNAME;

  MasterRequest({required this.cLIENTID,required this.cLIENTNAME});

  MasterRequest.fromJson(Map<String, dynamic> json) {
    cLIENTID = json['CLIENT_ID'];
    cLIENTNAME = json['CLIENT_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CLIENT_ID'] = cLIENTID;
    data['CLIENT_NAME'] = cLIENTNAME;
    return data;
  }
}
