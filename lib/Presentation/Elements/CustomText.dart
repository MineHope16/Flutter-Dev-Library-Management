import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/ChangeModeProvider.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  final String text;
  final bool? softWrap;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDecoration decoration;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final Color? color;
  final FontStyle? fontStyle;
  final VoidCallback? onTap;
  List<Shadow>? shadow;
  final int? maxLines;
  final Paint? paint;
  final double? size;
  final double? lineHeight;
  final double? paddingTop;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingBottom;
  final double? letterSpacing;
  final TextStyle? textStyle;
  final double? decorationThicknessValue;

  MyText({
    super.key,
    required this.text,
    this.size,
    this.lineHeight,
    this.softWrap,
    this.maxLines = 100,
    this.decoration = TextDecoration.none,
    this.color,
    this.paint,
    this.letterSpacing,
    this.fontWeight = FontWeight.w400,
    this.textAlign,
    this.textOverflow,
    this.fontFamily,
    this.paddingTop,
    this.paddingRight,
    this.paddingLeft,
    this.paddingBottom,
    this.onTap,
    this.shadow,
    this.fontStyle,
    this.textStyle,
    this.decorationThicknessValue
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: paddingLeft ?? 0,
          right: paddingRight ?? 0,
          top: paddingTop ?? 0,
          bottom: paddingBottom ?? 0,
        ),
        child: Text(
          softWrap: softWrap ?? false,
          text,
          style:
              textStyle ??
              TextStyle(
                foreground: paint,
                shadows: shadow,
                fontSize: size ?? 15,
                color: color ?? themeProvider.primaryTextColor,
                fontWeight: fontWeight,
                decoration: decoration,
                decorationColor: color,
                decorationThickness: decorationThicknessValue ?? 2,
                fontFamily: fontFamily ?? "Poppins",
                height: lineHeight,
                fontStyle: fontStyle,
                letterSpacing: letterSpacing ?? 0.2,
              ),
          textAlign: textAlign ?? TextAlign.start,
          // textDirection: TextDirection.ltr,
          maxLines: maxLines,
          overflow: textOverflow ?? TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
