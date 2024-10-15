import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:minat_pay/model/app.dart';

class AppConfigCubit extends HydratedCubit<App> {
  AppConfigCubit()
      : super(App(
          authState: false,
          pinState: false,
          themeMode: 'light',
          enableFingerPrint: true,
          enableNotification: true,
          enableShakeToHideBalance: true,
          autoTheme: false,
        ));

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

  changeAutoThemeMode(bool mode) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('theme', mode);
    emit(state.copyWith(autoTheme: mode));
  }

  toggleThemeMode() {
    emit(state.copyWith(
        themeMode: state.themeMode == 'light' ? 'dark' : 'light'));
    print(state.themeMode);
  }

  comfirmPinState(bool status) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('theme', mode);
    emit(state.copyWith(pinState: status));
  }

  enableFingerPrint(bool mode) async {
    emit(state.copyWith(enableFingerPrint: mode));
  }

  enableNotification(bool mode) async {
    emit(state.copyWith(enableNotification: mode));
  }

  enableShakeToHideBalance(bool mode) async {
    emit(state.copyWith(enableShakeToHideBalance: mode));
  }

  @override
  App? fromJson(Map<String, dynamic> json) => App.fromJson(json);

  @override
  Map<String, dynamic>? toJson(App state) {
    return state.toJson();
  }
}
