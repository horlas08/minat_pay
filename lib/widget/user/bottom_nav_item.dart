import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavItem extends StatelessWidget {
  final void Function(int) onTap;
  final String icon;
  final String label;
  final int current;
  final int name;

  const BottomNavItem(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.current,
      required this.name,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // print(name);
            // print(current);
            onTap(name);
          },
          child: SvgPicture.asset('assets/svg/$icon'),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: name == current ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
