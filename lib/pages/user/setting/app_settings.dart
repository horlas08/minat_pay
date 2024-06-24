import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';

import '../../../config/font.constant.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Settings',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppFont.mulish,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      const Positioned(
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/avatar.jpg"),
                          radius: 50,
                          backgroundColor: AppColor.success,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        // left: 0,
                        // right: 0,
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryColor,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("First Name"),
                Text("Qozeem"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
