import 'package:flutter/material.dart';

import 'CustomImageView.dart';

/// Container Widget
class MyContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final BoxConstraints? constraints;
  final GestureTapCallback? onTap;

  const MyContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.alignment,
    this.width,
    this.height,
    this.decoration,
    this.color,
    this.borderRadius,
    this.border,
    this.gradient,
    this.boxShadow,
    this.constraints,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration =
        decoration ??
        BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
          gradient: gradient,
          boxShadow: boxShadow,
        );

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      constraints: constraints,
      decoration: effectiveDecoration,
      child: child,
    );

    // Wrap with GestureDetector only if onTap is provided
    if (onTap != null) {
      container = GestureDetector(onTap: onTap, child: container);
    }
    return container;
  }
}

/// Icon Container Widget
class MyIconContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final IconData? icon;
  final double? iconSize;
  final double? width;
  final double? height;
  final double? iconHeight;
  final BoxDecoration? decoration;
  final Color? color;
  final Color? iconColor;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final GestureTapCallback? onTap;
  final String? iconAsset;

  const MyIconContainer({
    super.key,
    this.width,
    this.icon,
    this.iconSize,
    this.height,
    this.decoration,
    this.color,
    this.padding,
    this.margin,
    this.alignment,
    this.borderRadius,
    this.border,
    this.onTap,
    this.iconHeight,
    this.iconAsset,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      onTap: onTap,
      height: height ?? 30,
      width: width ?? 30,
      alignment: Alignment.center,
      decoration:
          decoration ??
          BoxDecoration(
            border: border,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            color: color ?? Colors.transparent,
          ),
      child:
          icon != null
              ? Icon(icon, size: iconSize, color: iconColor)
              : CommonImageView(
                imagePath: iconAsset,
                height: iconHeight ?? 24,
                // svgColor: iconColor ?? colors.textColorTypeGray,
              ),
    );
  }
}
