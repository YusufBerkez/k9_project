import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/core/providers/theme_provider.dart';
import 'package:k9_app/features/chatpage/presentation/widgets/listtile_chat.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String userId;
  const ChatPage({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mesajlar")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: ref.isDark ? ref.theme.cardColor : Colors.white,
              child: ListTile(
                leading: CircleAvatar(child: Text("AD")),
                subtitle: Text("Eğitmen"),
                title: Text("Dr. Aytaç Durmaz"),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ),
          ListTileChat(
            ref: ref,
            name: "Yusuf Berke",
            role: "Mühendis",
            surname: "Zengin",
            id: "yusufberkez",
            currentUserId: widget.userId,
          ),
          ListTileChat(
            ref: ref,
            name: "Zeynep Su",
            surname: "Demir",
            role: "Veteriner",
            id: "zeysu",
            currentUserId: widget.userId,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: ref.isDark ? ref.theme.cardColor : Colors.white,
              child: ListTile(
                leading: CircleAvatar(child: Text("CO")),
                subtitle: Text("Teknisyen"),
                title: Text("Can Öztürk"),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
