class User {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  int? balance;
  bool? is_verified;
  // bool? b2fa;
  // String? phonenumber;
  int? id;

  User({
    this.username,
    this.firstName,
    this.lastName,
    // this.phonenumber,
    this.id,
    this.email,
    this.is_verified,
    // this.b2fa,
  });

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    // phonenumber = json['phonenumber'];
    id = json['id'];
    email = json['email'];
    is_verified = json['is_verified'];
    // b2fa = json['2fa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    // data['phonenumber'] = phonenumber;
    data['id'] = id;
    data['email'] = email;
    data['is_verified'] = is_verified;
    // data['2fa'] = b2fa;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      // 'phonenumber': phonenumber,
      'id': id,
      'email': email,
      'is_verified': is_verified,
      // 'b2fa': b2fa,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      // username: map['username'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      // phonenumber: map['phonenumber'] as String,
      id: map['id'] as int,
      email: map['email'] as String,
      is_verified: map['is_verified'] as bool,
      // b2fa: map['b2fa'] as bool,
    );
  }
}
