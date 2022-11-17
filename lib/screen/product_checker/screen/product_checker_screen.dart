import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_body.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_platform.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_textbox.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductCheckerScreen extends StatefulWidget {
  const ProductCheckerScreen({super.key});

  @override
  State<ProductCheckerScreen> createState() => _ProductCheckerScreenState();
}

class _ProductCheckerScreenState extends State<ProductCheckerScreen> {
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  Platform? platform;

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
                  context
                      .read<ProductCheckerBloc>()
                      .add(GetOrderEvent(platform!, barcodeScanner));
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
              ListPlatform(
                getPlatform: (p0) => platform = p0,
                onTap: (p0) {
                  setState(() {
                    platform = p0;
                  });
                },
              ),
              ProductCheckerTextBox(barcodeController: barcodeController),
              const Expanded(child: ProductCheckerBody())
            ],
          ),
        ),
      ),
    );
  }
}
