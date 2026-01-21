import 'dart:async'; // Timer için
import 'dart:math'; // Rastgele veri üretmek için
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RealTimeChartPage extends StatefulWidget {
  final List<FlSpot> spots;
  final String charName;
  final String charBrName;

  const RealTimeChartPage({
    super.key,
    required this.spots,
    required this.charName,
    required this.charBrName,
  });

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
      appBar: AppBar(title: Text(widget.charName)),
      body: Center(
        child: _spots.isEmpty
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // height: 50,  <--- BU SATIRI SİLDİM (veya 250 yapabilirsin)
                  // Grafik ve yazı rahat sığsın diye Card veya Container yüksekliğini serbest bırakabilirsin
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16), // İç boşluk
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // İçerik kadar yer kaplasın
                    children: [
                      // Üstteki BPM yazısı
                      Text(
                        "${_spots.last.y.toInt()} ${widget.charBrName}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Grafik Alanı
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height *
                            0.1, // Grafiğin yüksekliği
                        width: double.infinity,
                        child: LineChart(
                          LineChartData(
                            lineTouchData: LineTouchData(enabled: false),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),

                            // 1. Veri tek iken çökmemesi için kontrol:
                            minX: _spots.first.x,
                            maxX: _spots.length < 2
                                ? _spots.first.x +
                                      1 // Tek veri varsa bitişi 1 artır
                                : _spots.last.x,

                            minY: 0,
                            maxY: 20,

                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30, // Biraz daralttım
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: _spots,
                                isCurved: true,
                                color: Colors.blueAccent,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blueAccent.withOpacity(
                                    0.1,
                                  ), // Biraz daha şeffaf yaptım
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
