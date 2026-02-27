

enum MessageStatus { sending, delivered, read }

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  MessageStatus status;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.status = MessageStatus.sending,
  });
  Map<String, dynamic> toJson() => {
    "id": id,
    "senderId": senderId,
    "receiverId": receiverId,
    "text": text,
    "status": status.index,
  };
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    senderId: json["senderId"],
    receiverId: json["receiverId"],
    text: json["text"],
    status: MessageStatus.values[json["status"] ?? 0],
  );
}
