import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';

class Button extends StatelessWidget {
  final VoidCallback? onpressed;
  final Widget child;
  final bool? isDisabe;

  const Button(
      {super.key,
      required this.onpressed,
      required this.child,
      this.isDisabe = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onpressed!(),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDisabe != null && isDisabe == true
                ? AppColor.greyColor
                : AppColor.primaryColor),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
