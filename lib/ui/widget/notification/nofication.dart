// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fafte/generated/l10n.dart';
// import 'package:fafte/theme/app_theme.dart';
// import 'package:fafte/theme/colors.dart';
// import 'package:fafte/theme/sizes.dart';
// import 'package:fafte/theme/text_style.dart';
// import 'package:fafte/ui/widget/container/spacing_box.dart';

// void showErrorSnackbar(String error) {
//   Get.snackbar(
//     S.current.error,
//     error,
//     backgroundColor: Colors.red.withOpacity(0.5),
//     colorText: Colors.white,
//   );
// }

// void showSnackbar(String? title, String? content, {bool isSuccess = false}) {
//   Get.snackbar(
//     title ?? "From VComply:",
//     content ?? "",
//     backgroundColor: isSuccess ? green.withOpacity(0.5) : null,
//   );
// }

// class NotificationMessage extends StatelessWidget {
//   final NotificationMessageType type;
//   final String message;
//   final Color? backgroundColor;
//   final String? action;
//   final void Function()? actionTap;

//   const NotificationMessage(
//       {Key? key,
//       this.type = NotificationMessageType.success,
//       this.message = '',
//       this.backgroundColor,
//       this.action,
//       this.actionTap})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Color? bgColor = backgroundColor;
//     // If background color is not passed, set background color base on
//     // notification type (success, failure)
//     bgColor ??= type == NotificationMessageType.success
//         ? getColor(context).bgFrostedGlass
//         : getColor(context).bgFrostedGlass;
//     final IconData icon = type == NotificationMessageType.success
//         ? Icons.check_circle_outline_rounded
//         : Icons.block_rounded;
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: const BorderRadius.all(Radius.circular(10))),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: getColor(context).iconColorPrimary,
//           ),
//           SpacingBox(
//             h: Sizes.s10,
//           ),
//           Expanded(
//             child: Text(
//               message,
//               style: ptBody(context),
//             ),
//           ),
//           if (action != null)
//             GestureDetector(
//               onTap: actionTap,
//               child: Padding(
//                 padding: EdgeInsets.only(right: Sizes.s5),
//                 child: Text(
//                   action!,
//                   style: ptBody(context).copyWith(
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }

// enum NotificationMessageType { success, failure }
