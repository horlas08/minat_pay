import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/email_verify/email_verify_bloc.dart';

class EmailVerifyPage extends HookWidget {
  final String email;
  const EmailVerifyPage({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    final otp = useRef('');
    return BlocProvider(
      create: (context) => EmailVerifyBloc(),
      child: BlocConsumer<EmailVerifyBloc, EmailVerifyState>(
        listener: (BuildContext context, state) async {
          if (state is EmailVerifyLoading) {
            context.loaderOverlay.show();
          } else if (state is EmailVerifyFailed) {
            context.loaderOverlay.hide();
            await alertHelper(context, 'error', "Otp Verified Successfully");
          } else if (state is EmailVerifySuccess) {
            context.loaderOverlay.hide();
            await alertHelper(context, 'success', state.message);
            if (context.mounted) {
              context.pushReplacementNamed("dashboard");
            }
          } else if (state is EmailVerifyResendFailed) {
            context.loaderOverlay.hide();
            await alertHelper(context, 'error', state.message);
          } else {
            context.loaderOverlay.hide();
          }
        },
        builder: (BuildContext context, state) {
          return _buildPage(context, otp);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, otp) {
    final _formKey = GlobalKey<FormState>();

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
                        duration: const Duration(milliseconds: 1600),
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text(
                              "Email Verification",
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
                            decoration: const InputDecoration(
                              hintText: "Email Verification Code",
                            ),
                            onChanged: (v) => {otp.value = v},
                            initialValue: otp.value,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Enter Email Verification Sent To $email",
                              overflow: TextOverflow.ellipsis,
                            ),
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
                            context.read<EmailVerifyBloc>().add(
                                  EmailVerifySent(otp: otp.value),
                                );
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Didn't Receive Code?"),
                        const SizedBox(
                          width: 5,
                        ),
                        TouchableOpacity(
                          onTap: () => context
                              .read<EmailVerifyBloc>()
                              .add(EmailVerifyResend(otp: otp)),
                          child: Text(
                            "Resend",
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
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: TouchableOpacity(
                      onTap: () => context.goNamed("reset_password"),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Wrong Email?"),
                          const SizedBox(
                            width: 5,
                          ),
                          TouchableOpacity(
                            onTap: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (await prefs.clear() && context.mounted) {
                                context.pushReplacementNamed("register");
                              }
                            },
                            child: Text(
                              "Click Here",
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
