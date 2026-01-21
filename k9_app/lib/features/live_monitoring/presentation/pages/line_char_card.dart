import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k9_app/core/providers/theme_provider.dart';

class LineCharCard extends ConsumerStatefulWidget {
  const LineCharCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LineCharCardState();
}

class _LineCharCardState extends ConsumerState<LineCharCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: LineChart(
          LineChartData(
            backgroundColor: ref.isDark ? ref.theme.cardColor : Colors.white,
            lineTouchData: LineTouchData(
              
            )
          ),
        ),
      ),
    );
  }
}
