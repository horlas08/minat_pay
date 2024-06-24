import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/register/register_bloc.dart';
import '../../../bloc/register/register_event.dart';
import '../../../bloc/register/register_state.dart';
import '../../../widget/Button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPass = false;
  bool showCPass = false;
  late var phone = '';
  late var password = '';
  final formKey = GlobalKey<FormState>();
  final passwordFieldController = TextEditingController(text: '12345678');
  final firstnameFieldController = TextEditingController(text: 'qwww');
  final lastnameFieldController = TextEditingController(text: 'qwerf');
  final emailFieldController =
      TextEditingController(text: 'qozeemmonsurudeen@gmail.com');
  final usernameFieldController = TextEditingController(text: 'qwerr');
  final phoneFieldController = TextEditingController(text: '090987687544');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) async {
      if (state is RegisterLoading) {
        context.loaderOverlay.show();
      } else if (state is RegisterFailed) {
        context.loaderOverlay.hide();
        await alertHelper(context, 'error', state.message);
      } else if (state is RegisterSuccess) {
        formKey.currentState?.reset();
        context.loaderOverlay.hide();
        await alertHelper(context, 'success', "Registration Successfully");
        context.mounted
            ? context.pushNamed('email_verification',
                pathParameters: {'email': state.email})
            : null;
      } else {
        context.loaderOverlay.hide();
      }
    }, builder: (context, state) {
      return _buildPage(context);
    });
  }

  @override
  void dispose() {
    firstnameFieldController.dispose();
    usernameFieldController.dispose();
    lastnameFieldController.dispose();
    emailFieldController.dispose();
    phoneFieldController.dispose();
    firstnameFieldController.dispose();
    super.dispose();
  }

  Widget _buildPage(BuildContext context) {
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
                                      onTapOutside: (v) => FocusManager
                                          .instance.primaryFocus
                                          ?.unfocus(),
                                      controller: firstnameFieldController,
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
                                      controller: lastnameFieldController,
                                      decoration: const InputDecoration(
                                        hintText: "Lastname",
                                        helperText: '',
                                      ),
                                      onTapOutside: (v) => FocusManager
                                          .instance.primaryFocus
                                          ?.unfocus(),
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
                                controller: emailFieldController,
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  helperText: '',
                                ),
                                onTapOutside: (v) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                keyboardType: TextInputType.emailAddress,
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
                              PhoneFormField(
                                decoration: const InputDecoration(
                                  hintText: "Phone",
                                  helperText: '',
                                ),
                                onTapOutside: (v) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                initialValue:
                                    PhoneNumber.parse('+234'), // or use the
                                // controller
                                validator: PhoneValidator.compose([
                                  PhoneValidator.required(context),
                                  PhoneValidator.validMobile(context)
                                ]),
                                onChanged: (phoneNumber) =>
                                    phone = '0${phoneNumber.nsn}',
                                // print('changed into $phoneNumber'),
                                enabled: true,
                                isCountrySelectionEnabled: false,
                                // isCountryButtonPersistent: false,

                                countryButtonStyle: const CountryButtonStyle(
                                  showDialCode: true,
                                  showIsoCode: false,
                                  showFlag: true,
                                  showDropdownIcon: false,
                                  flagSize: 20,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFont.aeonik,
                                    fontSize: 23,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: usernameFieldController,
                                decoration: const InputDecoration(
                                  hintText: "Username",
                                  helperText: '',
                                ),
                                onTapOutside: (v) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                validator:
                                    ValidationBuilder().required().build(),
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
                                      onTapOutside: (v) => FocusManager
                                          .instance.primaryFocus
                                          ?.unfocus(),
                                      onChanged: (v) {
                                        password = v;
                                      },
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
                                      onChanged: (v) {
                                        setState(() {});
                                      },
                                      onTapOutside: (v) => FocusManager
                                          .instance.primaryFocus
                                          ?.unfocus(),
                                      obscureText: showCPass,
                                      validator: ValidationBuilder()
                                          .matches(
                                            password,
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          context.read<RegisterBloc>().add(
                                RegisterRequestEvent(
                                  firstname: firstnameFieldController.text,
                                  lastname: lastnameFieldController.text,
                                  password: passwordFieldController.text,
                                  email: emailFieldController.text,
                                  username: usernameFieldController.text,
                                  phone: phone,
                                ),
                              );
                        }
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
