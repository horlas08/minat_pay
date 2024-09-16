import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/user/bottom_nav_item.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const BottomNav({required this.currentIndex, super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 87,
      margin: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 17,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: BottomNavItem(
                      onTap: onTap,
                      icon: "wallet-3-fill.svg",
                      current: currentIndex,
                      name: 0,
                      label: 'Home',
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      onTap: onTap,
                      icon: "line-chart-line.svg",
                      current: currentIndex,
                      name: 2,
                      label: 'Airtime',
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      onTap: onTap,
                      icon: "sim-card-2-line.svg",
                      current: currentIndex,
                      name: 1,
                      label: 'Data',
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      onTap: onTap,
                      icon: "settings-fill.svg",
                      current: currentIndex,
                      name: 3,
                      label: 'Settings',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
