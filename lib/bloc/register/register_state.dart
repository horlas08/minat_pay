class RegisterState {
  RegisterState init() {
    return RegisterState();
  }

  RegisterSuccess success() {
    return RegisterSuccess();
  }
}

final class RegisterSuccess extends RegisterState {}
