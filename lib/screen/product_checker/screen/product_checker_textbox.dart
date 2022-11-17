import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ProductCheckerTextBox extends StatelessWidget {
  final TextEditingController barcodeController;
  ProductCheckerTextBox({super.key, required this.barcodeController});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
