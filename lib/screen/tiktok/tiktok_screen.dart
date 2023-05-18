import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/lazada/lazada_detail_screen.dart';
import 'package:receipt_online_shop/screen/tiktok/bloc/tiktok_bloc.dart';
import 'package:receipt_online_shop/widget/card_order.dart';
import 'package:receipt_online_shop/widget/custom_badge.dart';
import 'package:receipt_online_shop/widget/default_color.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TiktokScreen extends StatefulWidget {
  const TiktokScreen({super.key});

  @override
  State<TiktokScreen> createState() => _TiktokScreenState();
}

class _TiktokScreenState extends State<TiktokScreen> {
  late bool visible;
  int allTotal = 0;
  int selectedTab = 0;
  @override
  void initState() {
    context.read<TiktokBloc>().add(const GetOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TiktokBloc, TiktokState>(
          builder: (context, state) {
            if (state is TiktokFullOrderState) {
              allTotal = state.transactions.length;
              return Text("Tiktok ($allTotal) Order");
            }
            return Text("Tiktok ($allTotal) Order");
          },
        ),
        actions: [
          BlocBuilder<TiktokBloc, TiktokState>(
            builder: (context, state) {
              return Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner_outlined),
                    onPressed: () {
                      if (state is TiktokFullOrderState) {
                        Common.scanBarcodeNormal(context,
                            onSuccess: (barcodeScanner) {
                          filterTrackingNumber(
                            listOrders: state.transactions,
                            barcode: barcodeScanner,
                          );
                        });
                      }
                    },
                  )
                ],
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
          Expanded(
            child: BlocBuilder<TiktokBloc, TiktokState>(
              builder: (context, state) {
                if (state is TiktokLoadingState) {
                  return const LoadingScreen();
                }
                if (state is TiktokFullOrderState) {
                  return VisibilityDetector(
                    key: const Key('visible-detector-key'),
                    onVisibilityChanged: (VisibilityInfo info) {
                      visible = info.visibleFraction > 0;
                    },
                    child: BarcodeKeyboardListener(
                      onBarcodeScanned: (String barcode) {
                        filterTrackingNumber(
                          listOrders: state.transactions,
                          barcode: barcode.toUpperCase(),
                        );
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<TiktokBloc>().add(const GetOrders());
                        },
                        child: ListView.builder(
                          itemBuilder: (__, i) {
                            TransactionOnline order = state.tempTransactions[i];
                            return CardOrder(
                              showStatus: true,
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
                          itemCount: state.tempTransactions.length,
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
    required List<TransactionOnline> listOrders,
    required String barcode,
  }) {
    List<TransactionOnline> orders =
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
  int allTotal = 0, allScanned = 0, allUnScanned = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: BlocBuilder<TiktokBloc, TiktokState>(builder: (context, state) {
          if (state is TiktokFullOrderState) {
            allTotal = state.transactions.length;
            allScanned = state.transactions
                .where((e) => e.scanned == true)
                .toList()
                .length;
            allUnScanned = state.transactions
                .where((e) => e.scanned == false)
                .toList()
                .length;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomeBadge(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  backgroundColor:
                      selectedTab == 0 ? DefaultColor.primary : null,
                  text: 'Semua ($allTotal)',
                  onTap: () {
                    if (selectedTab != 0) {
                      selectedTab = 0;
                      widget.tapCallback!(selectedTab);
                      context.read<TiktokBloc>().add(const OnTapScanned());
                      setState(() {});
                    }
                  },
                ),
                CustomeBadge(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  backgroundColor:
                      selectedTab == 1 ? DefaultColor.primary : null,
                  text: 'Sudah Scan ($allScanned)',
                  onTap: () {
                    if (selectedTab != 1) {
                      selectedTab = 1;
                      widget.tapCallback!(selectedTab);
                      context
                          .read<TiktokBloc>()
                          .add(const OnTapScanned(scanned: true));
                      setState(() {});
                    }
                  },
                ),
                CustomeBadge(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  backgroundColor:
                      selectedTab == 2 ? DefaultColor.primary : null,
                  text: 'Belum Scan ($allUnScanned)',
                  onTap: () {
                    if (selectedTab != 2) {
                      selectedTab = 2;
                      widget.tapCallback!(selectedTab);
                      context
                          .read<TiktokBloc>()
                          .add(const OnTapScanned(scanned: false));
                      setState(() {});
                    }
                  },
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomeBadge(
                width: MediaQuery.of(context).size.width * 30 / 100,
                backgroundColor: selectedTab == 0 ? DefaultColor.primary : null,
                text: 'Semua ($allTotal)',
                onTap: () {
                  if (selectedTab != 0) {
                    selectedTab = 0;
                    widget.tapCallback!(selectedTab);
                    context.read<TiktokBloc>().add(const OnTapScanned());
                    setState(() {});
                  }
                },
              ),
              CustomeBadge(
                width: MediaQuery.of(context).size.width * 30 / 100,
                backgroundColor: selectedTab == 1 ? DefaultColor.primary : null,
                text: 'Sudah Scan ($allScanned)',
                onTap: () {
                  if (selectedTab != 1) {
                    selectedTab = 1;
                    widget.tapCallback!(selectedTab);
                    context
                        .read<TiktokBloc>()
                        .add(const OnTapScanned(scanned: true));
                    setState(() {});
                  }
                },
              ),
              CustomeBadge(
                width: MediaQuery.of(context).size.width * 30 / 100,
                backgroundColor: selectedTab == 2 ? DefaultColor.primary : null,
                text: 'Belum Scan ($allUnScanned)',
                onTap: () {
                  if (selectedTab != 2) {
                    selectedTab = 2;
                    widget.tapCallback!(selectedTab);
                    context
                        .read<TiktokBloc>()
                        .add(const OnTapScanned(scanned: false));
                    setState(() {});
                  }
                },
              ),
            ],
          );
        }));
  }
}
