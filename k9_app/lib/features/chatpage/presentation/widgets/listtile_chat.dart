import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/core/providers/theme_provider.dart';

class ListTileChat extends StatelessWidget {
  final String name;
  final String role;
  final String surname;
  const ListTileChat({
    super.key,
    required this.ref,
    required this.name,

    required this.role,
    required this.surname,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: ref.isDark ? ref.theme.cardColor : Colors.white,
        child: ListTile(
          onTap: () {
            
          },
          leading: CircleAvatar(child: Text("${name[0]}${surname[0]}")),
          subtitle: Text(role),
          title: Text("${name} ${surname}"),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}
