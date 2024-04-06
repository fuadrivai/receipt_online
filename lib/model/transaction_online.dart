import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/model/receipt_detail_product.dart';

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
  bool? showRequest;
  bool? showButton;
  bool? scanned;
  Platform? platform;
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
    this.platform,
    this.scanned = false,
    this.showRequest = false,
    this.showButton = false,
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
    showRequest = json['show_request'];
    showButton = json['show_button'];
    scanned = json['scanned'];
    shippingProviderType = json['shipping_provider_type'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    platform =
        json['platform'] != null ? Platform.fromJson(json['platform']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['create_time_online'] = createTimeOnline;
    data['update_time_online'] = updateTimeOnline;
    data['message_to_seller'] = messageToSeller;
    data['order_no'] = orderNo;
    data['shipping_provider_type'] = shippingProviderType;
    data['show_request'] = showRequest;
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
    data['show_button'] = showButton;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (platform != null) {
      data['platform'] = platform!.toJson();
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
  String? trackingNumber;
  List<ReceiptDetailProduct>? manuals;
  List<ReceiptDetailProduct>? gifts;

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
    this.trackingNumber,
    this.manuals,
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
    trackingNumber = json['tracking_number'];
    orderType = json['order_type'];
    if (json['manuals'] != null) {
      manuals = <ReceiptDetailProduct>[];
      json['manuals'].forEach((v) {
        manuals!.add(ReceiptDetailProduct.fromJson(v));
      });
    }
    if (json['gifts'] != null) {
      gifts = <ReceiptDetailProduct>[];
      json['gifts'].forEach((v) {
        gifts!.add(ReceiptDetailProduct.fromJson(v));
      });
    }
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
    data['tracking_number'] = trackingNumber;
    if (manuals != null) {
      data['manuals'] = manuals!.map((v) => v.toJson()).toList();
    }
    if (gifts != null) {
      data['gifts'] = manuals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
