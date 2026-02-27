import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:k9_app/core/providers/theme_provider.dart';
import 'package:k9_app/features/chatpage/presentation/widgets/chat_pages.dart';
import 'package:k9_app/features/homepage/presentation/widgets/homepage_screen.dart';
import 'package:k9_app/features/live_monitoring/presentation/pages/live_page.dart';
import 'package:k9_app/features/profilePage/presentation/profile_page.dart';

class Bottomnavbar extends ConsumerStatefulWidget {
  final String userId;
  const Bottomnavbar({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends ConsumerState<Bottomnavbar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePageScreen(),
      const ProfilePage(),
      const LivePage(),
      ChatPage(userId: widget.userId),
    ];
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ref.isDark ? ref.theme.scaffoldBackgroundColor : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Kontrol',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.monitor_heart_outlined,
                  label: 'Canlı',
                  index: 2,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.comment,
                  label: "Mesajlar",
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  index: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xff165efc)
                  : const Color(0xff9ca3af),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xff165efc)
                    : const Color(0xff9ca3af),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
