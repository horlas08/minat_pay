import 'package:flutter/material.dart';

final List<Map<String, dynamic>> allBills = [
  {
    "icon": Icons.phone_iphone,
    "name": "Airtime",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/user/airtime"
  },
  {
    "icon": Icons.wifi,
    "name": "Data",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/user/data"
  },
  {
    "icon": Icons.lightbulb,
    "name": "Electricity",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/bills/electricity"
  },
  {
    "icon": Icons.tv,
    "name": "Cable",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/bills/cable"
  },
  {
    "icon": Icons.sports_baseball,
    "name": "Betting",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/bills/betting"
  },
  {
    "icon": Icons.telegram_outlined,
    "name": "Transfer",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/bills/transfer"
  },
  {
    "icon": Icons.phone_iphone,
    "name": "Add Funds",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/bills/fund"
  },
  {
    "icon": Icons.phone_iphone,
    "name": "Transfer",
    "arrow": Icons.arrow_forward_ios_rounded,
    "route": "/bills/transfer"
  },
];
final List<Map<String, dynamic>> providers = [
  {
    'id': 0,
    'name': 'Mtn',
    'logo': 'mtn_logo.jpg',
  },
  {
    'id': 1,
    'name': 'Glo',
    'logo': 'glo_logo.jpg',
  },
  {
    'id': 2,
    'name': 'Airtel',
    'logo': 'airtel_logo.png',
  },
  {
    'id': 3,
    'name': '9Mobile',
    'logo': '9mobile_logo.jpg',
  },
];
final List<Map<String, dynamic>> airtimePrice = [
  {
    'id': 0,
    'price': '50',
  },
  {
    'id': 1,
    'price': '100',
  },
  {
    'id': 2,
    'price': '200',
  },
  {
    'id': 3,
    'price': '500',
  },
  {
    'id': 4,
    'price': '1000',
  },
  {
    'id': 5,
    'price': '2000',
  },
];
final List<Map<String, dynamic>> bettingPrice = [
  {
    'id': 0,
    'price': '200',
  },
  {
    'id': 1,
    'price': '500',
  },
  {
    'id': 2,
    'price': '1000',
  },
  {
    'id': 3,
    'price': '2000',
  },
  {
    'id': 4,
    'price': '5000',
  },
  {
    'id': 5,
    'price': '10000',
  },
];