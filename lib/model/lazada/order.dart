import 'package:receipt_online_shop/model/lazada/address_billing.dart';
import 'package:receipt_online_shop/model/lazada/address_shipping.dart';
import 'package:receipt_online_shop/model/lazada/item.dart';

class Order {
  int? voucherPlatform;
  int? voucher;
  String? warehouseCode;
  int? orderNumber;
  int? voucherSeller;
  String? createdAt;
  String? voucherCode;
  bool? giftOption;
  int? shippingFeeDiscountPlatform;
  String? customerLastName;
  String? promisedShippingTimes;
  String? updatedAt;
  String? price;
  String? nationalRegistrationNumber;
  int? shippingFeeOriginal;
  String? paymentMethod;
  String? customerFirstName;
  int? shippingFeeDiscountSeller;
  int? shippingFee;
  String? branchNumber;
  String? taxCode;
  int? itemsCount;
  String? deliveryInfo;
  List<String>? statuses;
  AddressBilling? addressBilling;
  AddressShipping? addressShipping;
  String? extraAttributes;
  int? orderId;
  String? remarks;
  String? giftMessage;
  List<Item>? items;
  String? trackingNumber;
  String? shippingProviderType;
  String? shipmentProvider;

  Order({
    this.voucherPlatform,
    this.voucher,
    this.warehouseCode,
    this.orderNumber,
    this.voucherSeller,
    this.createdAt,
    this.voucherCode,
    this.giftOption,
    this.shippingFeeDiscountPlatform,
    this.customerLastName,
    this.promisedShippingTimes,
    this.updatedAt,
    this.price,
    this.nationalRegistrationNumber,
    this.shippingFeeOriginal,
    this.paymentMethod,
    this.customerFirstName,
    this.shippingFeeDiscountSeller,
    this.shippingFee,
    this.branchNumber,
    this.taxCode,
    this.itemsCount,
    this.deliveryInfo,
    this.statuses,
    this.addressBilling,
    this.addressShipping,
    this.extraAttributes,
    this.orderId,
    this.remarks,
    this.giftMessage,
    this.items,
    this.trackingNumber,
    this.shippingProviderType,
    this.shipmentProvider,
  });

  Order.fromJson(Map<String, dynamic> json) {
    voucherPlatform = json['voucher_platform'];
    voucher = json['voucher'];
    warehouseCode = json['warehouse_code'];
    orderNumber = json['order_number'];
    voucherSeller = json['voucher_seller'];
    createdAt = json['created_at'];
    voucherCode = json['voucher_code'];
    giftOption = json['gift_option'];
    shippingFeeDiscountPlatform = json['shipping_fee_discount_platform'];
    customerLastName = json['customer_last_name'];
    promisedShippingTimes = json['promised_shipping_times'];
    updatedAt = json['updated_at'];
    price = json['price'];
    nationalRegistrationNumber = json['national_registration_number'];
    shippingFeeOriginal = json['shipping_fee_original'];
    paymentMethod = json['payment_method'];
    customerFirstName = json['customer_first_name'];
    shippingFeeDiscountSeller = json['shipping_fee_discount_seller'];
    shippingFee = json['shipping_fee'];
    branchNumber = json['branch_number'];
    taxCode = json['tax_code'];
    itemsCount = json['items_count'];
    deliveryInfo = json['delivery_info'];
    statuses = json['statuses'].cast<String>();
    addressBilling = json['address_billing'] != null
        ? AddressBilling.fromJson(json['address_billing'])
        : null;
    addressShipping = json['address_shipping'] != null
        ? AddressShipping.fromJson(json['address_shipping'])
        : null;
    extraAttributes = json['extra_attributes'];
    orderId = json['order_id'];
    remarks = json['remarks'];
    giftMessage = json['gift_message'];
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items!.add(Item.fromJson(v));
      });
    }
    trackingNumber = json['tracking_number'];
    shippingProviderType = json['shipping_provider_type'];
    shipmentProvider = json['shipment_provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voucher_platform'] = voucherPlatform;
    data['voucher'] = voucher;
    data['warehouse_code'] = warehouseCode;
    data['order_number'] = orderNumber;
    data['voucher_seller'] = voucherSeller;
    data['created_at'] = createdAt;
    data['voucher_code'] = voucherCode;
    data['gift_option'] = giftOption;
    data['shipping_fee_discount_platform'] = shippingFeeDiscountPlatform;
    data['customer_last_name'] = customerLastName;
    data['promised_shipping_times'] = promisedShippingTimes;
    data['updated_at'] = updatedAt;
    data['price'] = price;
    data['national_registration_number'] = nationalRegistrationNumber;
    data['shipping_fee_original'] = shippingFeeOriginal;
    data['payment_method'] = paymentMethod;
    data['customer_first_name'] = customerFirstName;
    data['shipping_fee_discount_seller'] = shippingFeeDiscountSeller;
    data['shipping_fee'] = shippingFee;
    data['branch_number'] = branchNumber;
    data['tax_code'] = taxCode;
    data['items_count'] = itemsCount;
    data['delivery_info'] = deliveryInfo;
    data['statuses'] = statuses;
    if (addressBilling != null) {
      data['address_billing'] = addressBilling!.toJson();
    }
    if (addressShipping != null) {
      data['address_shipping'] = addressShipping!.toJson();
    }
    data['extra_attributes'] = extraAttributes;
    data['order_id'] = orderId;
    data['remarks'] = remarks;
    data['gift_message'] = giftMessage;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['tracking_number'] = trackingNumber;
    data['shipment_provider'] = shipmentProvider;
    return data;
  }
}
