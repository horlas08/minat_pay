class RegisterState {
  RegisterState init() {
    return RegisterState();
  }

  RegisterSuccess success(String message, String email) {
    return RegisterSuccess(message, email);
  }

  RegisterFailed failed(String message) {
    return RegisterFailed(message);
  }

  RegisterLoading loading() {
    return RegisterLoading();
  }
}

final class RegisterSuccess extends RegisterState {
  String message;
  String email;

  RegisterSuccess(this.message, this.email);
}

final class RegisterLoading extends RegisterState {}

final class RegisterFailed extends RegisterState {
  String message;

  RegisterFailed(this.message);
}
