import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/pages/auth/EmailVerification/email_verify_view.dart';
import 'package:minat_pay/pages/auth/Login/login_view.dart';
import 'package:minat_pay/pages/auth/Register/register_view.dart';
import 'package:minat_pay/pages/user/ChangePassword/change_password.dart';
import 'package:minat_pay/pages/user/ChangePin/change_pin.dart';
import 'package:minat_pay/pages/user/bills/airtime/airtime.dart';
import 'package:minat_pay/pages/user/bills/all_bills.dart';
import 'package:minat_pay/pages/user/bills/betting/betting.dart';
import 'package:minat_pay/pages/user/bills/cable/cable.dart';
import 'package:minat_pay/pages/user/bills/electricity/electricity.dart';
import 'package:minat_pay/pages/user/bills/funds/add_fund.dart';
import 'package:minat_pay/pages/user/bills/transfer/transfer.dart';
import 'package:minat_pay/pages/user/setting/app_settings.dart';
import 'package:minat_pay/pages/user/setting/profile.dart';
import 'package:minat_pay/pages/user/transaction/receipt.dart';
import 'package:minat_pay/router/scaffold_with_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubic/app_config_cubit.dart';
import '../pages/auth/ForgotPassword/forgot_password_view.dart';
import '../pages/auth/Login/login_verify_view.dart';
import '../pages/auth/onboard/screen.dart';
import '../pages/user/Dashboard/view.dart';
import '../pages/user/bills/data/data.dart';
import '../pages/user/support/support.dart';
import '../pages/user/transaction/all_transaction.dart';
import '../pages/user/transaction/transaction_detail.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
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
            redirect: (context, state) async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String? token = prefs.getString("token");
              bool? isVerified = prefs.getBool("isVerified");
              String? userEmail = prefs.getString("userEmail");
              if (token != null &&
                  isVerified != null &&
                  !isVerified &&
                  userEmail != null) {
                return '/email/verify/$userEmail';
              }
              return null;
            },
          ),
          GoRoute(
            path: 'email/verify/:email',
            name: 'email_verification',
            builder: (context, state) => EmailVerifyPage(
              email: state.pathParameters['email']!,
            ),
          ),
          GoRoute(
            path: 'login/verify/:username',
            name: 'login_verify',
            builder: (BuildContext context, GoRouterState state) =>
                LoginVerifyPage(username: state.pathParameters['username']!),
          ),
        ],
        redirect: (context, state) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("token");
          String? username = prefs.getString("userName");
          String? email = prefs.getString("userEmail");
          bool? isVerified = prefs.getBool("isVerified");
          if (token != null &&
              context.mounted &&
              isVerified! &&
              !context.read<AppConfigCubit>().state.authState) {
            return '/login/verify/$username';
          } else if (token != null &&
              context.mounted &&
              isVerified! &&
              context.read<AppConfigCubit>().state.authState) {
            return '/user';
          }
          return null;
        },
      ),
      GoRoute(
          path: '/bills',
          name: 'allBills',
          builder: (BuildContext context, GoRouterState state) {
            return const AllBills();
          },
          routes: [
            GoRoute(
              path: 'transfer',
              name: 'transfer',
              builder: (context, state) {
                return const Transfer();
              },
            ),
            GoRoute(
              path: 'betting',
              name: 'betting',
              builder: (context, state) {
                return const Betting();
              },
            ),
            GoRoute(
              path: 'cable',
              name: 'cable',
              builder: (context, state) {
                return const Cable();
              },
            ),
            GoRoute(
              path: 'fund',
              name: 'fund',
              builder: (BuildContext context, GoRouterState state) {
                return const AddFund();
              },
            ),
            GoRoute(
              path: 'electricity',
              name: 'electricity',
              builder: (BuildContext context, GoRouterState state) {
                return const Electricity();
              },
            )
          ]),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          return const Profile();
        },
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (BuildContext context, GoRouterState state) {
          return const Support();
        },
      ),
      GoRoute(
          path: '/transaction',
          name: 'transactions',
          builder: (BuildContext context, GoRouterState state) {
            return const AllTransaction();
          },
          routes: [
            GoRoute(
              path: 'details/:id',
              name: 'transactionDetails',
              builder: (BuildContext context, GoRouterState state) {
                return TransactionDetail(
                  id: state.pathParameters['id']!,
                );
              },
            ),
            GoRoute(
              path: 'receipt',
              name: 'transactionReceipt',
              builder: (BuildContext context, GoRouterState state) {
                return Receipt();
              },
            )
          ]),
      GoRoute(
        path: '/change/pin',
        name: 'changePin',
        builder: (context, state) {
          return ChangePin();
        },
      ),
      GoRoute(
        path: '/change/password',
        name: 'changePassword',
        builder: (context, state) {
          return ChangePassword();
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          /// The first screen to display in the bottom navigation bar.
          GoRoute(
            path: '/user',
            name: 'dashboard',
            builder: (BuildContext context, GoRouterState state) {
              return const Dashboard();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'data',
                builder: (BuildContext context, GoRouterState state) {
                  return const Data();
                },
              ),
              GoRoute(
                path: 'airtime',
                builder: (BuildContext context, GoRouterState state) {
                  return const Airtime();
                },
              ),
              GoRoute(
                path: 'setting',
                builder: (BuildContext context, GoRouterState state) {
                  return const AppSettings();
                },
              ),
            ],
            redirect: (context, state) async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String? token = prefs.getString("token");
              String? username = prefs.getString("userName");
              String? userEmail = prefs.getString("userEmail");
              bool? isVerified = prefs.getBool("isVerified");
              if (token == null) {
                return '/login';
              } else if (!isVerified!) {
                return '/email/verify/$userEmail';
              } else if (context.mounted &&
                  isVerified &&
                  !context.read<AppConfigCubit>().state.authState) {
                return null;
              }
              return null;
            },
          ),
        ],
      ),
    ],
  );
}
