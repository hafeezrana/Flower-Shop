// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flowershop/model/userdata.dart';
// import 'package:flowershop/views/widgets/text_styles.dart';
//
// class TimelineStepper extends StatelessWidget {
//   TimelineStepper({required this.data, Key? key}) : super(key: key);
//
//   Level data;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         width: MediaQuery.of(context).size.width,
//         child: Stack(
//           children: [
//             // Vertical line
//             CustomPaint(
//               size: Size(MediaQuery.of(context).size.width, double.infinity),
//               painter: LinePainter(),
//             ),
//             // Text(
//             //   data['levels'].toString(),
//             //   style: MyTextStyles.smallText.copyWith(color: Colors.white54),
//             // ),
//
//             ListView(
//               children: data.levels!.map((level) {
//                 final idx = level.id!;
//
//                 bool isLeft = (idx % 2 == 0);
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Row(
//                         mainAxisAlignment: isLeft
//                             ? MainAxisAlignment.start
//                             : MainAxisAlignment.end,
//                         children: [
//                           if (isLeft) ...[
//                             // Left-aligned Expansion Tile Container
//                             Expanded(
//                               flex: 4,
//                               child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: level.status == 1
//                                       ? Colors.green
//                                       : Colors.blue,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       level.heading.toString(),
//                                       style: MyTextStyles.mediumL
//                                           .copyWith(color: Colors.white),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     // SubLevel Titles with Dynamic Color
//                                     ...level.subLevel!.map<Widget>((subLevel) {
//                                       return Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(4.0),
//                                             child: Container(
//                                               width: 5,
//                                               height: 5,
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.blue,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: Get.width / 2.5,
//                                             child: Text(
//                                               subLevel.title.toString(),
//                                               style: MyTextStyles.smallText
//                                                   .copyWith(
//                                                 color: Colors.black,
//                                               ),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     }).toList(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: 10,
//                               height: 10,
//                               decoration: BoxDecoration(
//                                 color: level.status == 1
//                                     ? Colors.green
//                                     : Colors.blue,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const Spacer(flex: 4), // Empty space on the right
//                           ],
//                           if (!isLeft) ...[
//                             const Spacer(flex: 4), // Empty space on the left
//                             // Connector Dot
//                             Container(
//                               width: 10,
//                               height: 10,
//                               decoration: BoxDecoration(
//                                 color: level.status == 1
//                                     ? Colors.green
//                                     : Colors.blue,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             Expanded(
//                               flex: 4,
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: level.status == 1
//                                       ? Colors.green
//                                       : Colors.blue,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       level.heading.toString(),
//                                       style: MyTextStyles.mediumL
//                                           .copyWith(color: Colors.white),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     // SubLevel Titles with Dynamic Color
//                                     ...level.subLevel!.map<Widget>((subLevel) {
//                                       return Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Row(
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(4.0),
//                                               child: Container(
//                                                 width: 5,
//                                                 height: 5,
//                                                 decoration: BoxDecoration(
//                                                   color:
//                                                       // subLevel.status == 1
//                                                       //     ?
//                                                       // Colors.green
//                                                       //     :
//                                                       Colors.blue,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: Get.width / 2.5,
//                                               child: Text(
//                                                 subLevel.title.toString(),
//                                                 style: MyTextStyles.smallText
//                                                     .copyWith(
//                                                   color:
//                                                       // subLevel.status == 1
//                                                       //     ? Colors.green
//                                                       //     :
//                                                       Colors.blue,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2;
//
//     // Draw vertical line from top to bottom
//     canvas.drawLine(
//         Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
