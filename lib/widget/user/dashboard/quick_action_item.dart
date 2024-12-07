import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/config/color.constant.dart';

class QuickActionItem extends StatelessWidget {
  final String route;
  final String icon;
  final String title;
  const QuickActionItem({
    super.key,
    required this.route,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primaryColor.withOpacity(0.2),
            ),
            child: OverflowBox(
              fit: OverflowBoxFit.max,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 10,
                width: 10,
                child: SvgPicture.asset(
                  icon,
                  height: 7,
                  color: AppColor.primaryColor,
                  width: 4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            title,
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
