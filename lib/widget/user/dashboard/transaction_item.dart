import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minat_pay/config/font.constant.dart';

List<String> transactionList = [];

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(
                  Random.secure().nextInt(255),
                  Random.secure().nextInt(255),
                  Random.secure().nextInt(255),
                  1),
            ),
            child: const Text(
              'B',
              style: TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                "Airtime",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: AppFont.mulish, fontWeight: FontWeight.bold),
              ),
              Text(
                "May 6 2024",
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                "-N120",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: AppFont.mulish, fontWeight: FontWeight.bold),
              ),
              Text(
                style: Theme.of(context).textTheme.labelSmall,
                "4:20 PM",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
