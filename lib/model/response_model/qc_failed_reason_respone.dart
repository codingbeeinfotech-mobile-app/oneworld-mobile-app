class QcFailReasonResponse {
  QcFailReasonResponse({
    required this.name,
    required this.value,
    required this.description,
    required this.isActive,
  });

  late final String? name;
  final String? value;
  final dynamic description;
  final bool? isActive;

  factory QcFailReasonResponse.fromJson(Map<String, dynamic> json){
    return QcFailReasonResponse(
      name: json["Name"],
      value: json["Value"],
      description: json["Description"],
      isActive: json["IsActive"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Value": value,
    "Description": description,
    "IsActive": isActive,
  };

  @override
  String toString(){
    return "$name, $value, $description, $isActive, ";
  }
}
