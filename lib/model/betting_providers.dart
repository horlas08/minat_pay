import 'package:minat_pay/model/providers.dart';

class BettingProviders extends Providers {
  @override
  String? id;
  @override
  String? name;
  String? serviceId;
  @override
  String? logo;
  String? service;
  String? ncwallet;
  String? easyaccess;
  String? api;
  String? status;

  BettingProviders(
      {this.id = '',
      this.name = '',
      this.logo = '',
      this.serviceId,
      this.service,
      this.ncwallet,
      this.easyaccess,
      this.api,
      this.status})
      : super();

  BettingProviders.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = json['id'];
    name = json['name'];
    serviceId = json['service_id'];
    service = json['service'];
    logo = json['image'];
    ncwallet = json['ncwallet'];
    easyaccess = json['easyaccess'];
    api = json['api'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['service_id'] = serviceId;
    data['service'] = service;
    data['logo'] = logo;
    data['ncwallet'] = ncwallet;
    data['easyaccess'] = easyaccess;
    data['api'] = api;
    data['status'] = status;
    return data;
  }
}
