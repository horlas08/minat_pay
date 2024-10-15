import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/register/register_bloc.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/cubic/app_config_cubit.dart';
import 'package:minat_pay/cubic/theme_config_cubit.dart';
import 'package:minat_pay/model/app.dart';
import 'package:minat_pay/router/index.dart';
import 'package:minat_pay/service/http.dart';
import 'package:minat_pay/theme/theme_config.dart';
import 'package:minat_pay/theme/theme_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'cubic/login_verify/login_verify_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  final patchNumber = await ShorebirdCodePush().currentPatchNumber();
  await ThemeService.instance;

  await initialize();

  configureDio();
  await initialization();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://6f48c0a0b35cea0c262852b20fa06a4c@o4507321451937792.ingest.us.sentry.io/4507967557337088';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      // Note: Profiling alpha is available for iOS and macOS since SDK version 7.12.0
      options.profilesSampleRate = 1.0;
    },
    appRunner: () {
      Sentry.configureScope((scope) {
        scope.setTag('shorebird_patch_number', '$patchNumber');
      });
      return runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) => LoginVerifyCubit(),
            ),
            BlocProvider(
              create: (BuildContext context) => AppBloc(),
            ),
          ],
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends HookWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pref = ThemeService.prefs;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (contents) => RegisterBloc(),
        ),
        BlocProvider(create: (contents) => ThemeConfigCubit()..getThemeMode()),
        BlocProvider(create: (contents) => AppConfigCubit())
      ],
      child: BlocBuilder<AppConfigCubit, App>(
        builder: (context, state) {
          return GlobalLoaderOverlay(
            useDefaultLoading: false,
            overlayWidgetBuilder: (_) {
              return const Center(
                child: SpinKitCubeGrid(
                  color: AppColor.primaryColor,
                  size: 50.0,
                ),
              );
            },
            //context.watch<AppConfigCubit>().state.themeMode == 'dark'
            overlayColor: pref.getString("theme") == 'light'
                ? Colors.white.withOpacity(0.4)
                : Colors.black.withOpacity(0.4),

            child: ThemeProvider(
              themeModel: ThemeModel(
                themeMode: context.watch<AppConfigCubit>().state.autoTheme
                    ? ThemeMode.system
                    : context.watch<AppConfigCubit>().state.themeMode == 'light'
                        ? ThemeMode.light
                        : ThemeMode.dark,
                lightTheme: lightTheme,
                darkTheme: darkTheme,
              ),
              builder: (context, themeModel) {
                return MaterialApp.router(
                  title: 'Minat Pay',
                  theme: themeModel.lightTheme,
                  darkTheme: themeModel.darkTheme,
                  themeMode: themeModel.themeMode,
                  routerConfig: AppRouter.router,
                  debugShowCheckedModeBanner: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Future<void> initialization() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: 'minatpay-67c72');
}
