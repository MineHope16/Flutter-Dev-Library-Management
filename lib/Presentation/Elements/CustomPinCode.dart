// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
//
// class MyPinCode extends StatefulWidget {
//   final Function(String)? onChanged;
//   final Function(String)? onCompleted;
//   final Function(String)? onSubmitted;
//   final TextEditingController? controller;
//   final Color? color;
//   final bool readOnly;
//   final int length;
//
//   const MyPinCode({
//     super.key,
//     // this.onChanged,
//     this.onCompleted,
//     this.controller,
//     this.color,
//     this.onSubmitted,
//     this.readOnly = false,
//     required this.length,
//   });
//
//   @override
//   State<MyPinCode> createState() => _MyPinCodeState();
// }
//
// class _MyPinCodeState extends State<MyPinCode> {
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 48,
//       height: 48,
//       textStyle: TextStyle(
//         fontSize: 17,
//         color: colors.lessPrimaryColor,
//         fontWeight: FontWeight.w800,
//         letterSpacing: 1
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: Color(0xffE8E8E8),
//       ),
//     );
//
//     final focusedPinTheme = defaultPinTheme.copyWith(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: colors.lessPrimaryColor,
//         border: Border.all(color: colors.lessPrimaryColor, width: 1),
//       ),
//     );
//
//     return Pinput(
//       length: widget.length,
//       readOnly: widget.readOnly,
//       controller: widget.controller,
//       defaultPinTheme: defaultPinTheme,
//       focusedPinTheme: focusedPinTheme,
//       submittedPinTheme: defaultPinTheme,
//       textInputAction: TextInputAction.done,
//       hapticFeedbackType: HapticFeedbackType.lightImpact,
//       separatorBuilder: (index) => SizedBox(width: 26),
//       // errorPinTheme: defaultPinTheme.copyWith(
//       //   textStyle: const TextStyle(
//       //     fontSize: 18,
//       //     color: FrontendConfigs.kSecondaryColor,
//       //     fontWeight: FontWeight.w400,
//       //   ),
//       //   decoration: BoxDecoration(
//       //     borderRadius: BorderRadius.circular(4),
//       //     border: Border.all(color: FrontendConfigs.kPrimaryBlack, width: 1),
//       //   ),
//       // ),
//       onSubmitted: widget.onSubmitted,
//       onChanged: widget.onChanged,
//       onCompleted: widget.onCompleted,
//       inputFormatters: [
//         FilteringTextInputFormatter.deny(RegExp(r'\s')),
//       ],
//     );
//   }
// }
