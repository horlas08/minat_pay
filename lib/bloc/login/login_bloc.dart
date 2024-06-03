import 'package:bloc/bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<LoginState> emit) async {
    emit(state.clone());
  }
}
