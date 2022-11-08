import 'package:badges/badges.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/shopee/bloc/shopee_bloc.dart';
import 'package:receipt_online_shop/service/api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

class ShopeeListView extends StatelessWidget {
  final List<TransactionOnline> orders;
  const ShopeeListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat("#,##0", "en_US");
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, i) {
        TransactionOnline order = orders[i];

        int totalQty = 0;
        for (Items e in (order.items ?? [])) {
          {
            totalQty = totalQty + (e.qty ?? 0);
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
                      children: (order.items ?? []).map((e) {
                        totalQty = totalQty + (e.qty ?? 0);
                        return ListTile(
                          visualDensity: VisualDensity.comfortable,
                          title: Text(e.itemName ?? ""),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              e.variation != ""
                                  ? Text(e.variation ?? "")
                                  : const SizedBox(),
                              Text("SKU : ${e.itemSku ?? '--'}"),
                              Text(
                                "Rp. ${currency.format(e.discountedPrice == 0 ? e.originalPrice : e.discountedPrice)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              (order.items ?? []).last == e
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
                    ),
                    Visibility(
                      visible: (order.orderStatus == "READY_TO_SHIP"),
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
                                  onPressed: () async {
                                    if (await confirm(
                                      context,
                                      content: const Text(
                                          'Yakin Ingin Memanggil Kurir'),
                                      textOK: const Text('Panggil'),
                                      textCancel: const Text('Kembali'),
                                    )) {
                                      context
                                          .read<ShopeeDetailBloc>()
                                          .add(ShopeeRtsEvent(order.orderNo!));
                                    }
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
                                    order.totalQty = totalQty;
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
                  Text(item.itemName ?? ""),
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
