import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/pages/auth/Login/login_view.dart';
import 'package:minat_pay/pages/auth/Register/register_view.dart';

import '../pages/auth/ForgotPassword/forgot_password_view.dart';
import '../pages/auth/onboard/screen.dart';
import '../pages/user/Dashboard/view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'reset/password',
            name: 'reset_password',
            builder: (BuildContext context, GoRouterState state) {
              return ForgotPasswordPage();
            },
          ),
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (BuildContext context, GoRouterState state) =>
                const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (BuildContext context, GoRouterState state) =>
                const RegisterPage(),
          ),
        ],
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
