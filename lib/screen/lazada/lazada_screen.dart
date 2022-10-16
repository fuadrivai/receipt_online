import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/lazada_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/lazada_detail_screen.dart';
import 'package:receipt_online_shop/widget/card_order.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LazadaScreen extends StatefulWidget {
  const LazadaScreen({super.key});

  @override
  State<LazadaScreen> createState() => _LazadaScreenState();
}

class _LazadaScreenState extends State<LazadaScreen> {
  late bool visible;
  @override
  void initState() {
    context.read<LazadaBloc>().add(GetFullOrderEvent());
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<LazadaBloc>().add(GetFullOrderEvent());
        },
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
                  onBarcodeScanned: (barcode) {
                    filterTrackingNumber(
                        listOrders: (state.fullOrder.orders ?? []),
                        barcode: barcode);
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [],
                      ),
                      Expanded(
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
                    ],
                  ),
                ),
              );
            }
            return const Text('Something Wrong');
          },
        ),
      ),
    );
  }

  filterTrackingNumber(
      {required List<Order> listOrders, required String barcode}) {
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
