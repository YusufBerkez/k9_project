import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/core/providers/theme_provider.dart';
import 'package:k9_app/features/chatpage/data/message_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessagesPage extends StatefulWidget {
  final WidgetRef ref;
  final String id;
  final String receiver_id;
  final String? initialReceiver;
  const MessagesPage({
    super.key,
    required this.id,
    this.initialReceiver,
    required this.receiver_id,
    required this.ref,
  });
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late TextEditingController tftext;
  late WebSocketChannel webSocketChannel;
  final List<Message> messages = [];
  String selectedReceiver = "yusufberkez";

  // Artık herkes herkese mesaj gönderebilir - receiver_id kontrol edilecek
  bool get canSendMessage {
    return selectedReceiver.isNotEmpty && selectedReceiver != widget.id;
  }

  List<Message> get currentConversationMessages {
    return messages
        .where(
          (m) =>
              (m.senderId == widget.id && m.receiverId == selectedReceiver) ||
              (m.senderId == selectedReceiver && m.receiverId == widget.id),
        )
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // receiver_id'yi selectedReceiver olarak ata
    selectedReceiver = widget.receiver_id;
    tftext = TextEditingController();
    loadMessage();
    final wsUrl = Uri.parse("ws://192.168.88.131:8000/ws/${widget.id}");
    webSocketChannel = WebSocketChannel.connect(wsUrl);
    //Test için burayı koydum işlem bitince silinecek
    debugPrint("Connecting to $wsUrl as ${widget.id}");

    webSocketChannel.stream.listen((data) {
      //Gelen ham veriyi burda yazdırıyorum test amaçlı yine
      debugPrint("Received raw data: $data");
      try {
        final decoded = jsonDecode(data);
        final type = decoded["type"] ?? "message";

        if (type == "message") {
          final msg = Message(
            id:
                decoded["id"] ??
                DateTime.now().microsecondsSinceEpoch.toString(),
            senderId: decoded["sender_id"] ?? decoded["senderId"] ?? "unknown",
            receiverId:
                decoded["receiver_id"] ?? decoded["receiverId"] ?? "unknown",
            text: decoded["message"] ?? decoded["text"] ?? "",
            status: MessageStatus.delivered,
          );

          debugPrint(
            "New message: from=${msg.senderId}, to=${msg.receiverId}, text=${msg.text}",
          );

          setState(() {
            messages.add(msg);
          });
          saveMessage();

          // Mesaj bana geldiyse delivered receipt gönder
          if (msg.receiverId == widget.id) {
            final deliveredPayload = jsonEncode({
              "type": "delivered",
              "id": msg.id,
              "sender_id": msg.senderId,
              "receiver_id": widget.id,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
            });
            debugPrint("Sending delivered receipt: $deliveredPayload");
            webSocketChannel.sink.add(deliveredPayload);
          }
        } else if (type == "delivered") {
          final id = decoded["id"]?.toString();
          if (id != null) {
            setState(() {
              final i = messages.indexWhere(
                (m) => m.id == id && m.senderId == widget.id,
              );
              if (i != -1) {
                messages[i].status = MessageStatus.delivered;
                saveMessage();
              }
            });
          }
        } else if (type == "read") {
          final id = decoded["id"]?.toString();
          if (id != null) {
            setState(() {
              final i = messages.indexWhere(
                (m) => m.id == id && m.senderId == widget.id,
              );
              if (i != -1) {
                messages[i].status = MessageStatus.read;
                saveMessage();
              }
            });
          }
        }
      } catch (e) {
        debugPrint("Error parsing message: $e");
        setState(() {
          messages.add(
            Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: "server",
              receiverId: widget.id,
              text: data.toString(),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    tftext.dispose();
    webSocketChannel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Mesajlaşma",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) =>
                  _buildBubble(currentConversationMessages[index]),
              itemCount: currentConversationMessages.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: tftext,
                    decoration: InputDecoration(hintText: "Mesaj yaz"),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "messages_${widget.id}";
    final data = prefs.getString(key);
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      setState(() {
        messages.clear();
        messages.addAll(jsonList.map((j) => Message.fromJson(j)).toList());
      });
    }
  }

  Future<void> saveMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "messages_${widget.id}";
    final data = jsonEncode(messages.map((m) => m.toJson()).toList());
    await prefs.setString(key, data);
  }

  void sendMessage() {
    if (tftext.text.isEmpty) return;

    // Basit kontrol: receiver boş olmamalı ve kendi kendine mesaj gönderilmemeli
    if (!canSendMessage) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Geçerli bir alıcı seçmelisiniz")));
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final msg = Message(
      id: id,
      senderId: widget.id,
      receiverId: selectedReceiver,
      text: tftext.text,
      status: MessageStatus.sending,
    );

    setState(() {
      messages.add(msg);
    });
    saveMessage();

    final payload = jsonEncode({
      "type": "send_message",
      "id": id,
      "sender_id": widget.id,
      "receiver_id": selectedReceiver,
      "message": msg.text,
    });

    debugPrint(
      "Sending message: from=${widget.id}, to=$selectedReceiver, text=${msg.text}",
    );
    debugPrint("Payload: $payload");

    webSocketChannel.sink.add(payload);
    tftext.clear();
  }

  Widget _buildBubble(Message m) {
    final isMine = m.senderId == widget.id;
    final bg = isMine ? Colors.blue[200] : Colors.grey[200];
    final align = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMine
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Row(
            mainAxisAlignment: isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isMine) const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    if (m.receiverId == widget.id &&
                        m.status != MessageStatus.read) {
                      setState(() {
                        m.status = MessageStatus.read;
                      });
                      saveMessage();
                      final readPayload = jsonEncode({
                        "type": "read",
                        "id": m.id,
                        "reader_id": widget.id,
                        "sender_id": m.senderId,
                        "timestamp": DateTime.now().millisecondsSinceEpoch,
                      });
                      webSocketChannel.sink.add(readPayload);
                    }
                  },
                  onLongPress: () {
                    // Uzun basıldığında silme onayı sor
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Mesajı Sil"),
                        content: Text(
                          "Bu mesajı silmek istediğinize emin misiniz?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("İptal"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                messages.removeWhere((msg) => msg.id == m.id);
                              });
                              saveMessage();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Mesaj silindi")),
                              );
                            },
                            child: Text(
                              "Sil",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: bg, borderRadius: radius),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                        color: isMine
                            ? widget.ref.isDark
                                  ? Colors.white
                                  : Colors.black
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              if (isMine)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Builder(
                    builder: (_) {
                      if (m.status == MessageStatus.sending) {
                        return const Icon(Icons.done);
                      } else if (m.status == MessageStatus.delivered) {
                        return const Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.grey,
                        );
                      } else {
                        return const Icon(
                          Icons.done_all,
                          color: Colors.blue,
                          size: 16,
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
