import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/jdid/bloc/jd_id_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/shopee_list_view.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';
import 'package:visibility_detector/visibility_detector.dart';

class JdIdDetailScreen extends StatefulWidget {
  const JdIdDetailScreen({super.key});

  @override
  State<JdIdDetailScreen> createState() => _JdIdDetailScreenState();
}

class _JdIdDetailScreenState extends State<JdIdDetailScreen> {
  final currency = NumberFormat("#,##0", "en_US");
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<JdIdBloc>().add(JdIdStandBy());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JD ID Order Detail"),
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
                  context.read<JdIdBloc>().add(GetJdIdOrder(barcodeScanner));
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
            context.read<JdIdBloc>().add(GetJdIdOrder(barcode));
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
                                  context.read<JdIdBloc>().add(
                                      GetJdIdOrder(barcodeController.text));
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
                child: BlocBuilder<JdIdBloc, JdIdState>(
                  builder: (context, state) {
                    if (state is JdIdDetailLoading) {
                      return const LoadingScreen();
                    }
                    if (state is JdIdOrderDetail) {
                      return ShopeeListView(
                        orders: [state.listOrder],
                        onPressed: () async {},
                      );
                    }
                    if (state is JdIdDetailError) {
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
                    if (state is JdIdDetailStandBy) {
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
