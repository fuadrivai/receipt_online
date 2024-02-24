import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product_report/bloc/report_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/report.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_total.dart';
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
  final oCcy = NumberFormat("#,##0", "en_US");
  TextEditingController barcodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state.isError ?? false) {
          Common.modalInfo(
            context,
            title: "error",
            message: state.errorMessage,
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
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
                // Common.scanBarcodeNormal(
                //   context,
                //   onSuccess: (barcodeScanner) {
                //     barcodeController.text = barcodeScanner;
                //     Navigator.push(context, MaterialPageRoute(
                //       builder: (context) {
                //         return ProductFormScreen(
                //           barcode: barcodeScanner,
                //         );
                //       },
                //     )).then((value) {
                //       if (value != null) {
                //         context
                //             .read<ReportBloc>()
                //             .add(OnGetReportDetail(value));
                //         setState(() {});
                //       }
                //     });
                //   },
                // );
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
                        // if (_formKey.currentState!.validate()) {
                        //   Navigator.push(context, MaterialPageRoute(
                        //     builder: (context) {
                        //       return ProductFormScreen(
                        //         barcode: barcodeController.text,
                        //       );
                        //     },
                        //   )).then((value) {
                        //     if (value != null) {
                        //       context
                        //           .read<ReportBloc>()
                        //           .add(OnGetReportDetail(value));
                        //       setState(() {});
                        //     }
                        //   });
                        // }
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
                  return ListBody(report: state.report ?? Report());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListBody extends StatelessWidget {
  final Report report;
  ListBody({super.key, required this.report});

  final _oCcy = NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (report.totals ?? []).length,
      itemBuilder: (c, i) {
        ReportTotal reportTotal = (report.totals ?? [])[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reportTotal.age ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Column(
                children: (reportTotal.sizes ?? []).map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text(e.size ?? "")),
                          const Divider(),
                          Column(
                            children: (e.tastes ?? []).map((t) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(t.product?.name ?? ""),
                                          Text(
                                              "Harga : Rp. ${_oCcy.format(t.price ?? 0)}"),
                                          Text(
                                              "Satuan Karton : ${_oCcy.format(t.qtyCarton ?? 0)} pcs"),
                                          Text(
                                              "Total Karton : ${_oCcy.format(((t.qty ?? 0) / (t.qtyCarton ?? 0)).floor())}"),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text("Total Qty"),
                                          Text((_oCcy.format(t.qty ?? 0))
                                              .toString()),
                                          const Text("Total"),
                                          Text(
                                              "Rp. ${_oCcy.format((t.qty ?? 0) * (t.price ?? 0))}"),
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider()
                                ],
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Qty"),
                              Text(_oCcy.format(e.totalQty ?? 0)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Katon"),
                              Text(_oCcy.format(e.totalCarton ?? 0)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Harga"),
                              Text("Rp. ${_oCcy.format(e.totalPrice ?? 0)}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        );
      },
    );
  }
}
