import 'package:flutter/material.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/shopee/shopee_order.dart';
import 'package:receipt_online_shop/screen/shopee/data/shopee_api.dart';

class ShopeeScreen extends StatefulWidget {
  const ShopeeScreen({super.key});

  @override
  State<ShopeeScreen> createState() => _ShopeeScreenState();
}

class _ShopeeScreenState extends State<ShopeeScreen> {
  List<ShopeeOrder> orders = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopee Order Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) async {
                  orders = await ShopeeApi.getShopeeOrderByNo(barcodeScanner);
                  setState(() {});
                },
              );
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, i) {
            ShopeeOrder order = orders[i];
            return ListTile(
              title: Text(order.trackingNumber ?? ""),
            );
          }),
    );
  }
}
