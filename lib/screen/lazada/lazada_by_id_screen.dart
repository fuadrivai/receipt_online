import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/by_id_bloc.dart';
import 'package:receipt_online_shop/widget/card_order.dart';
import 'package:receipt_online_shop/widget/default_color.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LazadaByIdScreen extends StatefulWidget {
  const LazadaByIdScreen({super.key});

  @override
  State<LazadaByIdScreen> createState() => _LazadaByIdScreenState();
}

class _LazadaByIdScreenState extends State<LazadaByIdScreen> {
  final currency = NumberFormat("#,##0", "en_US");
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<ByIdBloc>().add(LazadaStandBy());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazada Order Detail"),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (__) => const ShopeeScreen()));
          //   },
          //   icon: const Icon(Icons.next_plan),
          // ),
          // const SizedBox(),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) {
                  barcodeController.text = barcodeScanner;
                  setState(() {});
                  context.read<ByIdBloc>().add(GetOrderById(barcodeScanner));
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
            context.read<ByIdBloc>().add(GetOrderById(barcode));
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
                                  context.read<ByIdBloc>().add(
                                      GetOrderById(barcodeController.text));
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
                child: BlocBuilder<ByIdBloc, ByIdState>(
                  builder: (context, state) {
                    if (state is ByIdDetailLoading) {
                      return const LoadingScreen();
                    }
                    if (state is ByIdOrderDetail) {
                      return ListView(
                        children: [
                          CardOrder(order: state.listOrder),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 15,
                            ),
                            child: Visibility(
                              visible: state.listOrder.orderStatus != 'packed'
                                  ? false
                                  : true,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 45,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: DefaultColor.primary,
                                      ),
                                      onPressed: () {
                                        context.read<ByIdBloc>().add(
                                            LazadaRtsEvent(state.listOrder));
                                      },
                                      child: const Text(
                                        "Siap Kirim",
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 45,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Buat Paket",
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    if (state is ByIdDetailError) {
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
                    if (state is ByIdDetailStandBy) {
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
