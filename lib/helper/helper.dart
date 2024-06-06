import 'package:form_validator/form_validator.dart';

extension PasswordValidationBuilder on ValidationBuilder {
  password() => add((value) {
        if (value == 'password') {
          return 'Password should not "password"';
        }
        return null;
      });
  matches(n) => add((value) {
        if (value != n) {
          return 'Password Not Match';
        }
        return null;
      });
}
