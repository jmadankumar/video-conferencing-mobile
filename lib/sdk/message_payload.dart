class MessagePayload {
  String type;
  dynamic data;

  MessagePayload({this.type, this.data});

  factory MessagePayload.fromJson(dynamic json) {
    return MessagePayload(type: json['type'], data: json['data']);
  }
}
