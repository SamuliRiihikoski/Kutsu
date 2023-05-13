class Date {
  Date(
      {required this.refId,
      this.userId,
      this.label,
      this.text,
      this.chatroom = ""});

  Date.empty({
    this.refId = "",
    this.userId = "",
    this.label = "",
    this.text = "",
    this.chatroom = "",
  });

  Date.fromJson(Map<String, dynamic> json)
      : refId = json['refId'],
        userId = json['userId'],
        label = json['label'],
        text = json['text'],
        chatroom = "";

  final String refId;
  String? userId;
  String? label;
  String? text;
  String chatroom;

  Map<String, dynamic> toJson() => {
        'refId': this.refId,
        'userId': this.userId,
        'label': this.label,
        'text': this.text,
      };
}
