class OrderRTS {
  String? deliveryType;
  String? orderItemIds;
  String? shipmentProvider;
  String? trackingNumber;

  OrderRTS({
    this.deliveryType,
    this.orderItemIds,
    this.shipmentProvider,
    this.trackingNumber,
  });

  OrderRTS.fromJson(Map<String, dynamic> json) {
    deliveryType = json['delivery_type'];
    orderItemIds = json['order_item_ids'];
    shipmentProvider = json['shipment_provider'];
    trackingNumber = json['tracking_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delivery_type'] = deliveryType;
    data['order_item_ids'] = orderItemIds;
    data['shipment_provider'] = shipmentProvider;
    data['tracking_number'] = trackingNumber;
    return data;
  }
}
