import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:k9_app/core/constant/app_colors.dart';
import 'package:k9_app/core/providers/theme_provider.dart';

class VrShowCard extends ConsumerStatefulWidget {
  const VrShowCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VrShowCardState();
}

class _VrShowCardState extends ConsumerState<VrShowCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ref.isDark ? ref.theme.cardColor : Colors.white,
        ),
        child: Column(
          children: [
            //Vr İzleme modu yazısı
            ListTile(
              leading: CircleAvatar(child: FaIcon(FontAwesomeIcons.glasses)),
              title: Text(
                "Vr İzleme Modu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Sanal gerçeklik deneyimi"),
            ),

            //Geliştirme aşamasında yazısı
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ref.isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "🔮 Geliştirme aşamasında...",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "VR gözlük VR gözlük ile immersive 360° izleme deneyimi yakında!",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  child: Text("Vr Modu (Yakında)"),
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: ref.isDark
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
