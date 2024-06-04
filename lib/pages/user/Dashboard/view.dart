import 'package:flutter/material.dart';
import 'package:minat_pay/widget/user/dashboard/balance_card.dart';
import 'package:minat_pay/widget/user/dashboard/header.dart';
import 'package:minat_pay/widget/user/dashboard/quick_action.dart';

import '../../../widget/user/bottom_nav.dart';
import '../../../widget/user/dashboard/transaction.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                UserHeader(),
                SizedBox(
                  height: 30,
                ),
                BalanceCard(),
                SizedBox(
                  height: 30,
                ),
                QuickAction(),
                Transaction()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
