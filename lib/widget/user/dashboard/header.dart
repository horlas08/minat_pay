import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';

import '../../../bloc/repo/app/app_state.dart';
import '../../../helper/helper.dart';

class UserHeader extends HookWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = context.read<AppBloc>().state.user;

    final date = DateTime.timestamp();

    return Row(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              return CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  state.user!.photo!,
                ),
              );
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Good Morning"),
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return Text(
                  '${state.user?.firstName!}',
                  // "${user?.firstName}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
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
        IconButton(
          onPressed: () {
            context.pushNamed("support");
          },
          icon: SvgPicture.asset(
            'assets/svg/support.svg',
            height: 25,
            color: isLight(context) ? Colors.black : Colors.white,
          ),
        )
      ],
    );
  }
}
