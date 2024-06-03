import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/user/bottom_nav_item.dart';

import '../../config/enum.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

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
                      onPress: () {},
                      icon: "wallet-3-fill.svg",
                      current: Menus.home,
                      name: Menus.home,
                      label: 'Home',
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      onPress: () {},
                      icon: "sim-card-2-line.svg",
                      current: Menus.home,
                      name: Menus.home,
                      label: 'Data',
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      onPress: () {},
                      icon: "line-chart-line.svg",
                      current: Menus.home,
                      name: Menus.home,
                      label: 'Airtime',
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      onPress: () {},
                      icon: "settings-fill.svg",
                      current: Menus.home,
                      name: Menus.home,
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
