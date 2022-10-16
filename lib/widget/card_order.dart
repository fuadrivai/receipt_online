import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/lazada/item.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';

class CardOrder extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Order order;
  const CardOrder({super.key, this.onTap, required this.order});

  @override
  Widget build(BuildContext context) {
    List<Item> listItem = [];
    Color deliveryTpeColor = Colors.redAccent;
    for (Item e in (order.items ?? [])) {
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
                    Text('Resi : ${order.trackingNumber ?? ""}'),
                    const SizedBox(width: 4),
                    Badge(
                      toAnimate: false,
                      shape: BadgeShape.square,
                      badgeColor: deliveryTpeColor,
                      borderRadius: BorderRadius.circular(4),
                      badgeContent: Text(
                        (order.shippingProviderType ?? "standard")
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
                        'Tanggal : ${Jiffy(order.createdAt).format("dd MMMM yyyy HH:mm:ss")}'),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total Qty',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Badge(
                      toAnimate: false,
                      shape: BadgeShape.square,
                      badgeColor: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(4),
                      badgeContent: Text(
                        order.itemsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black45,
              ),
              Column(
                children: listItem.map((e) {
                  return ListTile(
                    visualDensity: VisualDensity.comfortable,
                    title: Text(e.name ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SKU : ${e.sku ?? '--'}"),
                        e.variation != ""
                            ? Text(e.variation ?? "")
                            : const SizedBox(),
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
                        image: NetworkImage(e.productMainImage!),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final Item item;
  const ImageDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 500),
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
            Center(child: Image.network(item.productMainImage!)),
            const Divider(color: Colors.grey),
            ListTile(
              visualDensity: VisualDensity.comfortable,
              title: Text(item.name ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Seller SKU : ${item.sku ?? '--'}"),
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
