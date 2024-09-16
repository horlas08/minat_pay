class DataPlan {
  String? id;
  String? plan;
  String? validity;
  String? amount;

  DataPlan({this.id, this.plan, this.validity, this.amount});

  DataPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plan = json['plan'];
    validity = json['validity'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan'] = this.plan;
    data['validity'] = this.validity;
    data['amount'] = this.amount;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'plan': this.plan,
      'validity': this.validity,
      'amount': this.amount,
    };
  }

  factory DataPlan.fromMap(Map<String, dynamic> map) {
    return DataPlan(
      id: map['id'] as String,
      plan: map['plan'] as String,
      validity: map['validity'] as String,
      amount: map['amount'] as String,
    );
  }
}
