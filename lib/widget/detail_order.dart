import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/receipt_detail_product.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/screen/product/screen/product_screen_single.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/default_color.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class DetailOrder extends StatelessWidget {
  final List<TransactionOnline> orders;
  final List<List<bool>> listExpands;
  final Function(TransactionOnline order) onPressed;
  final Function(TransactionOnline order) onCreateOrder;
  const DetailOrder({
    super.key,
    required this.orders,
    required this.onPressed,
    required this.onCreateOrder,
    required this.listExpands,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, i) {
        TransactionOnline order = orders[i];
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                PickupByWidget(pickupBy: order.pickupBy ?? ""),
                ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    HeaderWidget(
                      deliveryTpeColor: deliveryTpeColor,
                      order: order,
                    ),
                    const Divider(color: Colors.black45),
                    DetailItemWidget(
                        listItem: order.items ?? [], listExpands: listExpands),
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
                          badge.Badge(
                            badgeStyle: badge.BadgeStyle(
                              shape: badge.BadgeShape.square,
                              badgeColor: order.orderStatus == "BATAL"
                                  ? Colors.redAccent
                                  : Colors.deepPurple,
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
                    Visibility(
                      visible: order.showButton ?? false,
                      // visible: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: order.showRequest ?? false,
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
                              visible: !(order.showRequest ?? false),
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    onCreateOrder(order);
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

class PickupByWidget extends StatelessWidget {
  final String pickupBy;
  const PickupByWidget({super.key, required this.pickupBy});

  @override
  Widget build(BuildContext context) {
    return pickupBy == ""
        ? const SizedBox()
        : Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    pickupBy,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black45),
            ],
          );
  }
}

class HeaderWidget extends StatelessWidget {
  final TransactionOnline order;
  final Color deliveryTpeColor;
  const HeaderWidget({
    super.key,
    required this.order,
    required this.deliveryTpeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
          (order.shippingProviderType == null) || (order.trackingNumber == "")
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: badge.Badge(
                    badgeStyle: badge.BadgeStyle(
                      shape: badge.BadgeShape.square,
                      badgeColor: deliveryTpeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    badgeContent: Text(
                      (order.shippingProviderType ?? "standard").toUpperCase(),
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
              'Tanggal : ${Jiffy.parse(order.createTimeOnline!, pattern: "yyyy-MM-dd HH:mm:ss").format(pattern: "dd MMMM yyyy HH:mm")}'),
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
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailItemWidget extends StatefulWidget {
  final List<Items> listItem;
  final List<List<bool>> listExpands;
  const DetailItemWidget(
      {super.key, required this.listItem, required this.listExpands});

  @override
  State<DetailItemWidget> createState() => _DetailItemWidgetState();
}

class _DetailItemWidgetState extends State<DetailItemWidget> {
  List<List<bool>> _listExpand = [];
  @override
  void initState() {
    _listExpand = widget.listExpands;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.listItem
          .asMap()
          .map((key, e) {
            TextStyle style = e.orderStatus == "BATAL"
                ? const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  )
                : const TextStyle();
            return MapEntry(
                key,
                Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity.comfortable,
                      title: Text(e.itemName ?? "", style: style),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          e.variation != ""
                              ? Text(e.variation ?? "", style: style)
                              : const SizedBox(),
                          e.itemSku == ""
                              ? const SizedBox()
                              : Text("SKU : ${e.itemSku ?? '--'}",
                                  style: style),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp. ${Common.oCcy.format(e.originalPrice)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              e.orderStatus == "BATAL"
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: badge.Badge(
                                        badgeStyle: badge.BadgeStyle(
                                          shape: badge.BadgeShape.square,
                                          badgeColor: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
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
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buttonManual(
                                item: e,
                                isGift: false,
                                title: "Input Manual",
                                onBack: (val) {
                                  context
                                      .read<ProductCheckerBloc>()
                                      .add(OnInputProduct(val, e));
                                  setState(() {});
                                },
                              ),
                              buttonManual(
                                item: e,
                                isGift: true,
                                title: "Input Hadiah",
                                backgroundColor: Colors.green[300],
                                onBack: (val) {
                                  context
                                      .read<ProductCheckerBloc>()
                                      .add(OnInputGift(val, e));
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
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
                        child: Image.network(
                          e.imageUrl ?? "",
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ((e.manuals ?? []).isEmpty && (e.gifts ?? []).isEmpty)
                        ? const SizedBox.shrink()
                        : ExpansionPanelList(
                            expandedHeaderPadding:
                                const EdgeInsets.only(top: 2, bottom: 0),
                            animationDuration:
                                const Duration(milliseconds: 1000),
                            elevation: 0,
                            expansionCallback: (i, val) {
                              setState(() {
                                _listExpand[key][i] = val;
                              });
                            },
                            children: [
                              ExpansionPanel(
                                canTapOnHeader: true,
                                isExpanded: (e.manuals ?? []).isEmpty
                                    ? false
                                    : _listExpand[key][0],
                                headerBuilder: (ctx, spand) {
                                  return ListTile(
                                    dense: true,
                                    title: const Text("Produk Pengganti"),
                                    trailing: Text(
                                        (e.manuals ?? []).length.toString()),
                                  );
                                },
                                body: ((e.manuals ?? []).isEmpty)
                                    ? const SizedBox.shrink()
                                    : ExpansionBody(
                                        data: (e.manuals ?? []),
                                        onPressed: (p) async {
                                          context
                                              .read<ProductCheckerBloc>()
                                              .add(OnRemoveProduct(
                                                  e, p.barcode ?? ""));
                                          setState(() {});
                                        },
                                        onChanged: (val) {},
                                      ),
                              ),
                              ExpansionPanel(
                                canTapOnHeader: true,
                                isExpanded: (e.gifts ?? []).isEmpty
                                    ? false
                                    : _listExpand[key][1],
                                headerBuilder: (ctx, spand) {
                                  return const ListTile(
                                    dense: true,
                                    title: Text("Produk Hadiah"),
                                  );
                                },
                                body: (e.gifts ?? []).isEmpty
                                    ? const SizedBox.shrink()
                                    : ExpansionBody(
                                        data: (e.gifts ?? []),
                                        onPressed: (p) async {
                                          context
                                              .read<ProductCheckerBloc>()
                                              .add(OnRemoveGift(
                                                  e, p.barcode ?? ""));
                                          setState(() {});
                                        },
                                      ),
                              )
                            ],
                          ),
                    widget.listItem.last == e
                        ? const SizedBox()
                        : const Divider(color: Colors.grey)
                  ],
                ));
          })
          .values
          .toList(),
    );
  }

  Widget buttonManual({
    required String title,
    required Items item,
    bool? isGift,
    required Function(Product) onBack,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: () {
        List<Product> products = [];
        if (!(isGift ?? false)) {
          if (item.manuals != null) {
            for (ReceiptDetailProduct m in (item.manuals ?? [])) {
              products.add(m.product!);
            }
          }
        } else {
          if (item.gifts != null) {
            for (ReceiptDetailProduct m in (item.gifts ?? [])) {
              products.add(m.product!);
            }
          }
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) {
            return ProductScreenSingle(
              products: products,
            );
          }),
        ).then((value) {
          if (value != null) {
            onBack(value);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ExpansionBody extends StatelessWidget {
  final List<ReceiptDetailProduct> data;
  final Function(Product)? onPressed;
  final ValueChanged<String>? onChanged;
  const ExpansionBody(
      {super.key, required this.data, this.onPressed, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((f) {
        return Slidable(
          key: ValueKey(f.product?.barcode),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                flex: 7,
                onPressed: (c) {
                  onPressed!(f.product!);
                },
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            dense: true,
            leading: const Icon(
              FontAwesomeIcons.circleDot,
              size: 15,
            ),
            title: Text(f.product?.name ?? ''),
            subtitle: Text(f.product?.barcode ?? ''),
            trailing: SizedBox(
              width: 40,
              child: TextFormField(
                controller: TextEditingController(
                  text: f.qty.toString(),
                ),
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                onChanged: onChanged,
                decoration: TextFormDecoration.box("Qty", padding: 3),
              ),
            ),
          ),
        );
      }).toList(),
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
