abstract class RegisterEvent {}

class InitEvent extends RegisterEvent {}

class RegisterRequestEvent extends RegisterEvent {
  final String firstname;
  final String lastname;
  final String password;
  final String email;
  final String code;
  final String username;
  final String phone;

  RegisterRequestEvent(
      {required this.firstname,
      required this.lastname,
      required this.code,
      required this.password,
      required this.email,
      required this.username,
      required this.phone});
}
