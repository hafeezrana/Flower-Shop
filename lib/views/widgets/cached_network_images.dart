import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowershop/utils/toast.dart';

class NetworkImageWidget extends StatelessWidget {
  NetworkImageWidget(
      {required this.imageUrl,
      this.height,
      this.width,
      this.boxFit,
      super.key});

  String imageUrl;
  double? height;
  double? width;
  BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.cover,
      placeholder: (context, url) => SizedBox(
        height: 50,
        width: 50,
        child: Center(
          // Center the CircularProgressIndicator
          child: ShowToast.loader(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 200.h,
        width: 200.h,
        color: Colors.grey,
        child: const Icon(Icons.error),
      ),
    );
  }
}
