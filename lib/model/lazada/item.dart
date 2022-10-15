class Item {
  int? buyerId;
  String? cancelReturnInitiator;
  String? createdAt;
  String? currency;
  int? deliveryOptionSof;
  String? digitalDeliveryInfo;
  String? extraAttributes;
  String? invoiceNumber;
  int? isDigital;
  int? isFbl;
  int? isReroute;
  int? itemPrice;
  String? name;
  String? orderFlag;
  int? orderId;
  int? orderItemId;
  String? orderType;
  String? packageId;
  int? paidPrice;
  String? productDetailUrl;
  String? productId;
  String? productMainImage;
  String? promisedShippingTime;
  String? purchaseOrderId;
  String? purchaseOrderNumber;
  String? reason;
  String? reasonDetail;
  String? returnStatus;
  String? shipmentProvider;
  int? shippingAmount;
  int? shippingFeeDiscountPlatform;
  int? shippingFeeDiscountSeller;
  int? shippingFeeOriginal;
  String? shippingProviderType;
  int? shippingServiceCost;
  String? shippingType;
  String? shopId;
  String? shopSku;
  String? sku;
  String? skuId;
  String? slaTimeStamp;
  String? stagePayStatus;
  String? status;
  int? taxAmount;
  String? trackingCode;
  String? trackingCodePre;
  String? updatedAt;
  String? variation;
  int? voucherAmount;
  String? voucherCode;
  String? voucherCodePlatform;
  String? voucherCodeSeller;
  int? voucherPlatform;
  int? voucherPlatformLpi;
  int? voucherSeller;
  int? voucherSellerLpi;
  int? walletCredits;
  String? warehouseCode;
  int? qty;

  Item({
    this.buyerId,
    this.cancelReturnInitiator,
    this.createdAt,
    this.currency,
    this.deliveryOptionSof,
    this.digitalDeliveryInfo,
    this.extraAttributes,
    this.invoiceNumber,
    this.isDigital,
    this.isFbl,
    this.isReroute,
    this.itemPrice,
    this.name,
    this.orderFlag,
    this.orderId,
    this.orderItemId,
    this.orderType,
    this.packageId,
    this.paidPrice,
    this.productDetailUrl,
    this.productId,
    this.productMainImage,
    this.promisedShippingTime,
    this.purchaseOrderId,
    this.purchaseOrderNumber,
    this.reason,
    this.reasonDetail,
    this.returnStatus,
    this.shipmentProvider,
    this.shippingAmount,
    this.shippingFeeDiscountPlatform,
    this.shippingFeeDiscountSeller,
    this.shippingFeeOriginal,
    this.shippingProviderType,
    this.shippingServiceCost,
    this.shippingType,
    this.shopId,
    this.shopSku,
    this.sku,
    this.skuId,
    this.slaTimeStamp,
    this.stagePayStatus,
    this.status,
    this.taxAmount,
    this.trackingCode,
    this.trackingCodePre,
    this.updatedAt,
    this.variation,
    this.voucherAmount,
    this.voucherCode,
    this.voucherCodePlatform,
    this.voucherCodeSeller,
    this.voucherPlatform,
    this.voucherPlatformLpi,
    this.voucherSeller,
    this.voucherSellerLpi,
    this.walletCredits,
    this.warehouseCode,
    this.qty,
  });

  Item.fromJson(Map<String, dynamic> json) {
    buyerId = json['buyer_id'];
    cancelReturnInitiator = json['cancel_return_initiator'];
    createdAt = json['created_at'];
    currency = json['currency'];
    deliveryOptionSof = json['delivery_option_sof'];
    digitalDeliveryInfo = json['digital_delivery_info'];
    extraAttributes = json['extra_attributes'];
    invoiceNumber = json['invoice_number'];
    isDigital = json['is_digital'];
    isFbl = json['is_fbl'];
    isReroute = json['is_reroute'];
    itemPrice = json['item_price'];
    name = json['name'];
    orderFlag = json['order_flag'];
    orderId = json['order_id'];
    orderItemId = json['order_item_id'];
    orderType = json['order_type'];
    packageId = json['package_id'];
    paidPrice = json['paid_price'];
    productDetailUrl = json['product_detail_url'];
    productId = json['product_id'];
    productMainImage = json['product_main_image'];
    promisedShippingTime = json['promised_shipping_time'];
    purchaseOrderId = json['purchase_order_id'];
    purchaseOrderNumber = json['purchase_order_number'];
    reason = json['reason'];
    reasonDetail = json['reason_detail'];
    returnStatus = json['return_status'];
    shipmentProvider = json['shipment_provider'];
    shippingAmount = json['shipping_amount'];
    shippingFeeDiscountPlatform = json['shipping_fee_discount_platform'];
    shippingFeeDiscountSeller = json['shipping_fee_discount_seller'];
    shippingFeeOriginal = json['shipping_fee_original'];
    shippingProviderType = json['shipping_provider_type'];
    shippingServiceCost = json['shipping_service_cost'];
    shippingType = json['shipping_type'];
    shopId = json['shop_id'];
    shopSku = json['shop_sku'];
    sku = json['sku'];
    skuId = json['sku_id'];
    slaTimeStamp = json['sla_time_stamp'];
    stagePayStatus = json['stage_pay_status'];
    status = json['status'];
    taxAmount = json['tax_amount'];
    trackingCode = json['tracking_code'];
    trackingCodePre = json['tracking_code_pre'];
    updatedAt = json['updated_at'];
    variation = json['variation'];
    voucherAmount = json['voucher_amount'];
    voucherCode = json['voucher_code'];
    voucherCodePlatform = json['voucher_code_platform'];
    voucherCodeSeller = json['voucher_code_seller'];
    voucherPlatform = json['voucher_platform'];
    voucherPlatformLpi = json['voucher_platform_lpi'];
    voucherSeller = json['voucher_seller'];
    voucherSellerLpi = json['voucher_seller_lpi'];
    walletCredits = json['wallet_credits'];
    warehouseCode = json['warehouse_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['buyer_id'] = buyerId;
    data['cancel_return_initiator'] = cancelReturnInitiator;
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['delivery_option_sof'] = deliveryOptionSof;
    data['digital_delivery_info'] = digitalDeliveryInfo;
    data['extra_attributes'] = extraAttributes;
    data['invoice_number'] = invoiceNumber;
    data['is_digital'] = isDigital;
    data['is_fbl'] = isFbl;
    data['is_reroute'] = isReroute;
    data['item_price'] = itemPrice;
    data['name'] = name;
    data['order_flag'] = orderFlag;
    data['order_id'] = orderId;
    data['order_item_id'] = orderItemId;
    data['order_type'] = orderType;
    data['package_id'] = packageId;
    data['paid_price'] = paidPrice;
    data['product_detail_url'] = productDetailUrl;
    data['product_id'] = productId;
    data['product_main_image'] = productMainImage;
    data['promised_shipping_time'] = promisedShippingTime;
    data['purchase_order_id'] = purchaseOrderId;
    data['purchase_order_number'] = purchaseOrderNumber;
    data['reason'] = reason;
    data['reason_detail'] = reasonDetail;
    data['return_status'] = returnStatus;
    data['shipment_provider'] = shipmentProvider;
    data['shipping_amount'] = shippingAmount;
    data['shipping_fee_discount_platform'] = shippingFeeDiscountPlatform;
    data['shipping_fee_discount_seller'] = shippingFeeDiscountSeller;
    data['shipping_fee_original'] = shippingFeeOriginal;
    data['shipping_provider_type'] = shippingProviderType;
    data['shipping_service_cost'] = shippingServiceCost;
    data['shipping_type'] = shippingType;
    data['shop_id'] = shopId;
    data['shop_sku'] = shopSku;
    data['sku'] = sku;
    data['sku_id'] = skuId;
    data['sla_time_stamp'] = slaTimeStamp;
    data['stage_pay_status'] = stagePayStatus;
    data['status'] = status;
    data['tax_amount'] = taxAmount;
    data['tracking_code'] = trackingCode;
    data['tracking_code_pre'] = trackingCodePre;
    data['updated_at'] = updatedAt;
    data['variation'] = variation;
    data['voucher_amount'] = voucherAmount;
    data['voucher_code'] = voucherCode;
    data['voucher_code_platform'] = voucherCodePlatform;
    data['voucher_code_seller'] = voucherCodeSeller;
    data['voucher_platform'] = voucherPlatform;
    data['voucher_platform_lpi'] = voucherPlatformLpi;
    data['voucher_seller'] = voucherSeller;
    data['voucher_seller_lpi'] = voucherSellerLpi;
    data['wallet_credits'] = walletCredits;
    data['warehouse_code'] = warehouseCode;
    return data;
  }
}
