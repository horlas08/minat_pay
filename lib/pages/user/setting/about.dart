import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_state.dart';
import '../../../helper/helper.dart';

class About extends HookWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    Future lunchUrl(String path, {bool fullLink = false}) async {
      const url = 'https://minatpay.com';
      try {
        final Uri _url = !fullLink ? Uri.parse('$url/$path') : Uri.parse(path);
        await launchUrl(_url);
      } catch (error) {
        if (context.mounted) {
          await alertHelper(context, 'error', error.toString());
        }
      }
    }

    const double space = 15;
    return Scaffold(
      appBar: const AppHeader(title: "About App"),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
        ),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, appState) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TouchableOpacity(
                        onTap: () async {
                          await lunchUrl('about-us');
                        },
                        behavior: HitTestBehavior.deferToChild,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "About Us",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ]),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: space,
                ),
                Container(
                  padding: const EdgeInsets.all(
                    18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TouchableOpacity(
                        onTap: () async {
                          await lunchUrl('terms-conditions');
                        },
                        behavior: HitTestBehavior.deferToChild,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ]),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: space,
                ),
                Container(
                  padding: const EdgeInsets.all(
                    18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TouchableOpacity(
                        onTap: () async {
                          await lunchUrl('privacy-policy');
                        },
                        behavior: HitTestBehavior.deferToChild,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ]),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: space,
                ),
                Container(
                  padding: const EdgeInsets.all(
                    18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TouchableOpacity(
                        onTap: () async {
                          await lunchUrl('https://onelink.to/wvqk9p',
                              fullLink: true);
                        },
                        behavior: HitTestBehavior.deferToChild,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Rate App On PlayStore",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ]),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: space,
                ),
              ],
            );
          },
        ),
      )),
    );
  }
}
