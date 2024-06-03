import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/config/color.constant.dart';

class QuickActionItem extends StatelessWidget {
  final String route;
  final IconData icon;
  final String title;
  const QuickActionItem(
      {super.key,
      required this.route,
      required this.icon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.blueColor.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              size: 40,
              color: AppColor.blueColor,
            ),
            // child: AnimateIcon(
            //   key: UniqueKey(),
            //   onTap: () {},
            //   iconType: IconType.continueAnimation,
            //   height: 70,
            //   width: 70,
            //   color: Color.fromRGBO(
            //       Random.secure().nextInt(255),
            //       Random.secure().nextInt(255),
            //       Random.secure().nextInt(255),
            //       1),
            //   animateIcon: AnimateIcons.tune,
            // ),
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
