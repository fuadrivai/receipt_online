import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';

class CardOrder extends StatelessWidget {
  final GestureTapCallback? onTap;
  final TransactionOnline order;
  const CardOrder({super.key, this.onTap, required this.order});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat("#,##0", "en_US");
    List<Items> listItem = [];
    Color deliveryTpeColor = Colors.redAccent;
    for (Items e in (order.items ?? [])) {
      bool isExis = listItem.any((el) => el.skuId == e.skuId);
      if (isExis) {
        listItem
            .where((elm) => elm.skuId == e.skuId)
            .toList()
            .forEach((elm) => elm.qty = elm.qty! + 1);
      } else {
        e.qty = 1;
        listItem.add(e);
      }
    }
    switch (order.shippingProviderType?.toLowerCase()) {
      case "economy":
        deliveryTpeColor = const Color.fromARGB(255, 12, 155, 17);
        break;
      case "standard":
        deliveryTpeColor = Colors.blueAccent;
        break;
      default:
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 3,
      ),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shadowColor: Colors.black,
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              ListTile(
                visualDensity: VisualDensity.comfortable,
                title: Row(
                  children: [
                    order.trackingNumber == ""
                        ? const SizedBox()
                        : Text(
                            'Resi : ${order.trackingNumber ?? ""}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(width: 4),
                    badge.Badge(
                      badgeStyle: badge.BadgeStyle(
                        shape: badge.BadgeShape.square,
                        badgeColor: deliveryTpeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      badgeContent: Text(
                        (order.shippingProviderType ?? "standard")
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No. Order : ${order.orderId}'),
                    Text(
                        'Tanggal : ${Jiffy.parse(order.createTimeOnline!, pattern: "yyyy-MM-dd HH:mm:ss").format(pattern: "dd MMMM yyyy HH:mm:ss")}'),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Qty',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    badge.Badge(
                      badgeStyle: badge.BadgeStyle(
                        shape: badge.BadgeShape.square,
                        badgeColor: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      badgeContent: Text(
                        order.totalQty.toString(),
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
                children: listItem.map((e) {
                  return ListTile(
                    visualDensity: VisualDensity.comfortable,
                    title: Text(e.itemName ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SKU : ${e.itemSku ?? '--'}"),
                        e.variation != ""
                            ? Text(e.variation ?? "")
                            : const SizedBox(),
                        Text(
                          "Rp. ${currency.format(e.discountedPrice)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        listItem.last == e
                            ? const SizedBox()
                            : const Divider(color: Colors.grey)
                      ],
                    ),
                    trailing: Text(
                      e.qty.toString(),
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
                      splashColor: Colors.white10, // Splash color over image
                      child: Ink.image(
                        fit: BoxFit.cover, // Fixes border issues
                        width: 60,
                        image: NetworkImage(e.imageUrl!),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Divider(color: Colors.black45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Total Rp. ${currency.format(order.totalAmount ?? "0")}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Status Paket'),
                        const SizedBox(width: 10),
                        badge.Badge(
                          badgeStyle: badge.BadgeStyle(
                            shape: badge.BadgeShape.square,
                            badgeColor: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(4),
                          ),
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
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final Items item;
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
            Center(child: Image.network(item.imageUrl!)),
            const Divider(color: Colors.grey),
            ListTile(
              visualDensity: VisualDensity.comfortable,
              title: Text(item.itemName ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Seller SKU : ${item.itemSku ?? '--'}"),
                  Text(item.variation ?? "")
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
                    item.qty.toString(),
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
