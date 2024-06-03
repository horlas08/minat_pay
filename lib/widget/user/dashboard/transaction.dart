import 'package:flutter/material.dart';
import 'package:minat_pay/data/transaction_res.dart';
import 'package:minat_pay/widget/user/dashboard/transaction_item.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../config/color.constant.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Transaction",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              TouchableOpacity(
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
            height: 30,
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
                itemCount: TransactionRes().data.length,
                itemBuilder: (context, index) {
                  return const TransactionItem();
                }),
          ),
        ],
      ),
    );
  }
}
