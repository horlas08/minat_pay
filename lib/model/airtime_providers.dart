import 'package:minat_pay/model/providers.dart';

class AirtimeProviders extends Providers {
  @override
  String? id;
  @override
  String? name;
  String? valId;
  String? api;
  String? ncwallet;
  String? easyacess;
  @override
  String? image;
  String? status;

  AirtimeProviders(
      {this.id,
      this.name,
      this.valId,
      this.api,
      this.ncwallet,
      this.easyacess,
      this.image,
      this.status});

  AirtimeProviders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    valId = json['val_id'];
    api = json['api'];
    ncwallet = json['ncwallet'];
    easyacess = json['easyacess'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['val_id'] = this.valId;
    data['api'] = this.api;
    data['ncwallet'] = this.ncwallet;
    data['easyacess'] = this.easyacess;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
