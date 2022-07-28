// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wisconsin_app/config.dart';
// import 'package:wisconsin_app/models/weather.dart';

// class LineChartWidget extends StatefulWidget {
//   final List<Hour> dayHours;
//   const LineChartWidget({Key? key, required this.dayHours}) : super(key: key);

//   @override
//   _LineChartWidgetState createState() => _LineChartWidgetState();
// }

// class _LineChartWidgetState extends State<LineChartWidget> {
//   List<Color> gradientColors = [
//     Colors.white,
//     AppColors.btnColor,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:
//           EdgeInsets.only(top: 30.h, bottom: 10.h, left: 15.w, right: 15.w),
//       decoration: BoxDecoration(
//           color: AppColors.popBGColor.withOpacity(.75),
//           borderRadius: BorderRadius.circular(15.w)),
//       child: LineChart(
//         mainData(),
//       ),
//     );
//   }

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     final style = TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.w500,
//       fontSize: 14.sp,
//     );
//     Widget text;
//     if (value.toInt() % 4 == 0) {
//       text = Text('${value.toInt()}', style: style);
//     } else if (value.toInt() == 23) {
//       text = Text('${value.toInt() + 1}', style: style);
//     } else {
//       text = Text('', style: style);
//     }

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 10.h,
//       child: text,
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     final style = TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.w400,
//       fontSize: 14.sp,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 1:
//         text = '20 °f';
//         break;
//       case 2:
//         text = '40 °f';
//         break;
//       case 3:
//         text = '60 °f';
//         break;
//       case 4:
//         text = '80 °f';
//         break;
//       case 5:
//         text = '100 °f';
//         break;
//       default:
//         return Container();
//     }

//     return Text(text, style: style, textAlign: TextAlign.left);
//   }

//   LineChartData mainData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color(0xff37434d),
//             strokeWidth: 1.w,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: const Color(0xff37434d),
//             strokeWidth: 1.w,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 2,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//           show: true,
//           border: Border.all(color: const Color(0xff37434d), width: 1.w)),
//       minX: 0,
//       maxX: 23,
//       minY: 0,
//       maxY: 6,
//       lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//         getTooltipItems: (value) {
//           return value
//               .map((e) => LineTooltipItem("${(e.y * 20).toStringAsFixed(1)}° f",
//                   TextStyle(color: Colors.white, fontSize: 14.sp)))
//               .toList();
//         },
//         tooltipBgColor: AppColors.btnColor.withOpacity(0.75),
//       )),
//       lineBarsData: [
//         LineChartBarData(
//           spots: [
//             for (int i = 0; i < widget.dayHours.length; i++)
//               FlSpot(i.toDouble(), widget.dayHours[i].tempF / 20)
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           barWidth: 5.w,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
