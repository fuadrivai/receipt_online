class Receipt {
  String? number;
  int? id;
  String? createdAt;
  String? updatedAt;

  Receipt({this.number, this.id, this.createdAt, this.updatedAt});

  Receipt.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  factory Receipt.clone(Receipt receipt) {
    return Receipt(
      number: receipt.number,
      id: receipt.id,
      createdAt: receipt.createdAt,
      updatedAt: receipt.updatedAt,
    );
  }
}
