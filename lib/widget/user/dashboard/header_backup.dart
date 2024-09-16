import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/cubic/app_config_cubit.dart';
import 'package:minat_pay/model/app.dart';

import '../../../theme/theme_service.dart';

class UserHeader extends HookWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    final date = DateTime.timestamp();

    return ThemeSwitchingArea(
      child: Row(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                user!.photo!,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Good Morning"),
              Text(
                '${user.firstName}',
                // "${user?.firstName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Which Bill Would You Like To Pay?",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          const Spacer(),
          SizedBox(
            // width: 20,
            // height: 10,
            child: BlocConsumer<AppConfigCubit, App>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return ThemeSwitcher(
                  builder: (p0) {
                    return IconButton(
                      onPressed: () async {
                        final themeSwitcher = ThemeSwitcher.of(context);
                        print(themeSwitcher);
                        final themeName =
                            ThemeModelInheritedNotifier.of(context)
                                        .theme
                                        .brightness ==
                                    Brightness.light
                                ? 'dark'
                                : 'light';
                        final service = await ThemeService.instance
                          ..save(themeName);
                        final theme = service.getByName(themeName);
                        themeSwitcher.changeTheme(theme: theme);
                      },
                      icon: const Icon(Icons.brightness_3, size: 25),
                    );
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
