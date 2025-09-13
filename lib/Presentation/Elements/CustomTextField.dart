import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final void Function()? onTap;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final double? height;
  final double? width;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;
  final bool readOnly;
  final double? prefixIconSize;
  final TextStyle? suffixStyle;
  final TextStyle? prefixStyle;
  final BoxConstraints? prefixIconConstraints;
  final TextStyle? inputTextStyle;
  final String? btnLabel;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final AutovalidateMode? autoValidateMode;
  final InputBorder? border;
  final InputBorder? enableBorder;
  final InputBorder? focusedBorder;
  final Color? backgroundColor;
  final Color? cursorColor;
  final Color? hintColor;
  final Color? textColor;
  final double? hintSize;
  final double? textSize;
  final int? hintMaxLines;
  final EdgeInsetsGeometry? containerMargin;
  final EdgeInsetsGeometry? containerPadding;
  final int? maxLines;
  final int? minLines;
  final TextAlign? textAlign;
  final String? initialTextValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool isPasswordField;
  final bool isSecure;
  final String? icon;
  final Widget? hint;
  final VoidCallback? onSuffixTap;
  final bool isSuffixIcon;
  final IconData? suffixIcon;
  final double? suffixIconHeight;
  final double? suffixIconWidth;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? textInputFormatters;
  final String? labelText;
  final BoxBorder? textFieldBorder;
  final bool removeBorder;
  final Color? prefixIconColor;
  final String? fontFamily;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingRight;
  final double? paddingLeft;
  final IconData? prefixIcon;
  final Color? prefixBasicIconColor;
  final String? obscuringCharacter;
  final Color? passwordIconColor;
  final Color? labelColor;
  final Color? suffixColor;
  final double? labelSize;


  const MyTextField({
    super.key,
    this.btnLabel,
    this.minLines,
    this.prefixBasicIconColor,
    this.prefixIconSize,
    this.fontFamily,
    this.onSuffixTap,
    this.initialTextValue,
    this.hintMaxLines,
    this.hintStyle,
    this.containerMargin,
    this.textColor,
    this.hintSize,
    this.focusNode,
    this.textAlign,
    this.textSize,
    this.prefixIconConstraints,
    this.backgroundColor,
    this.hintColor,
    this.cursorColor,
    this.controller,
    this.borderRadius,
    this.hintText,
    this.inputTextStyle,
    this.onTap,
    this.height,
    this.textInputAction,
    this.contentPadding,
    this.width,
    this.maxLines,
    this.readOnly = false,
    this.suffixStyle,
    this.prefixStyle,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.autoValidateMode,
    this.border,
    this.focusedBorder,
    this.enableBorder,
    this.containerPadding,
    this.decoration,
    this.isPasswordField = false,
    this.isSecure = false,
    this.icon,
    this.suffixIcon,
    this.isSuffixIcon = false,
    this.removeBorder = false,
    this.hint,
    this.suffixIconHeight,
    this.suffixIconWidth,
    this.textInputFormatters,
    this.onChanged,
    this.labelText,
    this.textFieldBorder,
    this.prefixIconColor,
    this.paddingBottom,
    this.paddingTop,
    this.paddingRight,
    this.paddingLeft,
    this.obscuringCharacter,
    this.passwordIconColor,
    this.suffixColor,
    this.labelColor,
    this.labelSize
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool isTextObscured;

  @override
  void initState() {
    super.initState();
    isTextObscured = widget.isSecure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.paddingLeft ?? 0,
        right: widget.paddingRight ?? 0,
        top: widget.paddingTop ?? 0,
        bottom: widget.paddingBottom ?? 0,
      ),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 56,
        // fixed height
        margin: widget.containerMargin,
        padding:
            widget.containerPadding ?? const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          color: widget.backgroundColor ?? Colors.white,
          border:
              widget.removeBorder
                  ? null
                  : (widget.textFieldBorder ??
                      Border.all(color: const Color(0xFF909090), width: 0.5)),
        ),
        child: Center(
          child: TextFormField(
            onChanged: widget.onChanged,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            focusNode: widget.focusNode,
            inputFormatters: widget.textInputFormatters,
            initialValue: widget.initialTextValue,
            textAlign: widget.textAlign ?? TextAlign.start,
            autovalidateMode: widget.autoValidateMode,
            onTap: widget.onTap,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.isPasswordField ? isTextObscured : false,
            obscuringCharacter: widget.obscuringCharacter ?? "*",
            readOnly: widget.readOnly,
            autofocus: false,
            maxLines: widget.maxLines ?? 1,
            minLines: widget.minLines ?? 1,
            validator: widget.validator,
            cursorColor: widget.cursorColor ?? Colors.black,
            decoration:
                widget.decoration ??
                InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: widget.labelColor ?? Colors.black,
                    fontSize: widget.labelSize ?? 20,
                    fontWeight: FontWeight.normal,
                  ),
                  isDense: true,
                  prefixIcon:
                      widget.prefixIcon != null ?
                          Icon(widget.prefixIcon, size: widget.prefixIconSize,) :
                      widget.prefixIcon == null && widget.icon != null && !widget.isSuffixIcon
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image.asset(
                              widget.icon!,
                              height: 20,
                              width: 20,
                              fit: BoxFit.contain,
                              color:
                                  widget.prefixIconColor ??
                                  const Color(0xff7B7B7B),
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.error, size: 20),
                            ),
                          )
                          : null,
                  prefixIconConstraints:
                      widget.prefixIconConstraints ??
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  suffixStyle: widget.suffixStyle,
                  suffixIcon:widget.suffixIcon != null ? Icon(widget.suffixIcon, size: 25, color: widget.suffixColor,) : widget.isPasswordField
                      ? IconButton(
                    icon: Icon(
                      isTextObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: widget.passwordIconColor ?? Colors.black,
                      size: 25,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        isTextObscured = !isTextObscured;
                      });
                    },
                  )
                      : widget.isSuffixIcon && widget.icon != null
                      ? GestureDetector(
                    onTap: widget.onSuffixTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset(
                        widget.icon!,
                        height: widget.suffixIconHeight ?? 20,
                        width: widget.suffixIconWidth ?? 20,
                        fit: BoxFit.contain,
                        color: const Color(0xff8697AC),
                        errorBuilder:
                            (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 20),
                      ),
                    ),
                  )
                      : null,
                  filled: false,
                  hintText: widget.hintText,
                  hint: widget.hint,
                  contentPadding:
                      widget.contentPadding ??
                      const EdgeInsets.symmetric(vertical: 16),
                  hintStyle:
                      widget.hintStyle ??
                      TextStyle(
                        fontFamily: 'Poppins',
                        color: widget.hintColor ?? const Color(0xFF909090),
                        fontSize: widget.hintSize ?? 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
            style:
                widget.inputTextStyle ??
                TextStyle(
                  color: widget.textColor ?? Colors.black,
                  fontFamily: "Poppins",
                  fontSize: widget.textSize ?? 15,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }
}
