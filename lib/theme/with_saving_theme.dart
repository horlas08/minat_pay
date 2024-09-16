import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:minat_pay/theme/theme_service.dart';

import 'theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = await ThemeService.instance;
  var initTheme = themeService.initial;
  runApp(MyApp(theme: initTheme));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: theme,
      builder: (_, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: ThemeSwitcher(
                    builder: (context) {
                      return IconButton(
                        onPressed: () async {
                          final themeSwitcher = ThemeSwitcher.of(context);
                          final themeName =
                              ThemeModelInheritedNotifier.of(context)
                                          .theme
                                          .brightness ==
                                      Brightness.light
                                  ? 'dark'
                                  : 'dark';
                          final service = await ThemeService.instance
                            ..save(themeName);
                          final theme = service.getByName(themeName);
                          themeSwitcher.changeTheme(theme: theme);
                        },
                        icon: const Icon(Icons.brightness_3, size: 25),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'Flutter Demo Home Page',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: const TextStyle(fontSize: 200),
              ),
              CheckboxListTile(
                title: const Text('Slow Animation'),
                value: timeDilation == 5.0,
                onChanged: (value) {
                  setState(() {
                    timeDilation = value! ? 5.0 : 1.0;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ThemeSwitcher(
                    clipper: const ThemeSwitcherBoxClipper(),
                    builder: (context) {
                      return OutlinedButton(
                        child: const Text('Box Animation'),
                        onPressed: () async {
                          final themeSwitcher = ThemeSwitcher.of(context);

                          final themeName =
                              ThemeModelInheritedNotifier.of(context)
                                          .theme
                                          .brightness ==
                                      Brightness.light
                                  ? 'dark'
                                  : 'light';
                          final service = await ThemeService.instance
                            ..save(themeName);
                          final theme = service.getByName(themeName);
                          themeSwitcher.changeTheme(theme: theme);
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    clipper: const ThemeSwitcherCircleClipper(),
                    builder: (context) {
                      return OutlinedButton(
                        child: const Text('Circle Animation'),
                        onPressed: () async {
                          final themeSwitcher = ThemeSwitcher.of(context);

                          final themeName =
                              ThemeModelInheritedNotifier.of(context)
                                          .theme
                                          .brightness ==
                                      Brightness.light
                                  ? 'dark'
                                  : 'light';
                          final service = await ThemeService.instance
                            ..save(themeName);
                          final theme = service.getByName(themeName);
                          themeSwitcher.changeTheme(theme: theme);
                        },
                      );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeModelInheritedNotifier.of(context).theme ==
                            pinkTheme,
                        onChanged: (needPink) async {
                          final themeSwitcher = ThemeSwitcher.of(context);

                          final service = await ThemeService.instance;
                          ThemeData theme;

                          if (needPink!) {
                            service.save('pink');
                            theme = service.getByName('pink');
                          } else {
                            final previousThemeName = service.previousThemeName;
                            service.save(previousThemeName);
                            theme = service.getByName(previousThemeName);
                          }
                          themeSwitcher.changeTheme(theme: theme);
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeModelInheritedNotifier.of(context).theme ==
                            darkBlueTheme,
                        onChanged: (needDarkBlue) async {
                          final themeSwitcher = ThemeSwitcher.of(context);

                          final service = await ThemeService.instance;
                          ThemeData theme;

                          if (needDarkBlue!) {
                            service.save('darkBlue');
                            theme = service.getByName('darkBlue');
                          } else {
                            var previousThemeName = service.previousThemeName;
                            service.save(previousThemeName);
                            theme = service.getByName(previousThemeName);
                          }

                          themeSwitcher.changeTheme(theme: theme);
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeModelInheritedNotifier.of(context).theme ==
                            halloweenTheme,
                        onChanged: (needHalloween) async {
                          final themeSwitcher = ThemeSwitcher.of(context);
                          final service = await ThemeService.instance;
                          ThemeData theme;

                          if (needHalloween!) {
                            service.save('halloween');
                            theme = service.getByName('halloween');
                          } else {
                            final previousThemeName = service.previousThemeName;
                            service.save(previousThemeName);
                            theme = service.getByName(previousThemeName);
                          }

                          themeSwitcher.changeTheme(theme: theme);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
