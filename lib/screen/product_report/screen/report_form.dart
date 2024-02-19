import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product_report/bloc/report_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/screen/product_form.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ProductReportForm extends StatefulWidget {
  const ProductReportForm({super.key});

  @override
  State<ProductReportForm> createState() => _ProductReportFormState();
}

class _ProductReportFormState extends State<ProductReportForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController barcodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(
          title: "Report Group",
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProductFormScreen(
                        barcode: barcodeScanner,
                      );
                    },
                  )).then((value) {
                    if (value != null) {
                      context.read<ReportBloc>().add(OnGetReportDetail(value));
                      setState(() {});
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: TextFormField(
                // enabled: disable,
                // readOnly: !disable,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: barcodeController,
                decoration: TextFormDecoration.box(
                  "Masukan Kode Barang",
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProductFormScreen(
                              barcode: barcodeController.text,
                            );
                          },
                        )).then((value) {
                          if (value != null) {
                            context
                                .read<ReportBloc>()
                                .add(OnGetReportDetail(value));
                            setState(() {});
                          }
                        });
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
          Expanded(
            child: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: (state.details ?? []).length,
                  itemBuilder: (context, index) {
                    return const Text("ok");
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
