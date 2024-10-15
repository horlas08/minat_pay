import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/widget/app_header.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    return Scaffold(
      appBar: const AppHeader(
        title: "",
        showAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello ${user?.firstName}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "How can we help you today?",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FittedBox(
              child: SvgPicture.asset(
                "assets/svg/support_image.svg",
                height: 317,
                width: 214,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.support_agent_rounded),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Call center line",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "+2348139990000",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.email_outlined,
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email Us",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "hello@minatpay.com",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svg/WhatsappLogo.svg"),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Whatsapp line",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "+2348139990000",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
