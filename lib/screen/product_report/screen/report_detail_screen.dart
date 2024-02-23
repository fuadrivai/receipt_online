import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product/screen/product_screen.dart';
import 'package:receipt_online_shop/screen/product_report/bloc/report_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';
import 'package:receipt_online_shop/screen/product_report/screen/product_form.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:badges/badges.dart' as badge;

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(
          title: "Report Group",
          actions: Row(
            children: [
              IconButton(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const ProductScreen();
                    },
                  )).then((value) {
                    context.read<ReportBloc>().add(OnPushReportDetail(value));
                    setState(() {});
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: AppTheme.nearlyDarkBlue,
                  size: 30,
                ),
              ),
              IconButton(
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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProductFormScreen(
                            barcode: barcodeScanner,
                          );
                        },
                      )).then((value) {
                        if (value != null) {
                          context
                              .read<ReportBloc>()
                              .add(OnPushReportDetail(value));
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
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: (state.report?.details ?? []).isEmpty
                ? const CardData(data: "Tidak Ada Transaksi")
                : Column(
                    children: [
                      CardData(
                        title: "Total Transaksi",
                        data:
                            "RP. ${Common.oCcy.format(state.report?.amount ?? 0)}",
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: (state.report?.details ?? []).length,
                        itemBuilder: (c, i) {
                          ReportDetail detail =
                              (state.report?.details ?? [])[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    leading:
                                        Image.asset("assets/images/logo.png"),
                                    title: Text((detail.product?.name ?? "")
                                        .toUpperCase()),
                                    subtitle: Text(
                                        "Rp. ${Common.oCcy.format(detail.product?.price ?? 0)}"),
                                    trailing: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text("Total Qty"),
                                          badge.Badge(
                                            badgeStyle: badge.BadgeStyle(
                                              shape: badge.BadgeShape.square,
                                              badgeColor: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            badgeContent: Text(
                                              Common.oCcy.format(detail.qty),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 30, 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Total Karton"),
                                        Text(
                                          Common.oCcy.format(
                                              ((detail.qty ?? 0) /
                                                      (detail.qtyCarton ?? 0))
                                                  .floor()),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 25, 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Total Rupiah"),
                                        Text(
                                          "Rp. ${Common.oCcy.format((detail.qty ?? 0) * (detail.product?.price ?? 0))}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class CardData extends StatelessWidget {
  final String data;
  final String? title;
  const CardData({
    super.key,
    required this.data,
    this.title,
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
            )
          ],
        ),
      ),
    );
  }
}
