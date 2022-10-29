import 'package:receipt_online_shop/model/shopee/item_shopee.dart';

class ShopeeOrder {
  bool? cod;
  int? createTime;
  String? currency;
  int? daysToShip;
  List<ItemShopee>? itemList;
  String? messageToSeller;
  String? orderSn;
  String? orderStatus;
  String? prescriptionCheckStatus;
  String? prescriptionImages;
  String? region;
  int? reverseShippingFee;
  int? shipByDate;
  String? shippingCarrier;
  int? totalAmount;
  int? updateTime;
  String? trackingNumber;

  ShopeeOrder(
      {this.cod,
      this.createTime,
      this.currency,
      this.daysToShip,
      this.itemList,
      this.messageToSeller,
      this.orderSn,
      this.orderStatus,
      this.prescriptionCheckStatus,
      this.prescriptionImages,
      this.region,
      this.reverseShippingFee,
      this.shipByDate,
      this.shippingCarrier,
      this.totalAmount,
      this.updateTime,
      this.trackingNumber});

  ShopeeOrder.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    createTime = json['create_time'];
    currency = json['currency'];
    daysToShip = json['days_to_ship'];
    if (json['item_list'] != null) {
      itemList = <ItemShopee>[];
      json['item_list'].forEach((v) {
        itemList!.add(ItemShopee.fromJson(v));
      });
    }
    messageToSeller = json['message_to_seller'];
    orderSn = json['order_sn'];
    orderStatus = json['order_status'];
    prescriptionCheckStatus = json['prescription_check_status'];
    prescriptionImages = json['prescription_images'];
    region = json['region'];
    reverseShippingFee = json['reverse_shipping_fee'];
    shipByDate = json['ship_by_date'];
    shippingCarrier = json['shipping_carrier'];
    totalAmount = json['total_amount'];
    updateTime = json['update_time'];
    trackingNumber = json['trackingNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cod'] = cod;
    data['create_time'] = createTime;
    data['currency'] = currency;
    data['days_to_ship'] = daysToShip;
    if (itemList != null) {
      data['item_list'] = itemList!.map((v) => v.toJson()).toList();
    }
    data['message_to_seller'] = messageToSeller;
    data['order_sn'] = orderSn;
    data['order_status'] = orderStatus;
    data['prescription_check_status'] = prescriptionCheckStatus;
    data['prescription_images'] = prescriptionImages;
    data['region'] = region;
    data['reverse_shipping_fee'] = reverseShippingFee;
    data['ship_by_date'] = shipByDate;
    data['shipping_carrier'] = shippingCarrier;
    data['total_amount'] = totalAmount;
    data['update_time'] = updateTime;
    data['trackingNumber'] = trackingNumber;
    return data;
  }
}
