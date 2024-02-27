// import 'package:flutter/material.dart';
//
// class ICustomButton extends StatelessWidget {
//   final Widget icon;
//   final VoidCallback? onInterceptedTap;
//   final VoidCallback? onChildTap;
//
//   const ICustomButton({
//     Key? key,
//     required this.child,
//     this.onInterceptedTap,
//     this.onChildTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print("ontap");
//         // 首先执行拦截回调
//         onInterceptedTap?.call();
//
//         // 然后决定是否调用子Widget的onTap回调
//         onChildTap?.call();
//       },
//       // behavior: HitTestBehavior.translucent,
//       child: child,
//     );
//   }
//
// }



import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../core/setting.dart';

class ICustomButton extends StatelessWidget {
   Function() onPressed;
  final Widget icon;

  EdgeInsets? padding;
  ICustomButton({super.key, required this.icon, required  this.onPressed,  EdgeInsets? this.padding});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      onPressed: () async  {
        if(SettingConfig.ISVIBRATE){
          await Vibration.vibrate(duration: 50); // 500毫秒

        }

      onPressed();
    }, icon: icon,

    );
  }
}
