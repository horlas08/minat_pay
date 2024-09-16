import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/login/login_state.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/login/login_bloc.dart';
import '../../../bloc/login/login_event.dart';
import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  bool showPass = false;

  @override
  void dispose() {
    usernameFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc()..add(LoginInitEvent()),
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
          context.read<AppBloc>().add(AddUserEvent(userData: state.userData));
          context
              .read<AppBloc>()
              .add(AddAccountEvent(accounts: state.accounts));
          context.go('/user');
          context.loaderOverlay.hide();
          await alertHelper(context, 'success', "Login Success");
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(showPass
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        showPass = !showPass;
                                      });
                                    },
                                  ),
                                ),
                                onTapOutside: (v) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                obscureText: showPass,
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
        );
      },
    );
  }
}
