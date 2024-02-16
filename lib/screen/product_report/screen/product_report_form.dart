import 'package:flutter/material.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_textbox.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';

class ProductReportForm extends StatefulWidget {
  const ProductReportForm({super.key, this.animationController});
  final AnimationController? animationController;

  @override
  State<ProductReportForm> createState() => _ProductReportFormState();
}

class _ProductReportFormState extends State<ProductReportForm> {
  TextEditingController barcodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(
          title: "Report Group",
          animationController: widget.animationController,
          actions: IconButton(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              color: AppTheme.nearlyDarkBlue,
            ),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) {
                  barcodeController.text = barcodeScanner;
                  // context
                  //     .read<ProductCheckerBloc>()
                  //     .add(GetOrderEvent(platform!, barcodeScanner));
                },
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductCheckerTextBox(
              title: "Masukan Kode Barang",
              barcodeController: barcodeController,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
