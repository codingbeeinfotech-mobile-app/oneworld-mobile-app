import 'package:xml/xml.dart' as xml;

class ExotelCallResponse {
  ExotelCallResponse({
    required this.twilioResponse,
  });

  final TwilioResponse? twilioResponse;

  // Existing fromJson method
  factory ExotelCallResponse.fromJson(Map<String, dynamic> json) {
    return ExotelCallResponse(
      twilioResponse: json["TwilioResponse"] == null
          ? null
          : TwilioResponse.fromJson(json["TwilioResponse"]),
    );
  }

  // New fromXml method
  factory ExotelCallResponse.fromXml(xml.XmlElement xmlElement) {
    return ExotelCallResponse(
      twilioResponse: xmlElement.findElements('Call').isEmpty
          ? null
          : TwilioResponse.fromXml(xmlElement.findElements('Call').first),
    );
  }




  Map<String, dynamic> toJson() => {
    "TwilioResponse": twilioResponse?.toJson(),
  };

  @override
  String toString() {
    return "$twilioResponse, ";
  }
}

class TwilioResponse {
  TwilioResponse({
    required this.call,
  });

  final Call? call;

  // Existing fromJson method
  factory TwilioResponse.fromJson(Map<String, dynamic> json) {
    return TwilioResponse(
      call: json["Call"] == null ? null : Call.fromJson(json["Call"]),
    );
  }

  // New fromXml method
  factory TwilioResponse.fromXml(xml.XmlElement xmlElement) {
    return TwilioResponse(
      call: xmlElement.findElements('Call').isEmpty
          ? null
          : Call.fromXml(xmlElement.findElements('Call').first),
    );
  }

  Map<String, dynamic> toJson() => {
    "Call": call?.toJson(),
  };

  @override
  String toString() {
    return "$call, ";
  }
}

class Call {
  Call({
    required this.sid,
    required this.parentCallSid,
    required this.dateCreated,
    required this.dateUpdated,
    required this.accountSid,
    required this.to,
    required this.from,
    required this.phoneNumberSid,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.price,
    required this.direction,
    required this.answeredBy,
    required this.forwardedFrom,
    required this.callerName,
    required this.uri,
    required this.recordingUrl,
  });

  final String sid;
  final String parentCallSid;
  final String dateCreated;
  final String dateUpdated;
  final String accountSid;
  final String to;
  final String from;
  final String phoneNumberSid;
  final String status;
  final String startTime;
  final String endTime;
  final String duration;
  final String price;
  final String direction;
  final String answeredBy;
  final String forwardedFrom;
  final String callerName;
  final String uri;
  final String recordingUrl;

  // Existing fromJson method
  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      sid: json["Sid"] ?? "",
      parentCallSid: json["ParentCallSid"] ?? "",
      dateCreated: json["DateCreated"] ?? "",
      dateUpdated: json["DateUpdated"] ?? "",
      accountSid: json["AccountSid"] ?? "",
      to: json["To"] ?? "",
      from: json["From"] ?? "",
      phoneNumberSid: json["PhoneNumberSid"] ?? "",
      status: json["Status"] ?? "",
      startTime: json["StartTime"] ?? "",
      endTime: json["EndTime"] ?? "",
      duration: json["Duration"] ?? "",
      price: json["Price"] ?? "",
      direction: json["Direction"] ?? "",
      answeredBy: json["AnsweredBy"] ?? "",
      forwardedFrom: json["ForwardedFrom"] ?? "",
      callerName: json["CallerName"] ?? "",
      uri: json["Uri"] ?? "",
      recordingUrl: json["RecordingUrl"] ?? "",
    );
  }

  // New fromXml method
  factory Call.fromXml(xml.XmlElement xmlElement) {
    return Call(
      sid: xmlElement.findElements('Sid').isEmpty
          ? ""
          : xmlElement.findElements('Sid').first.text,
      parentCallSid: xmlElement.findElements('ParentCallSid').isEmpty
          ? ""
          : xmlElement.findElements('ParentCallSid').first.text,
      dateCreated: xmlElement.findElements('DateCreated').isEmpty
          ? ""
          : xmlElement.findElements('DateCreated').first.text,
      dateUpdated: xmlElement.findElements('DateUpdated').isEmpty
          ? ""
          : xmlElement.findElements('DateUpdated').first.text,
      accountSid: xmlElement.findElements('AccountSid').isEmpty
          ? ""
          : xmlElement.findElements('AccountSid').first.text,
      to: xmlElement.findElements('To').isEmpty
          ? ""
          : xmlElement.findElements('To').first.text,
      from: xmlElement.findElements('From').isEmpty
          ? ""
          : xmlElement.findElements('From').first.text,
      phoneNumberSid: xmlElement.findElements('PhoneNumberSid').isEmpty
          ? ""
          : xmlElement.findElements('PhoneNumberSid').first.text,
      status: xmlElement.findElements('Status').isEmpty
          ? ""
          : xmlElement.findElements('Status').first.text,
      startTime: xmlElement.findElements('StartTime').isEmpty
          ? ""
          : xmlElement.findElements('StartTime').first.text,
      endTime: xmlElement.findElements('EndTime').isEmpty
          ? ""
          : xmlElement.findElements('EndTime').first.text,
      duration: xmlElement.findElements('Duration').isEmpty
          ? ""
          : xmlElement.findElements('Duration').first.text,
      price: xmlElement.findElements('Price').isEmpty
          ? ""
          : xmlElement.findElements('Price').first.text,
      direction: xmlElement.findElements('Direction').isEmpty
          ? ""
          : xmlElement.findElements('Direction').first.text,
      answeredBy: xmlElement.findElements('AnsweredBy').isEmpty
          ? ""
          : xmlElement.findElements('AnsweredBy').first.text,
      forwardedFrom: xmlElement.findElements('ForwardedFrom').isEmpty
          ? ""
          : xmlElement.findElements('ForwardedFrom').first.text,
      callerName: xmlElement.findElements('CallerName').isEmpty
          ? ""
          : xmlElement.findElements('CallerName').first.text,
      uri: xmlElement.findElements('Uri').isEmpty
          ? ""
          : xmlElement.findElements('Uri').first.text,
      recordingUrl: xmlElement.findElements('RecordingUrl').isEmpty
          ? ""
          : xmlElement.findElements('RecordingUrl').first.text,
    );
  }

  Map<String, dynamic> toJson() => {
    "Sid": sid,
    "ParentCallSid": parentCallSid,
    "DateCreated": dateCreated,
    "DateUpdated": dateUpdated,
    "AccountSid": accountSid,
    "To": to,
    "From": from,
    "PhoneNumberSid": phoneNumberSid,
    "Status": status,
    "StartTime": startTime,
    "EndTime": endTime,
    "Duration": duration,
    "Price": price,
    "Direction": direction,
    "AnsweredBy": answeredBy,
    "ForwardedFrom": forwardedFrom,
    "CallerName": callerName,
    "Uri": uri,
    "RecordingUrl": recordingUrl,
  };

  @override
  String toString() {
    return "$sid, $parentCallSid, $dateCreated, $dateUpdated, $accountSid, $to, $from, $phoneNumberSid, $status, $startTime, $endTime, $duration, $price, $direction, $answeredBy, $forwardedFrom, $callerName, $uri, $recordingUrl, ";
  }
}
