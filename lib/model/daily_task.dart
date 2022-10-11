import 'package:receipt_online_shop/model/receipt.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';

class DailyTask {
  String? createdAt;
  String? date;
  Expedition? expedition;
  int? id;
  int? left;
  int? picked;
  bool? status;
  int? totalPackage;
  String? updatedAt;
  List<Receipt>? receipts;

  DailyTask(
      {this.createdAt,
      this.date,
      this.expedition,
      this.id,
      this.left = 0,
      this.picked = 0,
      this.status = false,
      this.totalPackage = 0,
      this.updatedAt,
      this.receipts});

  DailyTask.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    date = json['date'];
    expedition = json['expedition'] != null
        ? Expedition.fromJson(json['expedition'])
        : null;
    id = json['id'];
    left = json['left'];
    picked = json['picked'];
    status = json['status'];
    totalPackage = json['total_package'];
    updatedAt = json['updated_at'];
    if (json['receipts'] != null) {
      receipts = <Receipt>[];
      json['receipts'].forEach((v) {
        receipts!.add(Receipt.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['date'] = date;
    if (expedition != null) {
      data['expedition'] = expedition!.toJson();
    }
    data['id'] = id;
    data['left'] = left;
    data['picked'] = picked;
    data['status'] = status;
    data['total_package'] = totalPackage;
    data['updated_at'] = updatedAt;
    if (receipts != null) {
      data['receipts'] = receipts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
