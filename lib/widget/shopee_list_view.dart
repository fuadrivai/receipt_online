// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/service/api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

class ShopeeListView extends StatelessWidget {
  final List<TransactionOnline> orders;
  final Function(TransactionOnline order) onPressed;
  const ShopeeListView(
      {super.key, required this.orders, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat("#,##0", "en_US");
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, i) {
        TransactionOnline order = orders[i];
        List<Items> listItem = [];
        (order.items ?? []).sort(
            (a, b) => (b.orderStatus ?? "").compareTo(a.orderStatus ?? ""));
        for (Items e in (order.items ?? [])) {
          bool isExis = listItem.any((el) =>
              (el.skuId == e.skuId) && (el.orderStatus == e.orderStatus));
          if (isExis) {
            if (e.skuId == null) {
              listItem.add(e);
            } else {
              listItem
                  .where((elm) => elm.skuId == e.skuId)
                  .toList()
                  .forEach((elm) => elm.qty = elm.qty! + 1);
            }
          } else {
            // e.qty = e.qty;
            listItem.add(e);
          }
        }
        Color deliveryTpeColor = Colors.redAccent;
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
          child: Card(
            shadowColor: Colors.black,
            child: Column(
              children: [
                order.pickupBy == ""
                    ? const SizedBox()
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            order.pickupBy ?? "",
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
                          (order.shippingProviderType == null) ||
                                  (order.trackingNumber == "")
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Badge(
                                    toAnimate: false,
                                    shape: BadgeShape.square,
                                    badgeColor: deliveryTpeColor,
                                    borderRadius: BorderRadius.circular(4),
                                    badgeContent: Text(
                                      (order.shippingProviderType ?? "standard")
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No. Order : ${order.orderNo}'),
                          Text(
                              'Tanggal : ${Jiffy(order.createTimeOnline).format("dd MMMM yyyy HH:mm")}'),
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
                          Badge(
                            toAnimate: false,
                            shape: BadgeShape.square,
                            badgeColor: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(4),
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
                        TextStyle _style = e.orderStatus == "BATAL"
                            ? const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              )
                            : const TextStyle();
                        return ListTile(
                          visualDensity: VisualDensity.comfortable,
                          title: Text(
                            e.itemName ?? "",
                            style: _style,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              e.variation != ""
                                  ? Text(
                                      e.variation ?? "",
                                      style: _style,
                                    )
                                  : const SizedBox(),
                              e.itemSku == ""
                                  ? const SizedBox()
                                  : Text(
                                      "Seller SKU : ${e.itemSku ?? '--'}",
                                      style: _style,
                                    ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rp. ${currency.format(e.originalPrice)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  e.orderStatus == "BATAL"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Badge(
                                            toAnimate: false,
                                            shape: BadgeShape.square,
                                            badgeColor: Colors.redAccent,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            badgeContent: Text(
                                              e.orderStatus ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
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
                            splashColor:
                                Colors.white10, // Splash color over image
                            child: Ink.image(
                              fit: BoxFit.cover, // Fixes border issues
                              width: 60,
                              image: NetworkImage(e.imageUrl ?? ""),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(color: Colors.black45),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Catatan Pembeli',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            order.messageToSeller ?? "",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                            badgeColor: order.orderStatus == "BATAL"
                                ? Colors.redAccent
                                : Colors.deepPurple,
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
                    ),
                    Visibility(
                      visible: order.showRequest ?? false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: true,
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: DefaultColor.primary,
                                  ),
                                  onPressed: () {
                                    onPressed(order);
                                  },
                                  child: const Text(
                                    "Siap Kirim",
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    // order.totalQty = totalQty;
                                    Api.postOrder(order).then((value) {
                                      print(value);
                                    }).catchError((e) {
                                      print(e);
                                    });
                                  },
                                  child: const Text(
                                    "Buat Paket",
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
            Center(child: Image.network(item.imageUrl ?? "")),
            const Divider(color: Colors.grey),
            ListTile(
              visualDensity: VisualDensity.comfortable,
              title: Text(item.itemName ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.variation ?? ""),
                  item.itemSku == ""
                      ? const SizedBox()
                      : Text("Seller SKU : ${item.itemSku ?? '--'}"),
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
