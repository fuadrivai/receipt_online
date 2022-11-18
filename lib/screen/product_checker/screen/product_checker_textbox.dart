import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ProductCheckerTextBox extends StatelessWidget {
  final TextEditingController barcodeController;
  ProductCheckerTextBox({super.key, required this.barcodeController});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCheckerBloc, ProductCheckerState>(
        builder: (context, state) {
      bool disable = (state is ProductCheckerLoadingState) ? false : true;
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
              "Masukan No Pesanan",
              suffixIcon: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (state is ProductCheckerDataState) {
                      context.read<ProductCheckerBloc>().add(GetOrderEvent(
                          state.platform!, barcodeController.text));
                    }
                    if (state is ProductCheckerStandByState) {
                      context.read<ProductCheckerBloc>().add(GetOrderEvent(
                          state.platform!, barcodeController.text));
                    }
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
