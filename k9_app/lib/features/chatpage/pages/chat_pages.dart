import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/core/providers/theme_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: ref.isDark ? ref.theme.cardColor : Colors.white,
              child: ListTile(
                leading: CircleAvatar(child: Text("ZM")),
                subtitle: Text("Veteriner"),
                title: Text("Zeynep Su Mollaoğlu"),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
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
