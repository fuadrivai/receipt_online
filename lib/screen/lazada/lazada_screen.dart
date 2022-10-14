import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';

class LazadaScreen extends StatefulWidget {
  const LazadaScreen({super.key});

  @override
  State<LazadaScreen> createState() => _LazadaScreenState();
}

class _LazadaScreenState extends State<LazadaScreen> {
  bool isLoading = false;
  List dataOrder = [];
  @override
  void initState() {
    isLoading = true;
    LazadaApi.getOrders().then((value) {
      print(value);
      dataOrder = value['data']['orders'];
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      print(e);
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otorisasi Lazada"),
      ),
      body: isLoading
          ? const LoadingScreen()
          : ListView.builder(
              itemBuilder: (__, i) {
                return const Text('ok');
              },
              itemCount: dataOrder.length),
    );
  }
}
