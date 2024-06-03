import 'package:bloc/bloc.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<RegisterState> emit) async {
    emit(state.clone());
  }
}
