import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/seesion_manager.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/lazada_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/lazada_detail_screen.dart';
import 'package:receipt_online_shop/widget/card_order.dart';
import 'package:receipt_online_shop/widget/custom_badge.dart';
import 'package:receipt_online_shop/widget/default_color.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LazadaScreen extends StatefulWidget {
  const LazadaScreen({super.key});

  @override
  State<LazadaScreen> createState() => _LazadaScreenState();
}

class _LazadaScreenState extends State<LazadaScreen> {
  late bool visible;
  String dataValue = "";
  int selectedTab = 1;
  String sortingValue = "DESC";
  int allTotal = 0;
  @override
  void initState() {
    Session.get("sorting").then((value) {
      sortingValue = value!;
      context
          .read<LazadaBloc>()
          .add(GetOrders(selectedTab, sortingValue, "packed"));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LazadaBloc, LazadaState>(
          builder: (context, state) {
            if (state is LazadaFullOrderState) {
              allTotal = state.fullOrder.allTotal!;
              return Text("Lazada (${state.fullOrder.allTotal}) Order");
            }
            return Text("Lazada ($allTotal) Order");
          },
        ),
        actions: [
          BlocBuilder<LazadaBloc, LazadaState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.qr_code_scanner_outlined),
                onPressed: () {
                  if (state is LazadaFullOrderState) {
                    Common.scanBarcodeNormal(context,
                        onSuccess: (barcodeScanner) {
                      filterTrackingNumber(
                        listOrders: (state.fullOrder.orders ?? []),
                        barcode: barcodeScanner,
                      );
                    });
                  }
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          TopTabar(tapCallback: (int selected) {
            selectedTab = selected;
            setState(() {});
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: DropdownButtonFormField(
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem<String>(
                      value: "DESC",
                      child: Text(
                        "Pesanan Terbaru",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "ASC",
                      child: Text(
                        "Pesanan Terlama",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  value: sortingValue,
                  onChanged: (String? value) {
                    context
                        .read<LazadaBloc>()
                        .add(OnChangeSortingEvent(value!, selectedTab));
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<LazadaBloc, LazadaState>(
              builder: (context, state) {
                if (state is LazadaLoadingState) {
                  return const LoadingScreen();
                }
                if (state is LazadaFullOrderState) {
                  return VisibilityDetector(
                    key: const Key('visible-detector-key'),
                    onVisibilityChanged: (VisibilityInfo info) {
                      visible = info.visibleFraction > 0;
                    },
                    child: BarcodeKeyboardListener(
                      onBarcodeScanned: (String barcode) {
                        filterTrackingNumber(
                          listOrders: (state.fullOrder.orders ?? []),
                          barcode: barcode.toUpperCase(),
                        );
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<LazadaBloc>()
                              .add(OnRefresh(selectedTab));
                        },
                        child: ListView.builder(
                          itemBuilder: (__, i) {
                            Order order = (state.fullOrder.orders ?? [])[i];
                            return CardOrder(
                              order: order,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (__) => LazadaDetailOrderScreen(
                                      order: order,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: state.fullOrder.orders?.length ?? 0,
                        ),
                      ),
                    ),
                  );
                }
                return const Text('Something Wrong');
              },
            ),
          ),
        ],
      ),
    );
  }

  filterTrackingNumber({
    required List<Order> listOrders,
    required String barcode,
  }) {
    List<Order> orders =
        listOrders.where((e) => e.trackingNumber == barcode).toList();
    if (orders.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (__) => LazadaDetailOrderScreen(
            order: orders[0],
          ),
        ),
      );
    } else {
      Common.modalInfo(context,
          title: "Error", message: "Nomor resi $barcode Tidak Valid");
    }
  }
}

class TopTabar extends StatefulWidget {
  final Function(int selected)? tapCallback;
  const TopTabar({super.key, this.tapCallback});

  @override
  State<TopTabar> createState() => _TopTabarState();
}

class _TopTabarState extends State<TopTabar> {
  int selectedTab = 0;
  int toPack = 0, pending = 0, readyToShip = 0;
  @override
  void initState() {
    selectedTab = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocBuilder<LazadaBloc, LazadaState>(
            builder: (context, state) {
              if (state is LazadaFullOrderState) {
                pending = state.fullOrder.totalPending!;
                return CustomeBadge(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  backgroundColor:
                      selectedTab == 0 ? DefaultColor.primary : null,
                  text: 'Baru (${state.fullOrder.totalPending.toString()})',
                  onTap: () {
                    if (selectedTab != 0) {
                      selectedTab = 0;
                      widget.tapCallback!(selectedTab);
                      context.read<LazadaBloc>().add(GetPending());
                      setState(() {});
                    }
                  },
                );
              }
              return CustomeBadge(
                width: MediaQuery.of(context).size.width * 30 / 100,
                backgroundColor: selectedTab == 0 ? DefaultColor.primary : null,
                text: 'Baru ($pending)',
                onTap: () {
                  if (selectedTab != 0) {
                    selectedTab = 0;
                    widget.tapCallback!(selectedTab);
                    context.read<LazadaBloc>().add(GetPending());
                    setState(() {});
                  }
                },
              );
            },
          ),
          BlocBuilder<LazadaBloc, LazadaState>(
            builder: (context, state) {
              if (state is LazadaFullOrderState) {
                toPack = state.fullOrder.totalPacked!;
                return CustomeBadge(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  backgroundColor:
                      selectedTab == 1 ? DefaultColor.primary : null,
                  text: 'Dikemas (${state.fullOrder.totalPacked.toString()})',
                  onTap: () {
                    if (selectedTab != 1) {
                      selectedTab = 1;
                      widget.tapCallback!(selectedTab);
                      context.read<LazadaBloc>().add(GetPacked());
                      setState(() {});
                    }
                  },
                );
              }
              return CustomeBadge(
                width: MediaQuery.of(context).size.width * 30 / 100,
                backgroundColor: selectedTab == 1 ? DefaultColor.primary : null,
                text: 'Dikemas ($toPack)',
                onTap: () {
                  if (selectedTab != 1) {
                    selectedTab = 1;
                    widget.tapCallback!(selectedTab);
                    context.read<LazadaBloc>().add(GetPacked());
                    setState(() {});
                  }
                },
              );
            },
          ),
          BlocBuilder<LazadaBloc, LazadaState>(
            builder: (context, state) {
              if (state is LazadaFullOrderState) {
                readyToShip = state.fullOrder.totalRts!;
                return CustomeBadge(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  backgroundColor:
                      selectedTab == 2 ? DefaultColor.primary : null,
                  text: 'Siap Kirim (${state.fullOrder.totalRts.toString()})',
                  onTap: () {
                    if (selectedTab != 2) {
                      selectedTab = 2;
                      widget.tapCallback!(selectedTab);
                      context.read<LazadaBloc>().add(GetRts());
                      setState(() {});
                    }
                  },
                );
              }
              return CustomeBadge(
                width: MediaQuery.of(context).size.width * 30 / 100,
                backgroundColor: selectedTab == 2 ? DefaultColor.primary : null,
                text: 'Siap Kirim ($readyToShip)',
                onTap: () {
                  if (selectedTab != 2) {
                    selectedTab = 2;
                    widget.tapCallback!(selectedTab);
                    context.read<LazadaBloc>().add(GetRts());
                    setState(() {});
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
