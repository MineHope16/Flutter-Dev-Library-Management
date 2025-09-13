import 'package:flutter/material.dart';

class MyRichText extends StatelessWidget {
  final List<InlineSpan> children;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  const MyRichText({
    super.key,
    required this.children,
    this.textAlign = TextAlign.start,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: children,
        style: textStyle ?? const TextStyle(fontFamily: "Poppins"),
      ),
    );
  }
}
