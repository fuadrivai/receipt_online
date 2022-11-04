import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/shopee/shopee_screen.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ShopeeWidgetScreen extends StatefulWidget {
  final Function onInit;
  final Function(String barcode) onScannBarcode;
  final bool showAction;
  final Widget body;
  final String? textTitle;
  final String appbarTitle;
  const ShopeeWidgetScreen({
    super.key,
    required this.onInit,
    required this.showAction,
    required this.onScannBarcode,
    this.textTitle,
    required this.body,
    required this.appbarTitle,
  });

  @override
  State<ShopeeWidgetScreen> createState() => _ShopeeWidgetScreenState();
}

class _ShopeeWidgetScreenState extends State<ShopeeWidgetScreen> {
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appbarTitle),
        actions: [
          widget.showAction
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (__) => const ShopeeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.next_plan),
                    ),
                    const SizedBox(),
                  ],
                )
              : const SizedBox(),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) {
                  barcodeController.text = barcodeScanner;
                  setState(() {});
                  widget.onScannBarcode(barcodeScanner);
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
          onBarcodeScanned: (String barcodeScanner) {
            barcodeController.text = barcodeScanner;
            setState(() {});
            widget.onScannBarcode(barcodeScanner);
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
                            widget.textTitle ?? "Masukan No Pesanan",
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  widget.onScannBarcode(barcodeController.text);
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
                child: widget.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
