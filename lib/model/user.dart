class User {
  final int id;
  final String firstname;
  final String lastname;
  final String password;
  final String email;
  final String username;
  final bool auth_factor;
  final String phone;

//<editor-fold desc="Data Methods">
  const User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.password,
    required this.email,
    required this.username,
    required this.auth_factor,
    required this.phone,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstname == other.firstname &&
          lastname == other.lastname &&
          password == other.password &&
          email == other.email &&
          username == other.username &&
          auth_factor == other.auth_factor &&
          phone == other.phone);

  @override
  int get hashCode =>
      id.hashCode ^
      firstname.hashCode ^
      lastname.hashCode ^
      password.hashCode ^
      email.hashCode ^
      username.hashCode ^
      auth_factor.hashCode ^
      phone.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' id: $id,' +
        ' firstname: $firstname,' +
        ' lastname: $lastname,' +
        ' password: $password,' +
        ' email: $email,' +
        ' username: $username,' +
        ' auth_factor: $auth_factor,' +
        ' phone: $phone,' +
        '}';
  }

  User copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? password,
    String? email,
    String? username,
    bool? auth_factor,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      password: password ?? this.password,
      email: email ?? this.email,
      username: username ?? this.username,
      auth_factor: auth_factor ?? this.auth_factor,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'firstname': this.firstname,
      'lastname': this.lastname,
      'password': this.password,
      'email': this.email,
      'username': this.username,
      'auth_factor': this.auth_factor,
      'phone': this.phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      auth_factor: map['auth_factor'] as bool,
      phone: map['phone'] as String,
    );
  }

//</editor-fold>
}
