import 'package:flutter/material.dart';
import 'package:flowershop/utils/colors_const.dart';

import 'cached_network_images.dart';

class ImageDetailView extends StatelessWidget {
  ImageDetailView({required this.url, super.key});
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.black,
      body: Stack(children: [
        Center(child: NetworkImageWidget(imageUrl: url)),
        Positioned(
          top: 26,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ]),
    );
  }
}
