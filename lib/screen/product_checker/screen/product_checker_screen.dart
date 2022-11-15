import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/custom_badge.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductCheckerScreen extends StatefulWidget {
  const ProductCheckerScreen({super.key});

  @override
  State<ProductCheckerScreen> createState() => _ProductCheckerScreenState();
}

class _ProductCheckerScreenState extends State<ProductCheckerScreen> {
  final currency = NumberFormat("#,##0", "en_US");
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<ProductCheckerBloc>().add(ProductCheckerStandByEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Checker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) {
                  barcodeController.text = barcodeScanner;
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
          },
          child: Column(
            children: [
              BlocBuilder<ProductCheckerBloc, ProductCheckerState>(
                builder: (context, state) {
                  if (state is ProductCheckerLoadingState) {
                    return const SizedBox();
                  }
                  if (state is ProductCheckerStandByState) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        height: 38,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.platforms?.length ?? 0,
                          itemBuilder: (__, i) {
                            Platform platform = (state.platforms ?? [])[i];
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CustomeBadge(
                                text: "${platform.name}",
                                onTap: () {},
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  if (state is ProductCheckerErrorState) {
                    return const Center(child: Text('Data Tidak Tersedia'));
                  }
                  return const Center(child: Text('Data Tidak Tersedia'));
                },
              ),
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
                                  // context.read<ShopeeDetailBloc>().add(
                                  //     GetShopeeOrder(barcodeController.text));
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
            ],
          ),
        ),
      ),
    );
  }
}
