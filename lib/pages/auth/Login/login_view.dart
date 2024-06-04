import 'package:animate_do/animate_do.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/Button.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/login/login_bloc.dart';
import '../../../bloc/login/login_event.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);

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
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                FadeInUp(
                    duration: Duration(milliseconds: 1800),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Emails or Username",
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 1900),
                  child: Button(
                    onpressed: () async {
                      await Flushbar(
                        title: "Hello flush test",
                        message:
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                        duration: const Duration(seconds: 3),
                        flushbarPosition: FlushbarPosition.TOP,
                        backgroundColor: Colors.red,
                      ).show(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Positioned(
                  child: FadeInUp(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                  child: TouchableOpacity(
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
    ));
  }
}
