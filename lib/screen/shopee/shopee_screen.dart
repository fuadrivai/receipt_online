import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/shopee/item_shopee.dart';
import 'package:receipt_online_shop/model/shopee/shopee_order.dart';
import 'package:receipt_online_shop/screen/shopee/data/shopee_api.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ShopeeScreen extends StatefulWidget {
  const ShopeeScreen({super.key});

  @override
  State<ShopeeScreen> createState() => _ShopeeScreenState();
}

class _ShopeeScreenState extends State<ShopeeScreen> {
  List<ShopeeOrder> orders = [];
  final currency = NumberFormat("#,##0", "en_US");
  late bool visible;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopee Order Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) async {
                  orders = await ShopeeApi.getShopeeOrderByNo(barcodeScanner);
                  setState(() {});
                },
              );
            },
          )
        ],
      ),
      body: VisibilityDetector(
        key: const Key('visible-detector-key'),
        onVisibilityChanged: (VisibilityInfo info) {
          visible = info.visibleFraction > 0;
        },
        child: BarcodeKeyboardListener(
          onBarcodeScanned: (String barcode) async {
            orders = await ShopeeApi.getShopeeOrderByNo(barcode);
            setState(() {});
          },
          child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, i) {
                ShopeeOrder order = orders[i];
                DateTime date = DateTime.fromMillisecondsSinceEpoch(
                    (order.createTime ?? 0) * 1000);
                int totalQty = 0;
                for (ItemShopee e in (order.itemList ?? [])) {
                  {
                    totalQty = totalQty + (e.modelQuantityPurchased ?? 0);
                  }
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 3,
                  ),
                  child: Card(
                    shadowColor: Colors.black,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              order.shippingCarrier ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: Colors.black45),
                        ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            ListTile(
                              visualDensity: VisualDensity.comfortable,
                              title: Text(
                                'Resi : ${order.trackingNumber ?? ""}',
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('No. Order : ${order.orderSn}'),
                                  Text(
                                      'Tanggal : ${Jiffy(date).format("dd MMMM yyyy HH:mm")}'),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Total Qty',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(4),
                                    badgeContent: Text(
                                      totalQty.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.black45),
                            Column(
                              children: (order.itemList ?? []).map((e) {
                                totalQty =
                                    totalQty + (e.modelQuantityPurchased ?? 0);
                                return ListTile(
                                  visualDensity: VisualDensity.comfortable,
                                  title: Text(e.itemName ?? ""),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      e.modelName != ""
                                          ? Text(e.modelName ?? "")
                                          : const SizedBox(),
                                      Text("SKU : ${e.itemSku ?? '--'}"),
                                      Text(
                                        "Rp. ${currency.format(e.modelDiscountedPrice == 0 ? e.modelOriginalPrice : e.modelDiscountedPrice)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      (order.itemList ?? []).last == e
                                          ? const SizedBox()
                                          : const Divider(color: Colors.grey)
                                    ],
                                  ),
                                  trailing: Text(
                                    e.modelQuantityPurchased.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  leading: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (_) => ImageDialog(item: e),
                                      );
                                    },
                                    splashColor: Colors
                                        .white10, // Splash color over image
                                    child: Ink.image(
                                      fit: BoxFit.cover, // Fixes border issues
                                      width: 60,
                                      image: NetworkImage(
                                          e.imageInfo?.imageUrl ?? ""),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const Divider(color: Colors.black45),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Status Paket'),
                                  const SizedBox(width: 10),
                                  Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(4),
                                    badgeContent: Text(
                                      order.orderStatus ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final ItemShopee item;
  const ImageDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 550),
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                )
              ],
            ),
            Center(child: Image.network(item.imageInfo?.imageUrl ?? "")),
            const Divider(color: Colors.grey),
            ListTile(
              visualDensity: VisualDensity.comfortable,
              title: Text(item.itemName ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.modelName ?? ""),
                  Text("Seller SKU : ${item.itemSku ?? '--'}"),
                ],
              ),
              trailing: Column(
                children: [
                  const Text(
                    'QTY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.modelQuantityPurchased.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
