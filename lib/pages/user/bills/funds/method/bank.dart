import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';

class Bank extends StatelessWidget {
  const Bank({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      child: Swiper(
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: const BoxDecoration(color: AppColor.primaryColor),
            child: SizedBox(
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: 300,
                    decoration: const BoxDecoration(color: AppColor.greyColor),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: 10,
        itemWidth: 300.0,
        itemHeight: 300,
        // layout: SwiperLayout.TINDER,
      ),
    ));
  }
}
