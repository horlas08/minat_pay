import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/forgot_password/forgot_password_cubit.dart';
import '../../../widget/Button.dart';

class ForgotPasswordPage extends HookWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _otpController = useTextEditingController(text: "");
    final _emailController = useTextEditingController(text: "");
    final _passwordController = useTextEditingController();

    useEffect(() {
      _otpController.text = '';
      _emailController.text = '';
      _passwordController.text = '';
      return null;
    }, []);
    return BlocProvider(
      create: (BuildContext context) => ForgotPasswordCubit(),
      child: Builder(
          builder: (context) => _buildPage(
              context, _otpController, _emailController, _passwordController)),
    );
  }

  Widget _buildPage(
    BuildContext context,
    TextEditingController _otpController,
    TextEditingController _emailController,
    TextEditingController _passwordController,
  ) {
    final cubit = BlocProvider.of<ForgotPasswordCubit>(context);
    final _form = GlobalKey<FormState>();
    Future<void> handleRequestOtp() async {
      context.loaderOverlay.show();
      final response = await curlPostRequest(path: '/sendotp', data: {
        'emailOrUsername': _emailController.text,
      });
      print(response);
      if (response?.statusCode == HttpStatus.ok) {
        if (context.mounted) {
          context.loaderOverlay.hide();
          await alertHelper(context, 'success', response?.data['message']);
        }
      } else {
        if (context.mounted) {
          context.loaderOverlay.hide();
          await alertHelper(context, 'error', response?.data['message']);
        }
      }
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    }

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
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text(
                              "Forgot Password",
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
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Email",
                              suffixIcon: TextButton(
                                onPressed: () async {
                                  if (_emailController.text == '') {
                                    return await alertHelper(context, 'error',
                                        "Please Enter Your Email");
                                  }
                                  await handleRequestOtp();
                                },
                                child: const Text("Request Otp"),
                              ),
                            ),
                            validator:
                                ValidationBuilder().required().email().build(),
                            controller: _emailController,
                            onTapOutside: (v) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "OTP",
                            ),
                            controller: _otpController,
                            validator: ValidationBuilder().required().build(),
                            onTapOutside: (v) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "New Password",
                            ),
                            controller: _passwordController,
                            validator: ValidationBuilder().required().build(),
                            onTapOutside: (v) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: Button(
                        onpressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_form.currentState!.validate()) {
                            context.loaderOverlay.show();
                            final response = await curlPostRequest(
                              path: '/resetpassword',
                              data: {
                                'otp': _otpController.text,
                                'new_password': _passwordController.text,
                                'emailOrUsername': _emailController.text,
                              },
                            );
                            if (response == null && context.mounted) {
                              context.loaderOverlay.hide();
                              _otpController.text = '';
                              _emailController.text = '';
                              _passwordController.text = '';
                              return await alertHelper(
                                  context, "success", 'Error Try Again Later');
                            }
                            if (response?.statusCode == HttpStatus.ok) {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                _otpController.text = '';
                                _emailController.text = '';
                                _passwordController.text = '';
                                await alertHelper(context, "success",
                                    response?.data['message']);
                              }
                            } else {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                                await alertHelper(context, "error",
                                    response?.data['message']);
                              }
                            }
                            if (context.mounted &&
                                context.loaderOverlay.visible) {
                              context.loaderOverlay.hide();
                            }
                          }
                        },
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Ohh I Remember"),
                          const SizedBox(
                            width: 5,
                          ),
                          TouchableOpacity(
                            onTap: () => context.go('/login'),
                            child: Text(
                              "Login",
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
