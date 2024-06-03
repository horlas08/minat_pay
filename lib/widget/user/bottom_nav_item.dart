import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/enum.dart';

class BottomNavItem extends StatelessWidget {
  final VoidCallback onPress;
  final String icon;
  final String label;
  final Menus current;
  final Menus name;

  const BottomNavItem(
      {super.key,
      required this.onPress,
      required this.icon,
      required this.current,
      required this.name,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPress,
          icon: SvgPicture.asset('assets/svg/$icon'),
          padding: EdgeInsets.zero,
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
