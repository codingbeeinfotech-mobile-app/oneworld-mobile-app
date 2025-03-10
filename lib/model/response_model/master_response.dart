class MasterResponse {
  late int mID;
  late String mName;
  late int mTypeID;
  late String mTypeName;
  late int parentCodeTypeId;
  late int mParentID;



  MasterResponse(
      {required this.mID, required this.mName,required this.mTypeID,required this.mTypeName,required this.mParentID});


  @override
  String toString() {
    return 'MasterResponse{mID: $mID, mName: $mName, mTypeID: $mTypeID, mTypeName: $mTypeName, mParentID: $mParentID, ParentCodeTypeId: $parentCodeTypeId}';
  }

  MasterResponse.fromJson(Map<String, dynamic> json) {
    mID = json['M_ID']??0;
    mName = json['M_Name'];
    mTypeID = json['M_TypeID']??0;
    mTypeName = json['M_TypeName'];
    parentCodeTypeId = json['ParentCodeTypeId'] ?? 0;
    mParentID = json['ParentCodeId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['M_ID'] = mID;
    data['M_Name'] = mName;
    data['M_TypeID'] = mTypeID;
    data['M_TypeName'] = mTypeName;
    data['ParentCodeTypeId'] = parentCodeTypeId;
    data['ParentCodeId'] = mParentID;
    return data;
  }
}
class BloodType {
  final String name;
  final String value;
  final String? description;
  final bool isActive;

  BloodType({
    required this.name,
    required this.value,
    this.description,
    required this.isActive,
  });

  factory BloodType.fromJson(Map<String, dynamic> json) {
    return BloodType(
      name: json['Name'],
      value: json['Value'],
      description: json['Description'],
      isActive: json['IsActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Value': value,
      'Description': description,
      'IsActive': isActive,
    };
  }

  static List<BloodType> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BloodType.fromJson(json)).toList();
  }
}
