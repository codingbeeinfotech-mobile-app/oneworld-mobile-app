class NewOtpResponse {
  NewOtpResponse({
    required this.status,
    required this.messageId,
    required this.message,
  });

  final String? status;
  final List<String> messageId;
  final String? message;

  NewOtpResponse copyWith({
    String? status,
    List<String>? messageId,
    String? message,
  }) {
    return NewOtpResponse(
      status: status ?? this.status,
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
    );
  }

  factory NewOtpResponse.fromJson(Map<String, dynamic> json) {
    return NewOtpResponse(
      status: json["status"],
      messageId: json["message-id"] == null
          ? []
          : List<String>.from(json["message-id"]!.map((x) => x)),
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message-id": messageId.map((x) => x).toList(),
        "message": message,
      };

  @override
  String toString() {
    return "$status, $messageId, $message, ";
  }
}
