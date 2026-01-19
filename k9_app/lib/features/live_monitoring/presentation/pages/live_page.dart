import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/core/providers/camera_provider.dart';
import 'package:k9_app/features/live_monitoring/presentation/pages/camera_card.dart';

class LivePage extends ConsumerStatefulWidget {
  const LivePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LivePageState();
}

class _LivePageState extends ConsumerState<LivePage> {
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraList = ref.watch(cameraListProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Canlı İzleme"), centerTitle: true),
      body: Column(
        children: [
          cameraList.isEmpty
              ? _buildEmptyState()
              : Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Yan yana 2 tane
                      childAspectRatio:
                          1.1, // <--- BURAYI ARTTIRDIK (0.8 çok inceydi, 1.1 daha kare, 1.3 yatay dikdörtgen yapar)
                      crossAxisSpacing: 10, // Yatay boşluk
                      mainAxisSpacing: 10, // Dikey boşluk
                    ),
                    itemCount: cameraList.length,
                    itemBuilder: (context, index) {
                      final camera = cameraList[index];
                      return CameraCard(
                        key: ValueKey(camera.id),
                        videoUrl: camera.videoUrl,
                        title: camera.title,
                        id: camera.id,
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddCameraDialog();
        },
        label: Text("Kamera Ekle"),
      ),
    );
  }

  _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Aktif kamera bulunamadı, Lütfen bir yetkiliyle görüşün"),
          Icon(Icons.videocam_off),
        ],
      ),
    );
  }

  _showAddCameraDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Yeni Kamera Ekle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    label: Text("Kamera Adınızı Giriniz: "),
                    hint: Text("Örn: Ön Kapı"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    label: Text("URL Adresini giriniz: "),
                    hintText: "http://...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .watch(cameraListProvider.notifier)
                      .addCamera(_titleController.text, _urlController.text);
                  Navigator.pop(context);
                },
                child: Text("Ekle"),
              ),
            ],
          ),
        );
      },
    );
  }
}
