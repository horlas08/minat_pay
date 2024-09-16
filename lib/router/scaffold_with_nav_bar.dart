import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/user/bottom_nav.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: BottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    print(location);

    if (location == ('/user/data')) {
      return 1;
    } else if (location == ('/user/airtime')) {
      return 2;
    } else if (location == ('/user/setting')) {
      return 3;
    } else if (location == '/user') {
      return 0;
    }
    return 1;
  }

  void _onItemTapped(int index, BuildContext context) {
    // final location = GoRouterState.of(context).uri;
    print(_calculateSelectedIndex(context));
    print(index);

    switch (index) {
      case 0:
        GoRouter.of(context).go('/user');
      case 1:
        GoRouter.of(context).go('/user/data');
      case 2:
        GoRouter.of(context).go('/user/airtime');
      case 3:
        GoRouter.of(context).go('/user/setting');
    }
  }
}
