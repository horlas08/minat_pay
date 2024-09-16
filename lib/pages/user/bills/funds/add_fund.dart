import 'package:flutter/material.dart';
import 'package:minat_pay/pages/user/bills/funds/method/bank.dart';
import 'package:minat_pay/pages/user/bills/funds/method/coupon.dart';
import 'package:minat_pay/pages/user/bills/funds/method/manual.dart';

import '../../../../config/font.constant.dart';

class AddFund extends StatelessWidget {
  const AddFund({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Fund Your Account',
            style: TextStyle(
              fontSize: 20,
              fontFamily: AppFont.mulish,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppFont.mulish,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.account_balance),
                text: "Bank Transfer",
              ),
              Tab(
                icon: Icon(Icons.local_atm),
                text: "Manual Deposit",
              ),
              Tab(
                icon: Icon(Icons.code_off),
                text: "Coupon Code",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Bank(),
            Manual(),
            Coupon(),
          ],
        ),
      ),
    );
  }
}
