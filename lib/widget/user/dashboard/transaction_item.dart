import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/helper/helper.dart';

List<String> transactionList = [];
String getTimeFromDateAndTime(String date) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat.jm().format(dateTime).toString(); //5:08 PM
// String formattedTime = DateFormat.Hms().format(now);
// String formattedTime = DateFormat.Hm().format(now);   // //17:08  force 24 hour time
  } catch (e) {
    return date;
  }
}

String getDateAndYearWordFromString(String date) {
  DateTime dateTime;
  try {
    dateTime = DateTime.parse(date).toLocal();
    return DateFormat.yMMMMd('en_US').format(dateTime).toString(); //5:08 PM
// String formattedTime = DateFormat.Hms().format(now);
// String formattedTime = DateFormat.Hm().format(now);   // //17:08  force 24 hour time
  } catch (e) {
    return date;
  }
}

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const TransactionItem({super.key, required this.data});

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
            child: Text(
              data['type'].toString().split('')[0],
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['type'],
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: AppFont.mulish, fontWeight: FontWeight.bold),
              ),
              Text(
                getDateAndYearWordFromString(data['datetime']),
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${currency(context)}${data['amount'].toString()}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFamily: AppFont.mulish, fontWeight: FontWeight.bold),
              ),
              Text(
                style: Theme.of(context).textTheme.labelSmall,
                getTimeFromDateAndTime(data['datetime']),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
