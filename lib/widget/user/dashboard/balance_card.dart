import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/cubic/app_config_cubit.dart';
import 'package:minat_pay/model/app.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_state.dart';
import '../../../config/color.constant.dart';
import '../../../helper/helper.dart';

class BalanceCard extends HookWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> hideBalance = useState(false);

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, AppState state) {
        final List<Map<String, dynamic>> userData = [
          {
            'text': 'My Balance',
            'Number': state.user!.balance,
          },
          {
            'text': 'Referral Balance',
            'Number': state.user?.referrals,
          },
        ];
        return SizedBox(
          height: 200,
          child: Swiper(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            pagination: const SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: RectSwiperPaginationBuilder(
                color: Colors.white,
                // space: 1,
                size: Size(15, 10),
                activeSize: Size(25, 10),
                activeColor: Colors.amber,
              ),
              margin: EdgeInsets.only(top: 20),
            ),
            itemBuilder: (context, index) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userData[index]['text'],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TouchableOpacity(
                        onTap: () {
                          hideBalance.value = !hideBalance.value;
                        },
                        child: hideBalance.value
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.visibility_off),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (index == 0)
                    BlocBuilder<AppConfigCubit, App>(
                      builder: (context, buildState) {
                        final balance = double.tryParse(state.user!.balance!);
                        final currencyFormatter =
                            NumberFormat.currency(locale: "en_NG", symbol: "₦");
                        String formattedCurrency =
                            currencyFormatter.format(balance ?? 0.0);
                        if (buildState.enableShakeToHideBalance) {
                          return ShakeGesture(
                            onShake: () {
                              hideBalance.value = !hideBalance.value;
                            },
                            child: Text(
                              hideBalance.value ? formattedCurrency : "****",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: AppFont.mulish,
                                    fontSize: 27,
                                  ),
                            ),
                          );
                        } else
                          return Text(
                            "${currency(context)} ${hideBalance.value ? state.user?.balance : "****"}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: AppFont.mulish,
                                ),
                          );
                      },
                    )
                  else
                    Text(
                      "${hideBalance.value ? state.user?.refBal : "****"}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: AppFont.mulish,
                          ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (index == 0)
                    GestureDetector(
                      onTap: () => context.push('/bills/fund'),
                      // onTap: () => HapticFeedback.lightImpact(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(5),
                        width: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              child: CircleAvatar(
                                backgroundColor: AppColor.primaryColor,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Fund Wallet",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
