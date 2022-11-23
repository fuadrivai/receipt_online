import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/shopee/bloc/shopee_bloc.dart';
import 'package:receipt_online_shop/screen/shopee/shopee_screen.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/shopee_list_view.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ShopeeDetailScreen extends StatefulWidget {
  const ShopeeDetailScreen({super.key});

  @override
  State<ShopeeDetailScreen> createState() => _ShopeeDetailScreenState();
}

class _ShopeeDetailScreenState extends State<ShopeeDetailScreen> {
  final currency = NumberFormat("#,##0", "en_US");
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<ShopeeDetailBloc>().add(ShopeeStandBy());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopee Order Detail"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (__) => const ShopeeScreen()));
            },
            icon: const Icon(Icons.next_plan),
          ),
          const SizedBox(),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) {
                  barcodeController.text = barcodeScanner;
                  setState(() {});
                  context
                      .read<ShopeeDetailBloc>()
                      .add(GetShopeeOrder(barcodeScanner));
                },
              );
            },
          )
        ],
      ),
      body: VisibilityDetector(
        key: const Key('visible-detector-key'),
        onVisibilityChanged: (VisibilityInfo info) {
          visible = info.visibleFraction > 0;
        },
        child: BarcodeKeyboardListener(
          onBarcodeScanned: (String barcode) {
            barcodeController.text = barcode;
            setState(() {});
            context.read<ShopeeDetailBloc>().add(GetShopeeOrder(barcode));
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: barcodeController,
                          decoration: TextFormDecoration.box(
                            "Masukan No Pesanan",
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ShopeeDetailBloc>().add(
                                      GetShopeeOrder(barcodeController.text));
                                }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.searchengin,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<ShopeeDetailBloc, ShopeeDetailState>(
                  builder: (context, state) {
                    if (state is ShopeeDetailLoading) {
                      return const LoadingScreen();
                    }
                    if (state is ShopeeOrderDetail) {
                      return ShopeeListView(
                        orders: state.listOrder,
                        onPressed: (order) async {
                          if (await confirm(
                            context,
                            content: const Text('Yakin Ingin Memanggil Kurir'),
                            textOK: const Text('Panggil'),
                            textCancel: const Text('Kembali'),
                          )) {
                            context
                                .read<ShopeeDetailBloc>()
                                .add(ShopeeRtsEvent(order.orderNo!));
                          }
                        },
                      );
                    }
                    if (state is ShopeeDetailError) {
                      return Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: const BoxConstraints(
                              minHeight: 300, maxHeight: 300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                FontAwesomeIcons.circleXmark,
                                color: Colors.red,
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.message,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 248, 30, 15),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is ShopeeDetailStandBy) {
                      return Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: const BoxConstraints(
                              minHeight: 300, maxHeight: 300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                FontAwesomeIcons.barcode,
                                color: Colors.blueAccent,
                                size: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Silahkan Scan Barcode Pesanan",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 63, 43, 245),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const Text('error');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
