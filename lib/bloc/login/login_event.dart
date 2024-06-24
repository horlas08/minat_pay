sealed class LoginEvent {}

class InitEvent extends LoginEvent {}

class LoginRequestEvent extends LoginEvent {
  String username;

  String password;

  LoginRequestEvent({required this.username, required this.password});
}
