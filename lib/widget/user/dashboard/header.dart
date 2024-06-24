import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/cubic/app_config_cubit.dart';
import 'package:minat_pay/model/app.dart';

class UserHeader extends HookWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // final status = useState(false);
    return Row(
      children: [
        const SizedBox(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good Morning"),
            Text(
              "SMD TECH",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Which Bill Would You Like To Pay?",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.notifications),
            SizedBox(
              // width: 20,
              // height: 10,
              child: BlocConsumer<AppConfigCubit, App>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return FlutterSwitch(
                    width: 55.0,
                    height: 30.0,
                    valueFontSize: 15.0,
                    toggleSize: 20.0,
                    value: state.themeMode == 'light',
                    borderRadius: 30.0,
                    padding: 4.0,
                    activeIcon: const Icon(
                      Icons.sunny_snowing,
                      size: 15,
                    ),
                    inactiveIcon: const Icon(
                      Icons.access_alarm,
                      size: 15,
                      color: Colors.black,
                    ),

                    activeColor: Colors.black,
                    inactiveColor: AppColor.primaryColor,
                    activeToggleColor: AppColor.primaryColor,
                    // showOnOff: true,
                    onToggle: (bool value) {
                      context
                          .read<AppConfigCubit>()
                          .changeThemeMode(value ? 'light' : 'dark');
                    },
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
