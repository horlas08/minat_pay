import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/font.constant.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? showAction;

  const AppHeader({super.key, required this.title, this.showAction = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: AppFont.mulish,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        showAction == true
            ? TextButton(
                onPressed: () {
                  context.pushNamed('transactions');
                },
                child: const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: AppFont.mulish,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const SizedBox()
      ],
      // iconTheme: BlocBuilder<AppConfigCubit, App>(
      //   builder: (context, state) {
      //     return IconThemeData(
      //       color: isLight(context) ? Colors.black : Colors.white,
      //     );
      //   },
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
