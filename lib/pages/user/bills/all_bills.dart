import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/data/mock/dummy_data.dart';
import 'package:minat_pay/widget/user/bills/all_bill_items.dart';

import '../../../config/font.constant.dart';

class AllBills extends StatelessWidget {
  const AllBills({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Bills",
          style: TextStyle(
              fontSize: 20,
              fontFamily: AppFont.mulish,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  return AllBillItems(
                    name: allBills[index]['name'],
                    icon: allBills[index]['icon'],
                    onTap: () {
                      context.pushReplacement(
                        allBills[index]['route'],
                      );
                    },
                  );
                },
                itemCount: allBills.length,
              ),
            ],
          )),
    );
  }
}
