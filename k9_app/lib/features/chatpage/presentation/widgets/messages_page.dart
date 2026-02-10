import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:k9_app/features/chatpage/data/message_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesPage extends StatefulWidget {
  final String id;
  const MessagesPage({super.key, required this.id});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final List<Message> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Future<void> loadMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "messages_${widget.id}";
    final data = prefs.getString(key);
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      setState(() {});
    }
  }
}
