import 'package:bloc/bloc.dart';
import 'package:minat_pay/model/account.dart';

import '../../../model/user.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState().init()) {
    // on<InitEvent>(_init);
    on<AddUserEvent>(_addUser);
    on<UpdateUserEvent>(_updateUser);
    on<AddAccountEvent>(_addAccount);
  }
  @override
  void onChange(Change<AppState> change) {
    print(change.currentState.toString());
    print(change.nextState.toString());
    print(change.toString());
    super.onChange(change);
  }

  void _addUser(AddUserEvent event, Emitter<AppState> emit) async {
    final user = User.fromMap(event.userData);
    emit(state.copyWith(user: user));

    print(state.user);
  }

  void _addAccount(AddAccountEvent event, Emitter<AppState> emit) async {
    final List<Account> allAccount = [];
    for (var account in event.accounts) {
      allAccount.add(Account.fromJson(account));
    }
    state.accounts = allAccount;
    emit(state);
  }

  void _updateUser(UpdateUserEvent event, Emitter<AppState> emit) async {
    final user = User.fromMap(event.userData);
    emit(state.copyWith(user: user));

    print(state.user);

    // emit(state.update(user: user, account: state.accounts));
    print(state.user.toString());
  }
}
