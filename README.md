# K9 Project (k9_app)

**K9 operasyonları için gerçek zamanlı sağlık takibi, canlı kamera izleme ve ekip içi mesajlaşmayı tek mobil uygulamada birleştiren Flutter tabanlı izleme çözümü.**

![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.35.0-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%3E%3D3.9.0-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue)
![State Management](https://img.shields.io/badge/State%20Management-Riverpod-5B21B6)
![License](https://img.shields.io/badge/License-Not%20Specified-lightgrey)
![CI](https://img.shields.io/badge/CI-Not%20Configured-lightgrey)

---

## 1) Proje Hakkında (About / Overview)

Bu proje, K9 (görev köpekleri) için:
- **anlık vital takip** (ör. kalp atışı, SpO2, sıcaklık, GSR),
- **canlı video akışı izleme**,
- **ekip içi mesajlaşma**

ihtiyaçlarını tek arayüzde toplamak amacıyla geliştirilmiş bir Flutter uygulamasıdır.

### Çözdüğü problem
Sahadaki personelin farklı sistemler arasında geçiş yapmadan, köpek sağlığı + çevresel görüntü + ekip iletişimini eşzamanlı yönetebilmesini hedefler.

### Hedef kitle
- K9 eğitmenleri
- Veteriner ekipleri
- Teknik saha personeli
- Operasyon/komuta merkezi kullanıcıları

### Temel kullanım senaryoları
1. Eğitmen uygulamaya giriş yapar.
2. Kontrol panelinden köpeğin anlık durumunu ve 24 saatlik trendleri izler.
3. Canlı izleme sekmesinde IP/kamera akışlarını takip eder.
4. Mesaj sekmesinden ekip üyeleriyle gerçek zamanlı haberleşir.
5. Profil sekmesinden tercihleri (bildirim, tema) yönetir.

---

## 2) Öne Çıkan Özellikler (Key Features)

Kod tabanı analizine göre mevcut yetenekler:

- **Tab tabanlı giriş ekranı** (Giriş yap / Kayıt ol).
- **Form doğrulama** (e‑posta, güçlü şifre kuralları).
- **Kullanıcı ID ile oturum geçişi** (Bottom Navigation’a yönlendirme).
- **Modern alt gezinme yapısı**: Kontrol, Canlı, Mesajlar, Profil.
- **Karanlık mod yönetimi** (Riverpod + SharedPreferences ile kalıcı saklama).
- **Bildirim tercihi anahtarı** (profilde local state yönetimi).
- **Vital özet kartları**: kalp, SpO2, sıcaklık, solunum, GSR.
- **24 saatlik trend grafiği** (fl_chart, tooltip/legend desteği).
- **Canlı kamera listesi**:
  - Kamera ekleme (başlık + URL)
  - Kamera silme
  - Listeyi cihazda kalıcı tutma (SharedPreferences)
- **Video oynatma özellikleri**:
  - Network stream oynatma
  - Sessize alma/açma
  - Tam ekran + yatay ekran zorlaması
  - Zoom/Pan (InteractiveViewer)
- **Canlı veri kartları (simülasyon)**:
  - Periyodik veri üretimi
  - Kayan pencere grafik gösterimi
- **WebSocket tabanlı mesajlaşma**:
  - Mesaj gönder/al
  - Teslim edildi / okundu durumları
  - Mesajları lokal saklama
  - Uzun basarak mesaj silme
- **VR mod kartı (yakında)**: UI hazır, buton pasif.
- **Çoklu platform altyapısı**: Android, iOS, Web, Windows, Linux, macOS klasörleri mevcut.

---

## 3) Teknoloji Yığını (Tech Stack)

| Kategori | Teknolojiler |
|---|---|
| Frontend (Mobile/UI) | Flutter, Material Design |
| Dil | Dart |
| State Management | flutter_riverpod, riverpod |
| Grafik & Görselleştirme | fl_chart |
| Video/Streaming | video_player, flutter_vlc_player (bağımlılıkta mevcut) |
| Gerçek Zamanlı İletişim | web_socket_channel (WebSocket) |
| Local Storage | shared_preferences |
| Form/Validation | form_validator |
| İkonografi | font_awesome_flutter, cupertino_icons |
| Test | flutter_test |
| Lint/Static Analysis | flutter_lints, analysis_options.yaml |
| DevOps/CI | Bu depoda workflow dosyası yok (CI henüz tanımlı değil) |
| Backend | Bu depoda backend kodu yok (harici WebSocket servisine bağlanıyor) |
| Veritabanı | Uygulama tarafında doğrudan DB yok; cihaz içi kalıcılık SharedPreferences ile |
| AI/ML | Kod tabanında doğrudan AI/ML modülü bulunmuyor |

### Sürüm notları (mevcut proje dosyalarından)
- Dart SDK: `>=3.9.0 <4.0.0` (lock dosyasına göre)
- Flutter: `>=3.35.0` (lock dosyasına göre)
- Proje sürümü: `1.0.0+1`

---

## 4) Proje Dizin Yapısı (Project Structure)

```text
k9_project/
├─ k9_app/
│  ├─ lib/
│  │  ├─ main.dart
│  │  ├─ core/
│  │  │  ├─ constant/
│  │  │  │  └─ app_colors.dart
│  │  │  └─ providers/
│  │  │     ├─ theme_provider.dart
│  │  │     ├─ notifications_provider.dart
│  │  │     └─ camera_provider.dart
│  │  └─ features/
│  │     ├─ enterpage/
│  │     │  ├─ providers/
│  │     │  │  ├─ login_providers.dart
│  │     │  │  └─ signup_providers.dart
│  │     │  └─ presentation/widgets/
│  │     │     ├─ enterpage.dart
│  │     │     ├─ login_field.dart
│  │     │     └─ signup_field.dart
│  │     ├─ bottomnavbar/presentation/bottomnavbar.dart
│  │     ├─ homepage/presentation/widgets/homepage_screen.dart
│  │     ├─ live_monitoring/presentation/pages/
│  │     │  ├─ live_page.dart
│  │     │  ├─ camera_card.dart
│  │     │  ├─ real_time_char_card.dart
│  │     │  ├─ line_char_card.dart
│  │     │  └─ vr_show_card.dart
│  │     ├─ chatpage/
│  │     │  ├─ data/message_modal.dart
│  │     │  └─ presentation/widgets/
│  │     │     ├─ chat_pages.dart
│  │     │     ├─ listtile_chat.dart
│  │     │     └─ messages_page.dart
│  │     └─ profilePage/presentation/profile_page.dart
│  ├─ test/
│  │  └─ widget_test.dart
│  ├─ android/ ios/ web/ windows/ linux/ macos/
│  ├─ pubspec.yaml
│  ├─ pubspec.lock
│  ├─ analysis_options.yaml
│  └─ devtools_options.yaml
└─ README.md
```

---

## 5) Konfigürasyon Dosyaları Analizi

Aşağıdaki dosyalar bu depoda **mevcut**:
- `pubspec.yaml`, `pubspec.lock`
- `analysis_options.yaml`
- `devtools_options.yaml`
- Platform bazlı build dosyaları (`android/*.kts`, iOS/macOS plist/xcconfig, desktop CMake)

Aşağıdaki yaygın dosyalar bu depoda **bulunmuyor**:
- `package.json`
- `requirements.txt`
- `Dockerfile`
- `pom.xml`
- `.env` / `.env.example`
- `.github/workflows/*` (CI)
- `LICENSE`

> Not: Bu durum projenin Flutter odaklı, tek depo içinde backend/servis/container pipeline içermeyen bir yapıda olduğunu gösterir.

---

## 6) Kurulum ve Çalıştırma (Getting Started / Installation)

### Ön gereksinimler
- Flutter SDK (önerilen: `>=3.35.0`)
- Dart SDK (önerilen: `>=3.9.0 <4.0.0`)
- Android Studio / Xcode (hedef platforma göre)
- (Opsiyonel) WebSocket backend servisi

### Kurulum
```bash
git clone <REPO_URL>
cd k9_project/k9_app
flutter pub get
```

### Ortam değişkenleri (.env) durumu
Bu projede hazır `.env` altyapısı yoktur. Bağlantı adresleri kod içinde tanımlıdır.

Özellikle mesajlaşma servisi için varsayılan bağlantı örneği:
- `ws://192.168.1.113:8000/ws/{userId}`

Üretim için öneri:
1. `flutter_dotenv` benzeri bir paket ekleyin,
2. websocket/video endpointlerini `.env` üzerinden yönetin,
3. hardcoded IP’leri kaldırın.

### Geliştirme ortamında çalıştırma
```bash
flutter run
```

Belirli platform örnekleri:
```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

### Production build örnekleri
```bash
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release
```

> Android release için internet erişimi gerekiyorsa, production manifest izinlerini ayrıca gözden geçirin.

---

## 7) Usage & API Documentation

Bu depoda REST API sunucusu yoktur; uygulama harici WebSocket servisine istemci olarak bağlanır.

### WebSocket bağlantısı
- URL şablonu: `ws://<HOST>:<PORT>/ws/{userId}`

### Mesaj gönderme payload örneği
```json
{
  "type": "send_message",
  "id": "1724234567890",
  "sender_id": "yusufberkez",
  "receiver_id": "zeysu",
  "message": "Merhaba"
}
```

### Sunucudan gelebilen olay tipleri
- `message`
- `delivered`
- `read`

### Teslim bilgisi örneği
```json
{
  "type": "delivered",
  "id": "1724234567890",
  "sender_id": "yusufberkez",
  "receiver_id": "zeysu",
  "timestamp": 1724234567999
}
```

### Okundu bilgisi örneği
```json
{
  "type": "read",
  "id": "1724234567890",
  "reader_id": "zeysu",
  "sender_id": "yusufberkez",
  "timestamp": 1724234570000
}
```

### Kamera kullanımı
- Canlı izleme ekranından kamera adı + URL girerek listeye ekleme yapılır.
- Kamera listesi cihazda kalıcı saklanır.
- Kart üzerinde ses aç/kapat, tam ekran ve kapatma işlemleri yapılır.

---

## 8) Katkıda Bulunma (Contributing)

Katkı vermek için önerilen akış:

1. Depoyu fork’layın.
2. Yeni bir branch açın: `feature/<kisa-aciklama>`
3. Değişikliklerinizi küçük ve odaklı commit’lerle yapın.
4. `flutter analyze` ve mümkünse `flutter test` çalıştırın.
5. PR açarken:
   - Amaç/özet
   - Ekran görüntüsü (UI değiştiyse)
   - Test/manuel doğrulama notları
   - Olası breaking change bilgisi

Issue açarken:
- Beklenen davranış
- Mevcut davranış
- Adım adım tekrar senaryosu
- Platform/cihaz bilgisi

---

## 9) Lisans (License)

Bu depoda şu an bir lisans dosyası tanımlı değil.

Kurumsal/açık kaynak kullanım için kök dizine bir `LICENSE` dosyası eklenmesi önerilir (ör. MIT, Apache-2.0, GPL-3.0).

---

## 10) Yol Haritası (Önerilen İyileştirmeler)

- Hardcoded endpointleri `.env` tabanlı yönetime taşımak
- CI pipeline (GitHub Actions) eklemek
- Testleri gerçek ekran akışlarına göre güncellemek
- `line_char_card.dart` gibi yarım kalan parçaları tamamlamak veya temizlemek
- Release güvenlik/izin yapılandırmalarını gözden geçirmek
- Backend kontratını (mesaj şemaları) ayrı dokümana almak
