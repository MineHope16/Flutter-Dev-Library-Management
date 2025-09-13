import 'package:flutter/material.dart';
import 'package:openlibrary_book_explorer/Providers/ChangeModeProvider.dart';
import 'package:provider/provider.dart';


class MyButton extends StatelessWidget {
  final String? btnLabel;
  final void Function() onPressed;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? letterSpacing;
  final bool isLoading;
  final Border? border;
  final String? fontFamily;
  final BorderRadius? borderRadius;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingRight;
  final double? paddingLeft;

  const MyButton({
    super.key,
    required this.btnLabel,
    required this.onPressed,
    this.color,
    this.paddingTop,
    this.paddingBottom,
    this.paddingRight,
    this.paddingLeft,
    this.textColor,
    this.height,
    this.width,
    this.border,
    this.letterSpacing,
    this.fontSize,
    this.fontFamily,
    this.borderRadius,
    this.fontWeight,
    this.isLoading = false,
    this.textStyle,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(
          left: paddingLeft ?? 0,
          right: paddingRight ?? 0,
          top: paddingTop ?? 0,
          bottom: paddingBottom ?? 0,
        ),
        child: Container(
          margin: margin,
          padding: padding,
          height: height ?? 55,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            border: border,
            color: color ?? themeProvider.buttonBackgroundColor,
          ),
          child: Center(

            child: Text(
              btnLabel!,
              style:
                  textStyle ??
                  TextStyle(
                    fontFamily: fontFamily ?? 'Poppins',
                    fontSize: fontSize ?? 18,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    letterSpacing: letterSpacing ?? 0,
                    color: textColor ?? themeProvider.buttonTextColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
