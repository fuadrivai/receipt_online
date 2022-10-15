import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/lazada/item.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/lazada_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/lazada_detail_screen.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';

class LazadaScreen extends StatefulWidget {
  const LazadaScreen({super.key});

  @override
  State<LazadaScreen> createState() => _LazadaScreenState();
}

class _LazadaScreenState extends State<LazadaScreen> {
  @override
  void initState() {
    context.read<LazadaBloc>().add(GetFullOder());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazada Printed"),
        actions: [
          BlocBuilder<LazadaBloc, LazadaState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.qr_code_scanner_outlined),
                onPressed: () {
                  Common.scanBarcodeNormal(context,
                      onSuccess: (barcodeScanner) {
                    List<Order> orders = (state.fullOrder?.orders ?? [])
                        .where((e) => e.trackingNumber == barcodeScanner)
                        .toList();
                    if (orders.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (__) => LazadaDetailOrderScreen(
                                  orderId: orders[0].orderId!,
                                )),
                      );
                    } else {
                      Common.modalInfo(context,
                          title: "Error",
                          message: "Nomor resi $barcodeScanner Tidak Valid");
                    }
                  });
                },
              );
            },
          )
        ],
      ),
      body: BlocBuilder<LazadaBloc, LazadaState>(
        builder: (context, state) {
          return state.isLoading
              ? const LoadingScreen()
              : Column(
                  children: [
                    Row(
                      children: [],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (__, i) {
                          Order order = (state.fullOrder?.orders ?? [])[i];
                          List<Item> listItem = [];
                          for (Item e in (order.items ?? [])) {
                            bool isExis =
                                listItem.any((el) => el.skuId == e.skuId);
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 3,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (__) => LazadaDetailOrderScreen(
                                          orderId: order.orderId!)),
                                );
                              },
                              child: Card(
                                shadowColor: Colors.black,
                                child: Column(
                                  children: [
                                    ListTile(
                                      visualDensity: VisualDensity.comfortable,
                                      title: Text(
                                          'Resi : ${order.trackingNumber ?? ""}'),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('No. Order : ${order.orderId}'),
                                          Text(
                                              'Tanggal : ${Jiffy(order.createdAt).format("dd MMMM yyyy HH:mm:ss")}'),
                                        ],
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Total Qty',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Badge(
                                            toAnimate: false,
                                            shape: BadgeShape.square,
                                            badgeColor: Colors.deepPurple,
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                          visualDensity:
                                              VisualDensity.comfortable,
                                          title: Text(e.name ?? ""),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("SKU : ${e.sku ?? '--'}"),
                                              e.variation != ""
                                                  ? Text(e.variation ?? "")
                                                  : const SizedBox(),
                                              listItem.last == e
                                                  ? const SizedBox()
                                                  : const Divider(
                                                      color: Colors.grey)
                                            ],
                                          ),
                                          trailing: Text(
                                            e.qty.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          leading: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Image.network(
                                                e.productMainImage!),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: state.fullOrder?.orders?.length ?? 0,
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
