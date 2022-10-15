import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/lazada/item.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/lazada_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';

class LazadaDetailOrderScreen extends StatefulWidget {
  final int orderId;
  const LazadaDetailOrderScreen({super.key, required this.orderId});

  @override
  State<LazadaDetailOrderScreen> createState() =>
      _LazadaDetailOrderScreenState();
}

class _LazadaDetailOrderScreenState extends State<LazadaDetailOrderScreen> {
  @override
  void initState() {
    context.read<LazadaBloc>().add(GetSingleOrder(widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
      ),
      body: BlocBuilder<LazadaBloc, LazadaState>(builder: (context, state) {
        List<Item> listItem = [];
        for (Item e in (state.order?.items ?? [])) {
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
        return state.isLoading
            ? const LoadingScreen()
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 3,
                ),
                child: Card(
                  shadowColor: Colors.black,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: [
                      ListTile(
                        visualDensity: VisualDensity.comfortable,
                        title:
                            Text('Resi : ${state.order?.trackingNumber ?? ""}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('No. Order : ${state.order?.orderId}'),
                            Text(
                                'Tanggal : ${Jiffy(state.order?.createdAt).format("dd MMMM yyyy HH:mm:ss")}'),
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
                                (state.order?.itemsCount ?? 0).toString(),
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
                      ListView(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            leading: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.network(e.productMainImage!),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
