import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/register/register_bloc.dart';
import '../../../bloc/register/register_event.dart';
import '../../../repo/register_repo.dart';
import '../../../widget/Button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPass = false;
  bool showCPass = false;
  final formKey = GlobalKey<FormState>();
  final passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<RegisterBloc>(context);

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
                              "Register",
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Form(
                          key: formKey,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Firstname",
                                        // isCollapsed: true,
                                        helperText: '',
                                      ),
                                      validator: ValidationBuilder()
                                          .required()
                                          .build(),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Lastname",
                                        helperText: '',
                                      ),
                                      validator: ValidationBuilder()
                                          .required()
                                          .build(),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  helperText: '',
                                ),
                                validator: ValidationBuilder()
                                    .required()
                                    .email()
                                    .build(),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              IntlPhoneField(
                                decoration: const InputDecoration(
                                  hintText: 'Phone Number',
                                ),
                                initialCountryCode: 'NG',
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Username",
                                  helperText: '',
                                ),
                                obscureText: showCPass,
                                validator: ValidationBuilder()
                                    .matches(
                                      passwordFieldController.value.text,
                                    )
                                    .required()
                                    .build(),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: passwordFieldController,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        helperText: '',
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
                                      obscureText: showPass,
                                      validator: ValidationBuilder()
                                          .required()
                                          .build(),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        helperText: '',
                                        suffixIcon: IconButton(
                                          icon: Icon(showCPass
                                              ? Icons.remove_red_eye
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              showCPass = !showCPass;
                                            });
                                          },
                                        ),
                                      ),
                                      obscureText: showCPass,
                                      validator: ValidationBuilder()
                                          .matches(
                                            passwordFieldController.value.text,
                                          )
                                          .required()
                                          .build(),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: Button(
                      onpressed: () async {
                        if (formKey.currentState!.validate()) {
                          final res = await RegisterRepo(
                                  firstname: 'test',
                                  phone: '993993',
                                  email: 'test',
                                  username: 'test',
                                  lastname: 'qozeem',
                                  password: '1234')
                              .registerResponse();
                          print('res');
                        }
                      },
                      child: const Text(
                        "Register",
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
                        const Text("Already Have Account?"),
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
                  const SizedBox(
                    height: 20,
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
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
