import 'package:minat_pay/model/providers.dart';

class NinProvider extends Providers {
  @override
  String? id;
  @override
  String? name;
  String? slug;
  @override
  String? image;
  @override
  String? logo;
  String? amount;
  String? status;

  NinProvider(
      {this.id,
      this.name = '',
      this.logo = '',
      this.image = '',
      this.slug,
      this.amount,
      this.status})
      : super();

  NinProvider.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = json['id'];
    name = json['name'];
    image = json['image'];
    logo = json['logo'];
    amount = json['amount'];
    slug = json['slug'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['image'] = image;
    data['slug'] = slug;
    data['status'] = status;
    return data;
  }
}
