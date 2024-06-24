class User {
  String? username;
  String? firstName;
  String? lastName;
  String? phonenumber;
  int? id;
  String? email;
  bool? isVerified;
  bool? b2fa;

  User({
    this.username,
    this.firstName,
    this.lastName,
    this.phonenumber,
    this.id,
    this.email,
    this.isVerified,
    this.b2fa,
  });

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phonenumber = json['phonenumber'];
    id = json['id'];
    email = json['email'];
    isVerified = json['is_verified'];
    b2fa = json['2fa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phonenumber'] = this.phonenumber;
    data['id'] = this.id;
    data['email'] = this.email;
    data['is_verified'] = this.isVerified;
    data['2fa'] = this.b2fa;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phonenumber': this.phonenumber,
      'id': this.id,
      'email': this.email,
      'isVerified': this.isVerified,
      'b2fa': this.b2fa,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phonenumber: map['phonenumber'] as String,
      id: map['id'] as int,
      email: map['email'] as String,
      isVerified: map['isVerified'] as bool,
      b2fa: map['b2fa'] as bool,
    );
  }
}
