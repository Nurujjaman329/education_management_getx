// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class FullImageViewScreen extends StatelessWidget {
//   final String imageUrl;
//   final String? tag; // Optional Hero tag

//   const FullImageViewScreen({
//     Key? key,
//     required this.imageUrl,
//     this.tag,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final imageWidget = InteractiveViewer(
//       minScale: 0.5,
//       maxScale: 4.0,
//       child: CachedNetworkImage(
//         imageUrl: imageUrl,
//         fit: BoxFit.contain,
//         placeholder: (_, __) => const Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//             strokeWidth: 2,
//           ),
//         ),
//         errorWidget: (_, __, ___) => const Icon(
//           Icons.broken_image,
//           size: 64,
//           color: Colors.white70,
//         ),
//         fadeInDuration: const Duration(milliseconds: 300),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           Center(
//             child: tag != null
//                 ? Hero(tag: tag!, child: imageWidget)
//                 : imageWidget,
//           ),
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 8,
//             left: 8,
//             child: IconButton(
//               icon: const Icon(Icons.close, color: Colors.white, size: 28),
//               onPressed: () => Navigator.of(context).pop(),
//               tooltip: 'Close',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
