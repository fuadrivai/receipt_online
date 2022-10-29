class ItemShopee {
  int? itemId;
  String? itemName;
  String? itemSku;
  int? modelId;
  String? modelName;
  String? modelSku;
  int? modelQuantityPurchased;
  int? modelOriginalPrice;
  int? modelDiscountedPrice;
  bool? wholesale;
  double? weight;
  bool? addOnDeal;
  bool? mainItem;
  int? addOnDealId;
  String? promotionType;
  int? promotionId;
  int? orderItemId;
  int? promotionGroupId;
  ImageInfo? imageInfo;
  List<String>? productLocationId;
  bool? isPrescriptionItem;
  bool? isB2cOwnedItem;

  ItemShopee(
      {this.itemId,
      this.itemName,
      this.itemSku,
      this.modelId,
      this.modelName,
      this.modelSku,
      this.modelQuantityPurchased,
      this.modelOriginalPrice,
      this.modelDiscountedPrice,
      this.wholesale,
      this.weight,
      this.addOnDeal,
      this.mainItem,
      this.addOnDealId,
      this.promotionType,
      this.promotionId,
      this.orderItemId,
      this.promotionGroupId,
      this.imageInfo,
      this.productLocationId,
      this.isPrescriptionItem,
      this.isB2cOwnedItem});

  ItemShopee.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemSku = json['item_sku'];
    modelId = json['model_id'];
    modelName = json['model_name'];
    modelSku = json['model_sku'];
    modelQuantityPurchased = json['model_quantity_purchased'];
    modelOriginalPrice = json['model_original_price'];
    modelDiscountedPrice = json['model_discounted_price'];
    wholesale = json['wholesale'];
    weight = json['weight'];
    addOnDeal = json['add_on_deal'];
    mainItem = json['main_item'];
    addOnDealId = json['add_on_deal_id'];
    promotionType = json['promotion_type'];
    promotionId = json['promotion_id'];
    orderItemId = json['order_item_id'];
    promotionGroupId = json['promotion_group_id'];
    imageInfo = json['image_info'] != null
        ? ImageInfo.fromJson(json['image_info'])
        : null;
    productLocationId = json['product_location_id'].cast<String>();
    isPrescriptionItem = json['is_prescription_item'];
    isB2cOwnedItem = json['is_b2c_owned_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_sku'] = itemSku;
    data['model_id'] = modelId;
    data['model_name'] = modelName;
    data['model_sku'] = modelSku;
    data['model_quantity_purchased'] = modelQuantityPurchased;
    data['model_original_price'] = modelOriginalPrice;
    data['model_discounted_price'] = modelDiscountedPrice;
    data['wholesale'] = wholesale;
    data['weight'] = weight;
    data['add_on_deal'] = addOnDeal;
    data['main_item'] = mainItem;
    data['add_on_deal_id'] = addOnDealId;
    data['promotion_type'] = promotionType;
    data['promotion_id'] = promotionId;
    data['order_item_id'] = orderItemId;
    data['promotion_group_id'] = promotionGroupId;
    if (imageInfo != null) {
      data['image_info'] = imageInfo!.toJson();
    }
    data['product_location_id'] = productLocationId;
    data['is_prescription_item'] = isPrescriptionItem;
    data['is_b2c_owned_item'] = isB2cOwnedItem;
    return data;
  }
}

class ImageInfo {
  String? imageUrl;

  ImageInfo({this.imageUrl});

  ImageInfo.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_url'] = imageUrl;
    return data;
  }
}
