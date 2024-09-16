import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? apiKey;
  final String? balance;
  final String? phoneNumber;
  final String? photo;
  final bool? b2fa;
  final bool? hasPin;
  final bool? isVerified;
  final bool? hasMonnify;
  final bool? hasPsb;
  final bool? userType;
  final num? refBal;
  final num? referrals;

  const User(
      {this.id,
      this.phoneNumber,
      this.photo,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.apiKey,
      this.balance,
      this.b2fa,
      this.hasPin,
      this.isVerified,
      this.hasMonnify,
      this.hasPsb,
      this.refBal,
      this.referrals,
      this.userType});

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, username: $username, email: $email, balance: $balance, b2fa: $b2fa, has_pin: $hasPin, is_verified: $isVerified, phone: $phoneNumber, photo: $photo}';
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? apiKey,
    String? phoneNumber,
    String? photo,
    String? balance,
    bool? b2fa,
    bool? hasPin,
    bool? isVerified,
    bool? hasPsb,
    bool? hasMonnify,
    bool? userType,
    num? refBal,
    num? referrals,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      apiKey: apiKey ?? this.apiKey,
      balance: balance ?? this.balance,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      b2fa: b2fa ?? this.b2fa,
      hasPin: hasPin ?? this.hasPin,
      isVerified: isVerified ?? this.isVerified,
      hasPsb: hasPsb ?? this.hasPsb,
      hasMonnify: hasMonnify ?? this.hasMonnify,
      userType: userType ?? this.userType,
      refBal: refBal ?? this.refBal,
      referrals: referrals ?? this.referrals,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'apiKey': apiKey,
      'balance': balance,
      'photo': photo,
      'phoneNumber': phoneNumber,
      'b2fa': b2fa,
      'hasPin': hasPin,
      'isVerified': isVerified,
      'hasMonnify': hasMonnify,
      'hasPsb': hasPsb,
      'userType': userType,
      'refBal': refBal,
      'referrals': referrals,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      apiKey: map['api_key'] as String,
      balance: map['balance'] as String,
      phoneNumber: map['phone_number'],
      photo: map['photo'],
      b2fa: map['2fa'] as bool,
      hasPin: map['has_pin'] as bool,
      isVerified: map['isVerified'] as bool,
      hasPsb: map['has_psb'] as bool,
      hasMonnify: map['has_monnify'] as bool,
      userType: map['user_type'] as bool,
      refBal: map['ref_bal'] as num,
      referrals: map['referrals'] as num,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        username,
        email,
        apiKey,
        balance,
        phoneNumber,
        photo,
        b2fa,
        hasPin,
        isVerified,
        hasPsb,
        hasMonnify,
        userType,
        refBal,
        referrals
      ];
}
