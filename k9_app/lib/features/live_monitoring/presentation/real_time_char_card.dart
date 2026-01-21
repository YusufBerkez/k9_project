import 'dart:async'; // Timer için
import 'dart:math'; // Rastgele veri üretmek için
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RealTimeChartPage extends StatefulWidget {
  const RealTimeChartPage({super.key});

  @override
  State<RealTimeChartPage> createState() => _RealTimeChartPageState();
}

class _RealTimeChartPageState extends State<RealTimeChartPage> {
  // Grafikte gösterilecek noktalar
  final List<FlSpot> _spots = [];

  // X ekseni için sayacımız (Zaman gibi düşünebilirsin)
  double _xValue = 0;

  // Ekranda aynı anda kaç nokta görünsün?
  final int _limitCount = 20;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simülasyon: Her 100 milisaniyede bir veri geldiğini varsayalım
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _addNewData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Sayfadan çıkınca timeri öldürmeyi unutma!
    super.dispose();
  }

  // BURASI SENİN VERİ ALDIĞIN YER OLACAK
  void _addNewData() {
    setState(() {
      // 1. Rastgele bir Y değeri üret (Sen buraya sensörden gelen veriyi koy)
      double yValue = sin(_xValue) * 5 + 10 + Random().nextDouble() * 2;

      // 2. Listeye yeni noktayı ekle
      _spots.add(FlSpot(_xValue, yValue));

      // 3. Eğer limit aşıldıysa en eski veriyi sil (Kayan pencere mantığı)
      if (_spots.length > _limitCount) {
        _spots.removeAt(0);
      }

      // 4. X değerini bir sonraki adım için artır
      _xValue += 0.2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canlı Veri Grafiği')),
      body: Center(
        child: _spots.isEmpty
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20.0,
                      top: 20,
                      bottom: 20,
                    ),
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: false),
                        // Grafiğin sınırlarını dinamik olarak ayarla
                        minX: _spots.first.x,
                        maxX: _spots.last.x,
                        minY: 0, // Verine göre ayarla
                        maxY: 20, // Verine göre ayarla
                        // Izgara çizgilerini kapatmak istersen:
                        gridData: FlGridData(show: false),

                        // Başlıkları (X ve Y ekseni sayıları) ayarla
                        titlesData: FlTitlesData(
                          show: true,
                          // SAĞ Tarafı Gizle
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // ÜST Tarafı Gizle
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // ALT Tarafı Gizle (İstediğin bu)
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // SOL Tarafı (Y Değerleri) Göster
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true, // Burası true kalacak
                              reservedSize:
                                  40, // Yazıların sığması için ayrılan genişlik
                              getTitlesWidget: (value, meta) {
                                // İstersen sayıları formatlayabilirsin (örn: ondalıksız)
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Çizgi ve Nokta ayarları
                        lineBarsData: [
                          LineChartBarData(
                            spots: _spots,
                            isCurved: true, // Çizgiler yumuşak mı olsun?
                            color: Colors.blueAccent,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: false,
                            ), // Noktaları gizle, sadece çizgi olsun
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blueAccent.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
