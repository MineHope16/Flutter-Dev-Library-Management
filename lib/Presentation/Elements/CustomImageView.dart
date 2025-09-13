import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CommonImageView extends StatelessWidget {
// ignore_for_file: must_be_immutable
  String? url;
  String? imagePath;
  String? svgPath;
  File? file;
  double? height;
  double? width;
  BorderRadiusGeometry? borderRadius;
  final BoxFit fit;
  final String? placeHolder;
  Color? svgColor;
  double? scale;


  CommonImageView({
    super.key,
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.svgColor,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.scale,
    this.placeHolder,
  });

  @override
  Widget build(BuildContext context) {
    return _buildImageView();
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return Animate(
        effects: [FadeEffect(duration: Duration(milliseconds: 1000))],
        child: SizedBox(
          height: height,
          width: width,
          // child: SvgPicture.asset(
          //   svgPath!,
          //   height: height ?? 24,
          //   width: width ?? 24,
          //   fit: fit,
          //   color: svgColor,
          // ),
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Animate(
        effects: const [FadeEffect(duration: Duration(milliseconds: 500))],
        child: ClipRRect(
          borderRadius: borderRadius ??  BorderRadius.circular(0),
          child: Image.file(
            file!,
            height: height,
            width: width,
            fit: fit,
          ),
        ),
      );
    } else if (url != null && url!.isNotEmpty) {
      // return Animate(
      //   effects: const [FadeEffect(duration: Duration(milliseconds: 500))],
      //   child: ClipRRect(
      //     borderRadius: borderRadius ?? BorderRadius.circular(00),
      //     child: CachedNetworkImage(
      //       height: height,
      //       width: width,
      //       fit: fit,
      //       imageUrl: url!,
      //       placeholder: (context, url) => SizedBox(
      //         height: height ?? 23,
      //         width: width ?? 23,
      //         child: Center(
      //           child: SizedBox(
      //             height: 20,
      //             width: 20,
      //             child: CircularProgressIndicator(
      //               color: Colors.black,
      //               backgroundColor: Colors.grey.shade100,
      //             ),
      //           ),
      //         ),
      //       ),
      //       errorWidget: (context, url, error) => _buildErrorWidget(),
      //     ),
      //   ),
      // );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Animate(
        effects: const [FadeEffect(duration: Duration(milliseconds: 500))],
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          child: Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit,
            scale: scale,
            color: svgColor,
            errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildErrorWidget() {
    if (placeHolder != null && placeHolder!.isNotEmpty) {
      return Image.asset(
        placeHolder!,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackWidget(),
      );
    }
    return _buildFallbackWidget();
  }

  Widget _buildFallbackWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius ?? BorderRadius.circular(00),
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: (height != null && width != null)
            ? (height! < width! ? height! * 0.6 : width! * 0.6)
            : 24,
      ),
    );
  }
}