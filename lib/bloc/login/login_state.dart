class LoginState {
  LoginState init() {
    return LoginState();
  }

  LoginFailed failed() {
    return LoginFailed();
  }

  LoginLoadingState loading() {
    return LoginLoadingState();
  }
}

class LoginFailed extends LoginState {}

class LoginLoadingState extends LoginState {}
