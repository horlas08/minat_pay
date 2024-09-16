import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/user/dashboard/quick_action_item.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class QuickAction extends StatelessWidget {
  const QuickAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Quick Action",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            TouchableOpacity(
              onTap: () => context.pushNamed('allBills'),
              activeOpacity: 0.4,
              child: Text(
                "View All",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mulish',
                    color: AppColor.blueColor),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionItem(
              route: '/user/airtime',
              icon: 'assets/svg/smartphone.svg',
              title: 'Airtime',
            ),
            QuickActionItem(
              route: '/user/data',
              icon: 'assets/svg/wifi.svg',
              title: 'Data',
            ),
            QuickActionItem(
              route: '/bills/electricity',
              icon: 'assets/svg/lightbulb.svg',
              title: 'Electricity',
            ),
            QuickActionItem(
              route: '/bills/betting',
              icon: 'assets/svg/basketball.svg',
              title: 'Betting',
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
