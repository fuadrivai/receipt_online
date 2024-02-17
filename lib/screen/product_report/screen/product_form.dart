import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/home/screen/package_card.dart';
import 'package:receipt_online_shop/screen/product_report/bloc/product_form_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/product.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ProductFormScreen extends StatefulWidget {
  final String barcode;
  const ProductFormScreen({super.key, required this.barcode});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  String? taste, age, size;
  @override
  void initState() {
    context.read<ProductFormBloc>().add(OnGetProduct(widget.barcode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(
          title: "Report Group",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: BlocBuilder<ProductFormBloc, ProductFormState>(
        builder: (context, state) {
          if ((state.isLoading ?? true)) {
            return const LoadingScreen();
          } else {
            Product product = state.detail?.product ?? Product();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(9, 9, 9, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.shopping_cart_checkout_rounded,
                          color: Colors.blue,
                          size: 40,
                        ),
                        title: Text(
                          product.name ?? "--",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                'Barcode : ${product.barcode ?? "Barcode : --"}'),
                            Text("Harga Satuan : Rp. ${product.price ?? '0'}"),
                          ],
                        ),
                      ),
                      const Divider(height: 2),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        items: const [
                          DropdownMenuItem(value: "1+", child: Text("1+")),
                          DropdownMenuItem(value: "3+", child: Text("3+")),
                        ],
                        onChanged: (data) {
                          age = data;
                        },
                        decoration: TextFormDecoration.box("Usia"),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        items: const [
                          DropdownMenuItem(value: "madu", child: Text("Madu")),
                          DropdownMenuItem(
                              value: "vanila", child: Text("Vanila")),
                        ],
                        onChanged: (data) {
                          taste = data;
                        },
                        decoration: TextFormDecoration.box("Rasa"),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        items: const [
                          DropdownMenuItem(
                              value: "300gr", child: Text("300gr")),
                          DropdownMenuItem(
                              value: "700gr", child: Text("700gr")),
                          DropdownMenuItem(value: "1 KG", child: Text("1 KG")),
                        ],
                        onChanged: (data) {
                          size = data;
                        },
                        decoration: TextFormDecoration.box("Kemasan"),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(decoration: TextFormDecoration.box("Qty")),
                      const SizedBox(height: 20),
                      ButtonTask(
                        title: "Simpan",
                        width: 100,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
