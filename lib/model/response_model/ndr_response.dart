class NDRListResponse {
  NDRListResponse({
    required this.name,
    required this.value,
    required this.description,
    required this.isActive,
  });

  final String? name;
  final String? value;
  final dynamic description;
  final bool? isActive;

  factory NDRListResponse.fromJson(Map<String, dynamic> json){
    return NDRListResponse(
      name: json["Name"],
      value: json["Value"],
      description: json["Description"],
      isActive: json["IsActive"],
    );
  }

  @override
  String toString() {
    return 'NDRListResponse{name: $name, value: $value, description: $description, isActive: $isActive}';
  }

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Value": value,
    "Description": description,
    "IsActive": isActive,
  };

}
