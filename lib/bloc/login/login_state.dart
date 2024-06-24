sealed class LoginState {
  LoginState init() {
    return LoginInit();
  }

  LoginFailed failed(String message) {
    return LoginFailed(message);
  }

  LoginLoadingState loading() {
    return LoginLoadingState();
  }

  LoginSuccess success() {
    return LoginSuccess();
  }
}

class LoginInit extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailed extends LoginState {
  String message;

  LoginFailed(this.message);
}

class LoginLoadingState extends LoginState {}
