import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth/local_auth.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/cubic/login_verify/login_verify_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../cubic/login_verify/login_verify_cubit.dart';
import '../../../helper/helper.dart';

final _formKey = GlobalKey<FormState>();
final LocalAuthentication auth = LocalAuthentication();

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class LoginVerifyPage extends HookWidget {
  const LoginVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final password = useRef('');
    ValueNotifier<bool> _isAuthenticating = useState(false);
    ValueNotifier<String> _authorized = useState('Not Authorized');
    ValueNotifier<bool?> _canCheckBiometrics = useState(null);
    ValueNotifier<bool> mounted = useState(false);
    ValueNotifier<_SupportState> _supportState =
        useState(_SupportState.unknown);
    ValueNotifier<List<BiometricType>?> _availableBiometrics = useState(null);

    useEffect(() {
      auth.isDeviceSupported().then(
            (bool isSupported) => (_supportState.value = isSupported
                ? _SupportState.supported
                : _SupportState.unsupported),
          );
      return null;
    }, []);

    Future<void> _cancelAuthentication() async {
      await auth.stopAuthentication();
      _isAuthenticating.value = false;
    }

    Future<void> _authenticateWithBiometrics() async {
      ValueNotifier<bool> authenticated = useState(false);
      try {
        _isAuthenticating.value = true;
        _authorized.value = 'Authenticating';

        authenticated.value = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        _isAuthenticating.value = false;
        _authorized.value = 'Authenticating';
      } on PlatformException catch (e) {
        print(e);
        _isAuthenticating.value = false;
        _authorized.value = 'Error - ${e.message}';
        return;
      }
      if (!mounted.value) {
        return;
      }

      final String message =
          authenticated.value ? 'Authorized' : 'Not Authorized';
      _authorized.value = message;
    }

    Future<void> _checkBiometrics() async {
      late bool canCheckBiometrics;
      try {
        canCheckBiometrics = await auth.canCheckBiometrics;
      } on PlatformException catch (e) {
        canCheckBiometrics = false;
        print(e);
      }
      if (!mounted.value) {
        return;
      }

      _canCheckBiometrics.value = canCheckBiometrics;
    }

    Future<void> _getAvailableBiometrics() async {
      late List<BiometricType> availableBiometrics;
      try {
        availableBiometrics = await auth.getAvailableBiometrics();
      } on PlatformException catch (e) {
        availableBiometrics = <BiometricType>[];
        print(e);
      }
      if (!mounted.value) {
        return;
      }

      _availableBiometrics.value = availableBiometrics;
    }

    Future<void> _authenticate() async {
      bool authenticated = false;
      try {
        _isAuthenticating.value = true;
        _authorized.value = 'Authenticating';
        authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          options: const AuthenticationOptions(
            stickyAuth: true,
          ),
        );
        _isAuthenticating.value = false;
      } on PlatformException catch (e) {
        print(e);
        _isAuthenticating.value = false;
        _authorized.value = 'Error - ${e.message}';
        return;
      }
      if (!mounted.value) {
        return;
      }

      _authorized.value = authenticated ? 'Authorized' : 'Not Authorized';
    }

    return BlocProvider(
      create: (BuildContext context) => LoginVerifyCubit(),
      child: Builder(
          builder: (context) => _buildPage(context, password, _isAuthenticating,
              _authorized, _canCheckBiometrics, _supportState)),
    );
  }

  Widget _buildPage(
      BuildContext context,
      ObjectRef<String> password,
      ValueNotifier<bool> _isAuthenticating,
      ValueNotifier<String> _authorized,
      ChangeNotifier _canCheckBiometrics,
      ValueNotifier<_SupportState> _supportState) {
    return BlocListener<LoginVerifyCubit, LoginVerifyState>(
      listener: (context, state) async {
        if (state is LoginVerifyLoading) {
          context.loaderOverlay.show();
        } else if (state is LoginVerifyFailed) {
          context.loaderOverlay.hide();
          await alertHelper(context, 'error', state.message);
        } else if (state is LoginVerifySuccess) {
          context.loaderOverlay.hide();
          // context.go('/user');
        }
      },
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
                      fit: BoxFit.fill),
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
                          child: const Center(
                            child: Text(
                              "Welcome Back \n Qozeem",
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
                                  .maxLength(10)
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
                          onPressed: () {
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
                    if (_supportState.value == _SupportState.supported)
                      FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
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
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              if (context.mounted) {
                                while (context.canPop() == true) {
                                  context.pop();
                                }
                                context.go('/login');
                              }
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
    );
  }
}
