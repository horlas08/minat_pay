import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/cubic/login_verify/login_verify_state.dart';
import 'package:minat_pay/model/app.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_event.dart';
import '../../../cubic/app_config_cubit.dart';
import '../../../cubic/login_verify/login_verify_cubit.dart';
import '../../../helper/helper.dart';

final _formKey = GlobalKey<FormState>();
final LocalAuthentication auth = LocalAuthentication();

Future<bool> canAuth() async {
  return await auth.canCheckBiometrics && await auth.isDeviceSupported();
}

Future<List<BiometricType>> availableBiometrics() async {
  final List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();
  return availableBiometrics;
}

class LoginVerifyPage extends HookWidget {
  final String username;

  const LoginVerifyPage({required this.username, super.key});

  @override
  Widget build(BuildContext context) {
    final password = useRef('');
    final biometricAvailable = useState<bool>(false);

    useEffect(() {
      canAuth().then(
        (value) {
          if (value) {
            availableBiometrics().then(
              (availableBiometric) {
                if (availableBiometric.isNotEmpty &&
                        (availableBiometric.contains(BiometricType.face) ||
                            availableBiometric
                                .contains(BiometricType.strong)) ||
                    (availableBiometric.contains(BiometricType.weak) ||
                        availableBiometric
                            .contains(BiometricType.fingerprint))) {
                  biometricAvailable.value = true;
                }
              },
            );
          }
        },
      );

      return null;
    });
    ValueNotifier<bool> mounted = useState(false);

    return BlocListener<LoginVerifyCubit, LoginVerifyState>(
      listener: (context, state) async {
        if (state is LoginVerifyLoading) {
          context.loaderOverlay.show();
        } else if (state is LoginVerifyFailed) {
          context.loaderOverlay.hide();
          await alertHelper(context, 'error', state.message);
        } else if (state is LoginVerifySuccess) {
          context.loaderOverlay.hide();
          context.read<AppConfigCubit>().changeAuthState(true);
          if (!context.read<AppConfigCubit>().state.onboardSkip) {
            context.read<AppConfigCubit>().changeOnboardStatus(true);
          }
          context.read<AppBloc>().add(AddUserEvent(userData: state.userData));
          context
              .read<AppBloc>()
              .add(AddAccountEvent(accounts: state.accounts));

          context.go('/user');
        }
      },
      // child: WillPopScope(
      // onWillPop: () async {
      //   return await exitConfirmation(context);
      // },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/login/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: (MediaQuery.of(context).size.width / 2) - 30,
                      width: 60,
                      height: 150,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/login/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Welcome Back \n ${username}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "Enter Your Password",
                              ),
                              onChanged: (v) => {password.value = v},
                              initialValue: password.value,
                              onTapOutside: (v) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              validator: ValidationBuilder()
                                  .required()
                                  .build(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<LoginVerifyCubit>()
                                  .onLoginVerifyRequested(password.value);
                            }
                          },
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(
                              const Size.fromHeight(65),
                            ),
                          ),
                          child: const Text(
                            "Verify",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    BlocBuilder<AppConfigCubit, App>(
                      builder: (context, state) {
                        print(state);
                        if (state.enableFingerPrint) {
                          if (biometricAvailable.value) {
                            return FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: ElevatedButton(
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  try {
                                    final bool didAuthenticate =
                                        await auth.authenticate(
                                      localizedReason:
                                          'Please authenticate access your account',
                                      options: const AuthenticationOptions(
                                        biometricOnly: true,
                                        useErrorDialogs: true,
                                        stickyAuth: true,
                                        sensitiveTransaction: true,
                                      ),
                                      authMessages: const <AuthMessages>[
                                        AndroidAuthMessages(
                                          signInTitle:
                                              'Oops! Biometric authentication required!',
                                          cancelButton: 'No thanks',
                                        ),
                                        IOSAuthMessages(
                                          cancelButton: 'No thanks',
                                        ),
                                      ],
                                    );
                                    if (context.mounted) {
                                      if (didAuthenticate) {
                                        context
                                            .read<LoginVerifyCubit>()
                                            .onLoginVerifyRequested(null);
                                      } else {
                                        await alertHelper(context, 'error',
                                            "Biometric verification failed");
                                      }
                                    }

                                    // ···
                                  } on PlatformException catch (error) {
                                    if (context.mounted) {
                                      await alertHelper(
                                          context, 'error', error.toString());
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  side: const WidgetStatePropertyAll(
                                    BorderSide(
                                        color: AppColor.primaryColor, width: 2),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  minimumSize: WidgetStateProperty.all(
                                    const Size.fromHeight(65),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.fingerprint,
                                  size: 40,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            );
                          }
                        }
                        return SizedBox();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInLeftBig(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Switch Account?"),
                          const SizedBox(
                            width: 5,
                          ),
                          TouchableOpacity(
                            onTap: () async {
                              await handleLogOut(context);
                            },
                            child: Text(
                              "Logout",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
