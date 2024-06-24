import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:minat_pay/model/app.dart';

class AppConfigCubit extends HydratedCubit<App> {
  AppConfigCubit() : super(App(authState: false, themeMode: 'light'));

  @override
  void onChange(Change<App> change) {
    // TODO: implement onChange
    print('change---> ${change.toString()}');
    super.onChange(change);
  }

  changeThemeMode(String mode) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('theme', mode);
    emit(state.copyWith(themeMode: mode));
  }

  // getThemeMode() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final mode = preferences.getString('theme');
  //   if (mode != null) {
  //     emit(state.copyWith(themeMode: mode));
  //   }
  //
  //   return mode ?? state.themeMode;
  // }

  @override
  App? fromJson(Map<String, dynamic> json) => App.fromJson(json);

  @override
  Map<String, dynamic>? toJson(App state) {
    return state.toJson();
  }
}
