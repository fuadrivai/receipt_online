import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/home/screen/package_card.dart';
import 'package:receipt_online_shop/screen/product/screen/product_screen.dart';
import 'package:receipt_online_shop/screen/product_report/bloc/report_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';
import 'package:receipt_online_shop/screen/product_report/screen/card_product.dart';
import 'package:receipt_online_shop/screen/product_report/screen/product_form.dart';
import 'package:receipt_online_shop/screen/product_report/screen/report_pdf_preview.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state.isLoading ?? false) {
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
            body: const LoadingScreen(),
          );
        }
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: CustomAppbar(
              title: "Report Group",
              actions: IconButton(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const ProductScreen();
                    },
                  )).then((value) {
                    if (value != null) {
                      context.read<ReportBloc>().add(OnPushReportDetail(value));
                      setState(() {});
                    }
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: AppTheme.nearlyDarkBlue,
                  size: 30,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: (state.report?.details ?? []).isNotEmpty
              ? FloatingActionButton.extended(
                  elevation: 5,
                  backgroundColor: AppTheme.nearlyDarkBlue.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    int idx = 0;
                    for (ReportDetail e in (state.report?.details ?? [])) {
                      if (!(e.isChecked ?? false)) {
                        idx = idx + 1;
                      }
                    }
                    if (idx > 0) {
                      Common.modalInfo(
                        context,
                        title: "Error",
                        message: "Check Semua Produk !",
                        icon: const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Icon(
                            FontAwesomeIcons.circleXmark,
                            color: Colors.red,
                          ),
                        ),
                      );
                    } else {
                      DateTime idx = DateTime.now();
                      String month = Common.months[idx.month - 1];
                      int year = idx.year;
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return AlertDialog(
                            title: const Text("Masukan Periode"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  DropdownButtonFormField<String>(
                                    value: month,
                                    items: Common.months.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                            color: month == e
                                                ? AppTheme.nearlyDarkBlue
                                                : null,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (data) {
                                      month = data!;
                                      setState(() {});
                                    },
                                    decoration: TextFormDecoration.box("Bulan"),
                                  ),
                                  const SizedBox(height: 15),
                                  DropdownButtonFormField<int>(
                                    value: year,
                                    items: Common.years.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.toString(),
                                          style: TextStyle(
                                            color: year == e
                                                ? AppTheme.nearlyDarkBlue
                                                : null,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (data) {
                                      year = data!;
                                      setState(() {});
                                    },
                                    decoration: TextFormDecoration.box("Tahun"),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ButtonTask(
                                    title: "Submit",
                                    width: 100,
                                    onTap: () {
                                      String periode = "$month $year";
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return ReportPDFPreview(
                                            periode: periode,
                                          );
                                        },
                                      ));
                                    },
                                  ),
                                  const SizedBox(width: 3),
                                  ButtonTask(
                                    title: "Tutup",
                                    width: 100,
                                    color: Colors.redAccent,
                                    icon: const Icon(
                                      FontAwesomeIcons.circleXmark,
                                      color: Colors.white,
                                    ),
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  label: const Text('Generate Report'),
                  icon: const Icon(FontAwesomeIcons.paperPlane),
                )
              : const SizedBox.shrink(),
          body: SingleChildScrollView(
            child: (state.report?.details ?? []).isEmpty
                ? const CardData(data: "Tidak Ada Transaksi")
                : Column(
                    children: [
                      CardData(
                        title: "Total Transaksi",
                        data:
                            "RP. ${Common.oCcy.format(state.report?.amount ?? 0)}",
                        totalItem:
                            (state.report?.details ?? []).length.toString(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: (state.report?.details ?? []).length,
                        itemBuilder: (c, i) {
                          ReportDetail detail =
                              (state.report?.details ?? [])[i];
                          return CardProduct(
                            detail: detail,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProductFormScreen(
                                      reportDetail: detail);
                                },
                              )).then((value) {
                                if (value != null) {
                                  context
                                      .read<ReportBloc>()
                                      .add(OnMapReportDetail(value));
                                  setState(() {});
                                }
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class CardData extends StatelessWidget {
  final String data;
  final String? title;
  final String? totalItem;
  const CardData({
    super.key,
    required this.data,
    this.title,
    this.totalItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.nearlyDarkBlue.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title == null
                ? const SizedBox.shrink()
                : Text(
                    title!,
                    style: const TextStyle(
                      color: AppTheme.nearlyDarkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            Text(
              data,
              style: const TextStyle(
                color: AppTheme.nearlyDarkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            title == null
                ? const SizedBox.shrink()
                : Text(
                    "Total Item : $totalItem",
                    style: const TextStyle(
                      color: AppTheme.nearlyDarkBlue,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
