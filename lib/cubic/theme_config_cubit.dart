import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeConfigCubit extends Cubit<String> {
  ThemeConfigCubit() : super('');

  @override
  void onChange(Change<String> change) {
    // TODO: implement onChange
    print('change---> ${change}');
    super.onChange(change);
  }

  changeThemeMode(String mode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('theme', mode);

    emit(mode);
  }

  getThemeMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final mode = preferences.getString('theme');
    emit(mode ?? 'light');
  }
}
