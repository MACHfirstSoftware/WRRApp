import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisconsin_app/config.dart';
import 'package:wisconsin_app/models/weather.dart';

class LineChartWidget extends StatefulWidget {
  final List<Hour> dayHours;
  const LineChartWidget({Key? key, required this.dayHours}) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  // List<Color> gradientColors = [
  //   const Color(0xff23b6e6),
  //   const Color(0xff02d39a),
  // ];

  List<Color> gradientColors = [
    Colors.white,
    AppColors.btnColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 30.h, bottom: 10.h, left: 15.w, right: 15.w),
      decoration: BoxDecoration(
          color: AppColors.popBGColor.withOpacity(.75),
          borderRadius: BorderRadius.circular(15.w)),
      child: LineChart(
        mainData(),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
    );
    Widget text;
    // switch (value.toInt()) {
    //   case 2:
    //     text = const Text('MAR', style: style);
    //     break;
    //   case 5:
    //     text = const Text('JUN', style: style);
    //     break;
    //   case 8:
    //     text = const Text('SEP', style: style);
    //     break;
    //   default:
    //     text = const Text('', style: style);
    //     break;
    // }
    if (value.toInt() % 4 == 0) {
      text = Text('${value.toInt()}', style: style);
    } else if (value.toInt() == 23) {
      text = Text('${value.toInt() + 1}', style: style);
    } else {
      text = Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10.h,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 15.sp,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '20f';
        break;
      case 2:
        text = '40f';
        break;
      case 3:
        text = '60f';
        break;
      case 4:
        text = '80f';
        break;
      case 5:
        text = '100f';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1.w,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1.w,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 2,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1.w)),
      minX: 0,
      maxX: 23,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < widget.dayHours.length; i++)
              FlSpot(i.toDouble(), widget.dayHours[i].tempF / 20)
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5.w,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  // LineChartData avgData() {
  //   return LineChartData(
  //     lineTouchData: LineTouchData(enabled: false),
  //     gridData: FlGridData(
  //       show: true,
  //       drawHorizontalLine: true,
  //       verticalInterval: 1,
  //       horizontalInterval: 1,
  //       getDrawingVerticalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //       getDrawingHorizontalLine: (value) {
  //         return FlLine(
  //           color: const Color(0xff37434d),
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           getTitlesWidget: bottomTitleWidgets,
  //           interval: 1,
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           getTitlesWidget: leftTitleWidgets,
  //           reservedSize: 42,
  //           interval: 1,
  //         ),
  //       ),
  //       topTitles: AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       rightTitles: AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //         show: true,
  //         border: Border.all(color: const Color(0xff37434d), width: 1)),
  //     minX: 0,
  //     maxX: 11,
  //     minY: 0,
  //     maxY: 6,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: const [
  //           FlSpot(0, 3.44),
  //           FlSpot(2.6, 3.44),
  //           FlSpot(4.9, 3.44),
  //           FlSpot(6.8, 3.44),
  //           FlSpot(8, 3.44),
  //           FlSpot(9.5, 3.44),
  //           FlSpot(11, 3.44),
  //         ],
  //         isCurved: true,
  //         gradient: LinearGradient(
  //           colors: [
  //             ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                 .lerp(0.2)!,
  //             ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                 .lerp(0.2)!,
  //           ],
  //           begin: Alignment.centerLeft,
  //           end: Alignment.centerRight,
  //         ),
  //         barWidth: 5,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             colors: [
  //               ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                   .lerp(0.2)!
  //                   .withOpacity(0.1),
  //               ColorTween(begin: gradientColors[0], end: gradientColors[1])
  //                   .lerp(0.2)!
  //                   .withOpacity(0.1),
  //             ],
  //             begin: Alignment.centerLeft,
  //             end: Alignment.centerRight,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
