// import 'package:edex_365_getx/core/config/app_colors.dart';
// import 'package:flutter/material.dart';


// class ProblemStatisticsChart extends StatelessWidget {
//   final int totalProblems;
//   final int pendingProblems;
//   final int solvedProblems;

//   const ProblemStatisticsChart({
//     Key? key,
//     required this.totalProblems,
//     required this.pendingProblems,
//     required this.solvedProblems,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final chartData = [
//       _ChartData('Total', totalProblems, AppColors.primary),
//       _ChartData('Pending', pendingProblems, Colors.orange.shade700),
//       _ChartData('Solved', solvedProblems, Colors.green.shade600),
//     ];

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             spreadRadius: 2,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: SfCircularChart(
//         title: const ChartTitle(
//           text: 'Problem Statistics',
//           textStyle: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             color: Colors.black87,
//           ),
//         ),
//         legend: const Legend(
//           isVisible: true,
//           position: LegendPosition.bottom,
//           textStyle: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         series: <CircularSeries>[
//           PieSeries<_ChartData, String>(
//             dataSource: chartData,
//             xValueMapper: (data, _) => data.category,
//             yValueMapper: (data, _) => data.value,
//             pointColorMapper: (data, _) => data.color,
//             dataLabelSettings: const DataLabelSettings(
//               isVisible: true,
//               labelPosition: ChartDataLabelPosition.outside,
//               connectorLineSettings: ConnectorLineSettings(
//                 type: ConnectorType.curve,
//                 length: '15%',
//               ),
//               textStyle: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ChartData {
//   final String category;
//   final int value;
//   final Color color;

//   _ChartData(this.category, this.value, this.color);
// }