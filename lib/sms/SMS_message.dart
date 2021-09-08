import 'package:enum_to_string/enum_to_string.dart';

enum SMSMessageType {
  STARTING,
  WAITING_FOR_UPDATES,
  FLUTTER_NOT_LISTENING,
  FLUTTER_LISTENING,
  FLUTTER_HAS_CHANGED,
  DISCONNECTED,
}

class SMSMessage {
  final String message;

  final SMSMessageType type;

  SMSMessage({this.message, this.type = SMSMessageType.FLUTTER_NOT_LISTENING});

  factory SMSMessage.fromJson(Map<dynamic, dynamic> json) {
    return SMSMessage(
      message: json['message'] as String,
      type: EnumToString.fromString(SMSMessageType.values, json['type'] as String),
    );
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'message': message ?? '',
        'type': EnumToString.convertToString(type),
      };
}
