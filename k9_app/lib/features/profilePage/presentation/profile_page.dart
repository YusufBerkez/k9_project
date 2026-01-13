import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/core/providers/notifications_provider.dart';
import 'package:k9_app/core/providers/theme_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final isDarkMode = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Eğitmen bilgileri
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDarkMode ? theme.cardColor : Colors.white,
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: const Text(
                          "Yusuf Berke Zengin",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text("K9 Eğitmeni"),
                        leading: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xff2b7fff),
                          child: Text(
                            'YBZ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffdbfce7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Aktif',
                              style: TextStyle(color: Color(0xff4da65e)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(indent: 10, endIndent: 10),
                    ),
                    containerInfos("E-posta", "yusufberke@k9.com"),
                    containerInfos("Telefon", "+90 555 123 4567"),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: isDarkMode
                                    ? theme.cardColor
                                    : Colors.white,
                                foregroundColor: isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Profili Düzenle',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tercihler kartı (fotoğrafa benzer)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? theme.cardColor : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.settings_outlined,
                            color: Color(0xff374151),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Tercihler',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 20, indent: 12, endIndent: 12),
                    // Bildirimler
                    ListTile(
                      leading: const Icon(
                        Icons.notifications_none,
                        color: Color(0xff6b7280),
                      ),
                      title: const Text('Bildirimler'),
                      trailing: Switch(
                        value: notifications,
                        activeColor: const Color(0xffffffff),
                        inactiveThumbColor: const Color(0xffffffff),
                        inactiveTrackColor: const Color(0xffcbced4),
                        activeTrackColor: const Color(0xff000000),
                        onChanged: (v) =>
                            ref.read(notificationsProvider.notifier).toggle(v),
                      ),
                    ),
                    // Karanlık Mod
                    ListTile(
                      leading: const Icon(
                        Icons.nightlight_round,
                        color: Color(0xff6b7280),
                      ),
                      title: const Text('Karanlık Mod'),
                      trailing: Switch(
                        value: isDarkMode,
                        activeColor: const Color(0xffffffff),
                        inactiveThumbColor: const Color(0xffffffff),
                        inactiveTrackColor: const Color(0xffcbced4),
                        activeTrackColor: const Color(0xff000000),
                        onChanged: (v) =>
                            ref.read(themeProvider.notifier).toggleTheme(v),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding containerInfos(String name, String value) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(color: Colors.grey.shade700)),
          Text(value),
        ],
      ),
    );
  }
}
