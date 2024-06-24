import 'package:minat_pay/model/user.dart';

class AppRepo {
  Data? data;

  AppRepo({this.data});

  AppRepo.fromJson(Map<String, dynamic> json) {
    // status = json['status'];
    // code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['status'] = this.status;
    // data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? userData;

  Data({this.userData});

  Data.fromJson(Map<String, dynamic> json) {
    userData =
        json['user_data'] != null ? User.fromJson(json['user_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'userData': this.userData,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      userData: map['userData'] as User,
    );
  }
}
