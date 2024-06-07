import 'package:bloc/bloc.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState().init()) {
    on<InitEvent>(_init);
    on<RegisterEvent>(_onRegisterRequest);
  }

  void _init(InitEvent event, Emitter<RegisterState> emit) async {
    emit(state.init());
  }

  @override
  void onChange(Change<RegisterState> change) {
    super.onChange(change);
    print('$change');
  }

  void _onRegisterRequest(
      RegisterEvent event, Emitter<RegisterState> emit) async {
    emit(state.init());
  }
}
