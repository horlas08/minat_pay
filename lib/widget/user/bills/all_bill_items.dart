import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class AllBillItems extends StatelessWidget {
  final String name;
  final IconData icon;
  final IconData? arrow;
  final VoidCallback onTap;
  const AllBillItems(
      {super.key,
      required this.name,
      required this.icon,
      this.arrow,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.primaryColor.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Text(
              name,
              style: const TextStyle(
                fontSize: 25,
                fontFamily: AppFont.aeonik,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(arrow ?? Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
