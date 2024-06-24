import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/login/login_state.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/login/login_bloc.dart';
import '../../../bloc/login/login_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  @override
  void dispose() {
    usernameFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is LoginLoadingState) {
          context.loaderOverlay.show();
        } else if (state is LoginFailed) {
          context.loaderOverlay.hide();
          await alertHelper(context, 'error', state.message);
        } else if (state is LoginSuccess) {
          context.loaderOverlay.hide();
          await alertHelper(context, 'success', "Login Success");
        }
      },
      builder: (context, state) {
        return LoaderOverlay(
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
          child: Scaffold(
            // backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/login/background.png'),
                          fit: BoxFit.fill),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeInUp(
                              duration: const Duration(seconds: 1),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/login/light-1.png'))),
                              )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 1200),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/login/light-2.png'))),
                              )),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 1300),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/login/clock.png'))),
                              )),
                        ),
                        Positioned(
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
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
                                  controller: usernameFieldController,
                                  decoration: const InputDecoration(
                                    hintText: "Email or Username",
                                  ),
                                  onTapOutside: (v) => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
                                  validator: ValidationBuilder()
                                      // .required()
                                      // .email()
                                      .maxLength(50)
                                      .build(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: passwordFieldController,
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                  ),
                                  onTapOutside: (v) => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
                                  obscureText: true,
                                  validator: ValidationBuilder()
                                      // .required()
                                      // .maxLength(50)
                                      // .minLength(5)
                                      .build(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                                  context.read<LoginBloc>().add(
                                        LoginRequestEvent(
                                            username:
                                                usernameFieldController.text,
                                            password:
                                                passwordFieldController.text),
                                      );
                                }
                              },
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(
                                  const Size.fromHeight(65),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("New Member?"),
                              const SizedBox(
                                width: 5,
                              ),
                              TouchableOpacity(
                                onTap: () => context.go('/register'),
                                child: Text(
                                  "Register",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 2000),
                          child: TouchableOpacity(
                              onTap: () => context.goNamed("reset_password"),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
