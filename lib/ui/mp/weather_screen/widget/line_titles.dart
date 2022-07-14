// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class LineTitles {
//   static getTitleData() => FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles:SideTitles(
//           showTitles: true,
//           reservedSize: 35,

//           getTitlesWidget: (value, titleMeta) => TitleMeta(min: min, max: max, appliedInterval: appliedInterval, sideTitles: sideTitles, formattedValue: formattedValue, axisSide: axisSide),
          
//         ),
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           getTextStyles: (value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//           ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '10k';
//               case 3:
//                 return '30k';
//               case 5:
//                 return '50k';
//             }
//             return '';
//           },
//           reservedSize: 35,
//           margin: 12,
//         ),
//       );
// }