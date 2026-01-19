import 'dart:convert'; // JSON işlemleri için gerekli
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. MODEL
class CameraModel {
  final String id;
  final String title;
  final String videoUrl;

  CameraModel({required this.id, required this.title, required this.videoUrl});

  // --- JSON DÖNÜŞÜM İŞLEMLERİ ---

  // Nesneyi -> Haritaya (Map) çevirir (Kaydederken lazım)
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'videoUrl': videoUrl};
  }

  // Haritadan -> Nesneye çevirir (Okurken lazım)
  factory CameraModel.fromMap(Map<String, dynamic> map) {
    return CameraModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
    );
  }

  // Listeyi tek bir JSON String haline getirmek için yardımcı
  String toJson() => json.encode(toMap());

  // JSON String'i geri nesneye çevirmek için yardımcı
  factory CameraModel.fromJson(String source) =>
      CameraModel.fromMap(json.decode(source));
}

// 2. NOTIFIER (Mantık Kısmı)
class CameraNotifier extends StateNotifier<List<CameraModel>> {
  // Constructor: Sınıf oluşur oluşmaz yükleme işlemini başlatır
  CameraNotifier() : super([]) {
    _loadCameras();
  }

  // --- KAYDETME VE YÜKLEME ---

  // Telefon hafızasından verileri çeker
  Future<void> _loadCameras() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cameraJsonString = prefs.getString('saved_cameras');

    if (cameraJsonString != null) {
      // JSON formatındaki listeyi çözüp normal Dart listesine çeviriyoruz
      final List<dynamic> decodedList = json.decode(cameraJsonString);
      state = decodedList.map((item) => CameraModel.fromMap(item)).toList();
    }
  }

  // Mevcut listeyi telefon hafızasına yazar
  Future<void> _saveCameras() async {
    final prefs = await SharedPreferences.getInstance();
    // Listeyi JSON formatına çevir
    final String encodedData = json.encode(
      state.map((camera) => camera.toMap()).toList(),
    );
    // Kaydet
    await prefs.setString('saved_cameras', encodedData);
  }

  // --- EKLEME VE SİLME ---

  void removeCamera(String targetId) {
    state = state.where((camera) => camera.id != targetId).toList();
    _saveCameras(); // Değişiklikten sonra kaydet
  }

  void addCamera(String title, String url) {
    final camera = CameraModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      videoUrl: url,
    );
    state = [...state, camera];
    _saveCameras(); // Değişiklikten sonra kaydet
  }
}

// 3. PROVIDER
final cameraListProvider =
    StateNotifierProvider<CameraNotifier, List<CameraModel>>((ref) {
      return CameraNotifier();
    });
