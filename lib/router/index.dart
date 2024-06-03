import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/pages/auth/Dashboard/view.dart';
import 'package:minat_pay/pages/auth/Login/login_view.dart';
import 'package:minat_pay/pages/auth/Register/register_view.dart';

import '../pages/auth/onboard/screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
        // routes: <RouteBase>[
        //   GoRoute(
        //     path: 'details',
        //     builder: (BuildContext context, GoRouterState state) {
        //       return const DetailsScreen();
        //     },
        //   ),
        // ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (BuildContext context, GoRouterState state) =>
            const Dashboard(),
      ),
    ],
  );
}
