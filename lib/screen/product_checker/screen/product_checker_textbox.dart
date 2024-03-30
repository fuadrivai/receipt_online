import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ProductCheckerTextBox extends StatelessWidget {
  final TextEditingController barcodeController;
  final VoidCallback? onPressed;
  final String? title;
  ProductCheckerTextBox(
      {super.key, required this.barcodeController, this.title, this.onPressed});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCheckerBloc, ProductCheckerState>(
        builder: (context, state) {
      bool disable = (state.isLoading ?? false) ? false : true;
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: TextFormField(
            enabled: disable,
            readOnly: !disable,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: barcodeController,
            decoration: TextFormDecoration.box(
              title ?? "Masukan No Pesanan",
              suffixIcon: IconButton(
                onPressed: onPressed ??
                    () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProductCheckerBloc>().add(GetOrderEvent(
                            state.platform!, barcodeController.text));
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
      );
    });
  }
}
