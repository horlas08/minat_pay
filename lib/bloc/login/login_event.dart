sealed class LoginEvent {}

class InitEvent extends LoginEvent {}

class LoginRequestEvent extends LoginEvent {
  String firstname;
  String lastname;
  String email;
  String username;
  String phone;
  String password;

  LoginRequestEvent(
      {required this.firstname,
      required this.lastname,
      required this.email,
      required this.username,
      required this.phone,
      required this.password});
}
