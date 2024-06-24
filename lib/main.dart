import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/register/register_bloc.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/cubic/app_config_cubit.dart';
import 'package:minat_pay/cubic/theme_config_cubit.dart';
import 'package:minat_pay/model/app.dart';
import 'package:minat_pay/router/index.dart';
import 'package:minat_pay/service/http.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  configureDio();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const MyApp());
}

final ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor).copyWith(
      primary: AppColor.primaryColor, secondary: AppColor.secondaryColor),
  useMaterial3: true,
  fontFamily: AppFont.aeonik,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 40),
    titleMedium: TextStyle(
      fontSize: 25,
    ),
    bodyLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.w900, fontFamily: AppFont.mulish),
    titleSmall: TextStyle(
      fontSize: 15,
    ),
    labelSmall: TextStyle(color: AppColor.greyColor),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
    fillColor: AppColor.greyLightColor.withOpacity(0.1),
    filled: true,
    errorMaxLines: 2,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColor.greyColor,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColor.danger,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColor.danger,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    errorStyle: const TextStyle(
        color: AppColor.danger,
        fontSize: 12,
        fontFamily: AppFont.mulish,
        fontWeight: FontWeight.bold),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColor.greyColor,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColor.primaryColor,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    ),

    // contentPadding: EdgeInsets.all(8),
    hintStyle: const TextStyle(
      color: AppColor.primaryColor,
      fontFamily: AppFont.mulish,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColor.primaryColor),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
                //ignored progress for the moment
                return const Center(
                  child: SpinKitCubeGrid(
                    color: AppColor.primaryColor,
                    size: 50.0,
                  ),
                );
              },
              overlayColor:
                  context.watch<AppConfigCubit>().state.themeMode == 'dark'
                      ? Colors.white
                      : Colors.black,
              child: MaterialApp.router(
                title: 'MinatPay',
                theme: themeData,
                darkTheme: themeData.copyWith(
                  scaffoldBackgroundColor: Colors.black.withOpacity(0.4),
                  textTheme: const TextTheme(
                    titleLarge: TextStyle(fontSize: 40),
                    titleMedium: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    bodyLarge: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: AppFont.mulish),
                    titleSmall: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    labelSmall: TextStyle(
                      // color: AppColor.greyColor,
                      color: Colors.white,
                    ),
                  ),
                ),
                themeMode:
                    context.watch<AppConfigCubit>().state.themeMode == 'dark'
                        ? ThemeMode.dark
                        : ThemeMode.light,
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
              ));
        },
      ),
    );
  }
}
