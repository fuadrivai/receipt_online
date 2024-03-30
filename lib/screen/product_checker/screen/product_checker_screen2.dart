import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/string_uppercase.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_body.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_platform.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_textbox.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/camera_preview_screen.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductCheckerScreen2 extends StatefulWidget {
  const ProductCheckerScreen2({super.key});

  @override
  State<ProductCheckerScreen2> createState() => _ProductCheckerScreen2State();
}

class _ProductCheckerScreen2State extends State<ProductCheckerScreen2>
    with TickerProviderStateMixin {
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  Platform? platform;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(
          title: "Product Checker",
          actions: IconButton(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              color: AppTheme.nearlyDarkBlue,
            ),
            onPressed: () {
              if (platform?.name?.toLowerCase() == "tiktok") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CameraPreviewScreen()),
                ).then((value) {
                  RecognizedText text = value;
                  String textBlock = "";
                  bool isExist = false;
                  for (TextBlock e in text.blocks) {
                    if (e.text.toLowerCase().contains("tt")) {
                      textBlock = e.text;
                      isExist = true;
                      setState(() {});
                      break;
                    } else {
                      isExist = false;
                      setState(() {});
                    }
                  }
                  if (isExist) {
                    List<String> str = textBlock.split(":");
                    String number = str.last.replaceAll(RegExp(r"\s+"), "");
                    barcodeController.text = number;
                    context
                        .read<ProductCheckerBloc>()
                        .add(GetOrderEvent(platform!, number));
                  }
                });
              } else {
                Common.scanBarcodeNormal(
                  context,
                  onSuccess: (barcodeScanner) {
                    barcodeController.text = barcodeScanner;
                    context
                        .read<ProductCheckerBloc>()
                        .add(GetOrderEvent(platform!, barcodeScanner));
                  },
                );
              }
            },
          ),
        ),
      ),
      body: VisibilityDetector(
        key: const Key('visible-detector-key'),
        onVisibilityChanged: (VisibilityInfo info) {
          visible = info.visibleFraction > 0;
        },
        child: BarcodeKeyboardListener(
          onBarcodeScanned: (String barcode) {
            List<String> listBarcode = [];
            for (var rune in barcode.runes) {
              var character = String.fromCharCode(rune);
              listBarcode.add(character.upperCase());
            }
            barcodeController.text = listBarcode.join();
            context
                .read<ProductCheckerBloc>()
                .add(GetOrderEvent(platform!, listBarcode.join()));
          },
          child: Column(
            children: [
              const ListPlatform(),
              ProductCheckerTextBox(
                barcodeController: barcodeController,
              ),
              const Expanded(child: ProductCheckerBody())
            ],
          ),
        ),
      ),
    );
  }
}
