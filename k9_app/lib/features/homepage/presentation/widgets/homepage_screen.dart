import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:k9_app/core/providers/theme_provider.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});
  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  final bool isActive = true;
  late final List<FlSpot> heartSpots; // 85 ±3
  late final List<FlSpot> spo2Spots; // 97 ±3
  late final List<FlSpot> tempSpots; // 38.5 ±3
  late final List<FlSpot> heartHourly;
  late final List<FlSpot> spo2Hourly;
  late final List<FlSpot> tempHourly;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    heartSpots = [];
    spo2Spots = [];
    tempSpots = [];
    heartHourly = [];
    spo2Hourly = [];
    tempHourly = [];
    for (int m = 0; m < 24 * 60; m++) {
      final x = m / 60.0; // hour value with minute resolution
      final heart = 85 + (rand.nextInt(7) - 3); // 82-88
      final spo2 = (97 + (rand.nextInt(7) - 3)).clamp(90, 100); // 94-100
      final temp = (38.5 + (rand.nextInt(7) - 3)).clamp(35.5, 41.5);
      heartSpots.add(FlSpot(x, heart.toDouble()));
      spo2Spots.add(FlSpot(x, spo2.toDouble()));
      tempSpots.add(FlSpot(x, temp.toDouble()));
    }
    // Saatlik ortalama noktalar (daha sakin grafik)
    for (int h = 0; h <= 24; h++) {
      final start = h * 60;
      final end = ((h + 1) * 60).clamp(0, heartSpots.length);
      if (start >= heartSpots.length) break;
      double heartSum = 0, spo2Sum = 0, tempSum = 0;
      final count = max(1, end - start);
      for (int i = start; i < end; i++) {
        heartSum += heartSpots[i].y;
        spo2Sum += spo2Spots[i].y;
        tempSum += tempSpots[i].y;
      }
      heartHourly.add(FlSpot(h.toDouble(), heartSum / count));
      spo2Hourly.add(FlSpot(h.toDouble(), spo2Sum / count));
      tempHourly.add(FlSpot(h.toDouble(), tempSum / count));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      const DogsInfoCards(
        icon: Icons.favorite,
        iconColor: Colors.red,
        iconBackgroundColor: Color(0xffffe2e2),
        text: 'Kalp Atışı',
        value: '85',
        valuebr: 'bpm',
      ),
      const DogsInfoCards(
        icon: Icons.water_drop_outlined,
        iconColor: Color(0xff155dfc),
        iconBackgroundColor: Color(0xffdbeafe),
        text: 'SpO2',
        value: '97',
        valuebr: '%',
      ),
      const DogsInfoCards(
        icon: Icons.thermostat,
        iconColor: Color(0xfff77235),
        iconBackgroundColor: Color(0xffffedd4),
        text: 'Sıcaklık',
        value: '38.5',
        valuebr: 'C',
      ),
      const DogsInfoCards(
        icon: Icons.air,
        iconColor: Color(0xff0092b8),
        iconBackgroundColor: Color(0xffcefafe),
        text: 'Solunum',
        value: '22',
        valuebr: '/dk',
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'K9 Vital İzleme',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Gerçek zamanlı sağlık takibi',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xff2b7fff), Color(0xff165efc)],
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Rex',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Alman Çoban Köpeği',
                          style: TextStyle(
                            color: Color(0xffcfeafe),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '3 yaş',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Eğitmen: Yusuf Berke Zengin',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 17,
                    top: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xff05df72) : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      child: Text(isActive ? 'Aktif' : 'Pasif'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth < 500 ? 2 : 4;
                  final cardWidth =
                      (constraints.maxWidth - (8 * (crossAxisCount + 1))) /
                      crossAxisCount;
                  final cardHeight = cardWidth * 0.967;
                  return SizedBox(
                    height: crossAxisCount == 2
                        ? cardHeight * 2 + 16
                        : cardHeight + 8,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1 / 0.95,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) => cards[index],
                    ),
                  );
                },
              ),
            ),
            const DogsInfoListile(value: '45'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '24 Saatlik Trend',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 190,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 24,
                          minY: 0,
                          maxY: 100,
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              getTooltipItems: (touched) {
                                if (touched.isEmpty) return [];
                                final time = _formatTime(touched.first.x);
                                return touched.map((ts) {
                                  final c = ts.bar.color ?? Colors.white;
                                  String label;
                                  if (c == Colors.red) {
                                    label =
                                        'Kalp: ${ts.y.toStringAsFixed(0)} bpm';
                                  } else if (c == const Color(0xff155dfc)) {
                                    label = 'SpO₂: ${ts.y.toStringAsFixed(0)}%';
                                  } else {
                                    label =
                                        'Sıcaklık: ${ts.y.toStringAsFixed(1)}°C';
                                  }
                                  return LineTooltipItem(
                                    '$time\n$label',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            verticalInterval: 4,
                            horizontalInterval: 25,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                              dashArray: [4, 4],
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 25,
                                reservedSize: 34,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 4,
                                getTitlesWidget: (value, meta) {
                                  if (value == 0) return _bottomTitle('00:00');
                                  if (value == 4) return _bottomTitle('04:00');
                                  if (value == 8) return _bottomTitle('08:00');
                                  if (value == 12) return _bottomTitle('12:00');
                                  if (value == 16) return _bottomTitle('16:00');
                                  if (value == 20) return _bottomTitle('20:00');
                                  if (value == 24) return _bottomTitle('23:59');
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.red,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                              spots: heartHourly,
                            ),
                            LineChartBarData(
                              isCurved: true,
                              color: const Color(0xff155dfc),
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                              spots: spo2Hourly,
                            ),
                            LineChartBarData(
                              isCurved: true,
                              color: const Color(0xfff77235),
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                              spots: tempHourly,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _legendItem('Kalp Atışı (bpm)', Colors.red),
                        _legendItem('SpO₂ (%)', const Color(0xff155dfc)),
                        _legendItem('Sıcaklık (°C)', const Color(0xfff77235)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DogsInfoListile extends StatelessWidget {
  const DogsInfoListile({super.key, required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        leading: Container(
          decoration: BoxDecoration(
            color: Color(0xfff3e8ff),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.flash_on_rounded, color: Color(0xffba61fc)),
          ),
        ),
        title: Text("Galvanik Deri Tepkisi"),
        subtitle: Row(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(" μS"),
          ],
        ),
        trailing: Icon(Icons.show_chart_sharp, color: Colors.green),
      ),
    );
  }
}

class DogsInfoCards extends ConsumerWidget {
  const DogsInfoCards({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.text,
    required this.value,
    required this.valuebr,
  });
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String text;
  final String value;
  final String valuebr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey : Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: iconBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, color: iconColor),
            ),
          ),
          Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Text(
                valuebr,
                style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _bottomTitle(String text) => SideTitleWidget(
  axisSide: AxisSide.bottom,
  child: Text(text, style: const TextStyle(fontSize: 10)),
);

Widget _legendItem(String label, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 11)),
    ],
  );
}

String _formatTime(double hourValue) {
  final totalMinutes = (hourValue * 60).round();
  final h = (totalMinutes ~/ 60) % 24;
  final m = totalMinutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}
