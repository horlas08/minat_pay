import 'package:minat_pay/model/providers.dart';

class AirtimePinPlan extends Providers {
  @override
  String? id;
  @override
  String? name;
  String? amount;
  String? network;
  String? type;
  String? val_id;
  String? amount_agent;
  @override
  String? image;
  String? status;

  AirtimePinPlan({
    this.id,
    this.name,
    this.amount,
    this.amount_agent,
    this.type,
    this.network,
    this.image,
    this.val_id,
    this.status,
  });

  AirtimePinPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] + ' - N' + json['type'];
    amount = json['amount'];
    amount_agent = json['amount_agent'];
    network = json['network'];
    val_id = json['val_id'];
    type = json['type'];
    image = json['image'];
    status = json['status'];
  }
  // static List<Country> fromJsonList(List list) {
  //   return list.map((item) => Country.fromJson(item)).toList();
  // }

  static List<AirtimePinPlan> fromJsonList(List json) => json
      .map(
        (e) => AirtimePinPlan.fromJson(e),
      )
      .toList();
}
