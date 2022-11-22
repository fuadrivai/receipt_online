class TransactionOnline {
  String? createTimeOnline;
  String? updateTimeOnline;
  String? messageToSeller;
  String? orderNo;
  String? orderStatus;
  String? trackingNumber;
  String? deliveryBy;
  String? shippingProviderType;
  String? pickupBy;
  double? totalAmount;
  int? totalQty;
  int? status;
  int? onlineShopId;
  String? orderId;
  String? productPicture;
  String? packagePicture;
  List<Items>? items;

  TransactionOnline({
    this.createTimeOnline,
    this.updateTimeOnline,
    this.messageToSeller,
    this.orderNo,
    this.orderStatus,
    this.trackingNumber,
    this.deliveryBy,
    this.pickupBy,
    this.totalAmount,
    this.totalQty,
    this.status,
    this.onlineShopId,
    this.orderId,
    this.productPicture,
    this.packagePicture,
    this.items,
    this.shippingProviderType,
  });

  TransactionOnline.fromJson(Map<String, dynamic> json) {
    createTimeOnline = json['create_time_online'];
    updateTimeOnline = json['update_time_online'];
    messageToSeller = json['message_to_seller'];
    orderNo = json['order_no'];
    orderStatus = json['order_status'];
    trackingNumber = json['tracking_number'];
    deliveryBy = json['delivery_by'];
    pickupBy = json['pickup_by'];
    totalAmount = json['total_amount'].toDouble();
    totalQty = json['total_qty'];
    status = json['status'];
    onlineShopId = json['online_shop_id'];
    orderId = json['order_id'];
    productPicture = json['product_picture'];
    packagePicture = json['package_picture'];
    shippingProviderType = json['shipping_provider_type'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['create_time_online'] = createTimeOnline;
    data['update_time_online'] = updateTimeOnline;
    data['message_to_seller'] = messageToSeller;
    data['order_no'] = orderNo;
    data['shipping_provider_type'] = shippingProviderType;
    data['order_status'] = orderStatus;
    data['tracking_number'] = trackingNumber;
    data['delivery_by'] = deliveryBy;
    data['pickup_by'] = pickupBy;
    data['total_amount'] = totalAmount;
    data['total_qty'] = totalQty;
    data['status'] = status;
    data['online_shop_id'] = onlineShopId;
    data['order_id'] = orderId;
    data['product_picture'] = productPicture;
    data['package_picture'] = packagePicture;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? imageUrl;
  String? itemName;
  String? itemSku;
  String? variation;
  String? skuId;
  String? orderStatus;
  int? orderItemId;
  int? qty;
  int? originalPrice;
  int? discountedPrice;
  int? productId;
  int? orderId;
  String? orderType;

  Items({
    this.imageUrl,
    this.itemName,
    this.itemSku,
    this.variation,
    this.orderItemId,
    this.qty,
    this.originalPrice,
    this.discountedPrice,
    this.productId,
    this.orderId,
    this.orderType,
    this.skuId,
    this.orderStatus,
  });

  Items.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    itemName = json['item_name'];
    itemSku = json['item_sku'];
    skuId = json['sku_id'];
    orderStatus = json['order_status'];
    variation = json['variation'];
    orderItemId = json['order_item_id'];
    qty = json['qty'];
    originalPrice = json['original_price'];
    discountedPrice = json['discounted_price'];
    productId = json['product_id'];
    orderId = json['order_id'];
    orderType = json['order_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_url'] = imageUrl;
    data['item_name'] = itemName;
    data['item_sku'] = itemSku;
    data['sku_id'] = skuId;
    data['order_status'] = orderStatus;
    data['variation'] = variation;
    data['order_item_id'] = orderItemId;
    data['qty'] = qty;
    data['original_price'] = originalPrice;
    data['discounted_price'] = discountedPrice;
    data['product_id'] = productId;
    data['order_id'] = orderId;
    data['order_type'] = orderType;
    return data;
  }
}
