import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/app.config.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/register/register_bloc.dart';
import '../../../bloc/register/register_event.dart';
import '../../../bloc/register/register_state.dart';
import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_event.dart';
import '../../../cubic/app_config_cubit.dart';
import '../../../widget/Button.dart';

final formKey = GlobalKey<FormState>();

final timeController = CountdownController();
final phoneFieldController = PhoneController(
  initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ""),
);

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firstnameFieldController = useTextEditingController(text: '');
    final lastnameFieldController = useTextEditingController(text: '');
    final emailFieldController = useTextEditingController(text: '');
    final usernameFieldController = useTextEditingController(text: '');
    final inviteFieldController = useTextEditingController(text: '');
    final verificationFieldController = useTextEditingController();
    final passwordFieldController = useTextEditingController(text: '');
    final ValueNotifier<bool> showPass = useState(false);
    final ValueNotifier<bool> showCPass = useState(false);
    final ValueNotifier<bool> phoneValid = useState(false);
    final ValueNotifier<String> password = useState('');
    final ValueNotifier<bool> timeCount = useState(false);
    final ValueNotifier<bool> smsRequestPending = useState(false);
    Future<void> sendOtpToPhone(BuildContext context) async {
      smsRequestPending.value = true;
      final res = await curlPostRequest(
          path: sendSms,
          data: {'phonenumber': "0${phoneFieldController.value.nsn}"});
      print(res);
      smsRequestPending.value = false;
      if (res == null) {
        if (!context.mounted) return;
        return await alertHelper(context, 'success', "Something Went Wrong");
      }
      if (res.statusCode == HttpStatus.ok) {
        timeCount.value = true;
        timeController.restart();
        if (context.mounted) {
          await alertHelper(context, 'success', res.data['message']);
        }
      } else {
        timeCount.value = false;
        if (context.mounted) {
          await alertHelper(context, 'error', res.data['message']);
        }
      }
    }

    return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) async {
      if (state is RegisterLoading) {
        context.loaderOverlay.show();
      } else if (state is RegisterFailed) {
        context.loaderOverlay.hide();
        await alertHelper(context, 'error', state.message);
      } else if (state is RegisterSuccess) {
        print("register suucessfully");
        formKey.currentState?.reset();
        context.loaderOverlay.hide();
        // await alertHelper(context, 'success', "Registration Successfully");
        if (context.mounted) {
          context.read<AppConfigCubit>().changeOnboardStatus(true);
          print(state.userData);
          context.read<AppBloc>().add(AddUserEvent(userData: state.userData));
          context
              .read<AppBloc>()
              .add(AddAccountEvent(accounts: state.accounts));
          context.pushNamed('regSuccessful');
          // context.pushNamed('email_verification',
          //     pathParameters: {'email': state.email});
        }
      } else {
        // context.loaderOverlay.hide();
      }
    }, builder: (context, state) {
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
                                  decoration: InputDecoration(
                                    hintText: "Phone",
                                    helperText: '',
                                    suffixIcon: phoneValid.value
                                        ? SizedBox(
                                            height: 20,
                                            width: 70,
                                            child: Button(
                                              isDisabe: timeCount.value,
                                              onpressed: () {
                                                if (!timeCount.value)
                                                  sendOtpToPhone(context);
                                              },
                                              child: timeCount.value
                                                  ? Countdown(
                                                      seconds: 60,
                                                      build: (BuildContext
                                                                  context,
                                                              double time) =>
                                                          Text(time.toString()),
                                                      interval: const Duration(
                                                          seconds: 1),
                                                      // controller:
                                                      //     timeController,
                                                      onFinished: () {
                                                        timeCount.value = false;

                                                        print('Timer is done!');
                                                      },
                                                    )
                                                  : smsRequestPending.value
                                                      ? const Center(
                                                          child: SizedBox(
                                                            height: 10,
                                                            width: 10,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      : const Text(
                                                          "Get Codes",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  onTapOutside: (v) => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
                                  validator: PhoneValidator.compose([
                                    PhoneValidator.required(context),
                                    PhoneValidator.validMobile(context)
                                  ]),
                                  onChanged: (phone) {
                                    if (phone.isValid() &&
                                        phone.isValidLength()) {
                                      phoneValid.value = true;
                                    } else {
                                      phoneValid.value = false;
                                    }
                                  },
                                  controller: phoneFieldController,

                                  // print('changed into $phoneNumber'),
                                  enabled: true,
                                  isCountrySelectionEnabled: false,

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
                                  controller: verificationFieldController,
                                  decoration: const InputDecoration(
                                    hintText: "Verification Code",
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
                                            icon: Icon(showPass.value
                                                ? Icons.remove_red_eye
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              showPass.value = !showPass.value;
                                            },
                                          ),
                                        ),
                                        onTapOutside: (v) => FocusManager
                                            .instance.primaryFocus
                                            ?.unfocus(),
                                        onChanged: (v) {
                                          password.value = v;
                                        },
                                        obscureText: showPass.value,
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
                                            icon: Icon(showCPass.value
                                                ? Icons.remove_red_eye
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              showCPass.value =
                                                  !showCPass.value;
                                            },
                                          ),
                                        ),
                                        onChanged: (v) {},
                                        onTapOutside: (v) => FocusManager
                                            .instance.primaryFocus
                                            ?.unfocus(),
                                        obscureText: showCPass.value,
                                        validator: ValidationBuilder()
                                            .matches(password.value)
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
                                  controller: inviteFieldController,
                                  decoration: const InputDecoration(
                                    hintText: "Invite code",
                                    helperText: '',
                                  ),
                                  onTapOutside: (v) => FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                                    code: verificationFieldController.text,
                                    phone: "0${phoneFieldController.value.nsn}",
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
    });
  }
}
