import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product_report/bloc/report_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/report.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_total.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';

class ReportPDFPreview extends StatefulWidget {
  final String periode;
  const ReportPDFPreview({super.key, required this.periode});

  @override
  State<ReportPDFPreview> createState() => _ReportPDFPreviewState();
}

class _ReportPDFPreviewState extends State<ReportPDFPreview> {
  List<String> tableHeader = ["NO", "PRODUK", "QTY", "KARTON", "RUPIAH"];
  List tableHeader2 = [
    "NO",
    "TAHAP",
    "KEMASAN",
    "MADU",
    "VANILA",
    "KARTON",
    "RUPIAH"
  ];
  List<pw.Widget> columnBody = [];
  @override
  void initState() {
    context.read<ReportBloc>().add(OnMapReport(widget.periode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
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
              actions: IconButton(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.print,
                  color: AppTheme.nearlyDarkBlue,
                ),
                onPressed: () async {
                  await Printing.layoutPdf(
                    onLayout: (format) {
                      return _generatePdf(
                        format: format,
                        data: state.report ?? Report(),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          body: PdfPreview(
            maxPageWidth: 700,
            build: (format) => _generatePdf(
              format: format,
              data: state.report ?? Report(),
            ),
            canDebug: false,
            canChangeOrientation: false,
            allowSharing: true,
            canChangePageFormat: false,
            useActions: false,
            loadingWidget: const LoadingScreen(),
            pdfFileName:
                "product_report_${DateTime.now().millisecondsSinceEpoch}",
          ),
        );
      },
    );
  }

  Future<Uint8List> _generatePdf(
      {required PdfPageFormat format, required Report data}) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      pageMode: PdfPageMode.outlines,
    );
    final font1 = await PdfGoogleFonts.tinosRegular();
    final font2 = await PdfGoogleFonts.tinosBold();
    final image = await imageFromAssetBundle('assets/images/logo.png');
    List<ReportTotal> totals =
        (data.totals ?? []).where((e) => e.age != null).toList();
    List<ReportTotal> emptyTotals =
        (data.totals ?? []).where((e) => e.age == null).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: format.copyWith(
        marginBottom: 1.5 * PdfPageFormat.cm,
        marginLeft: 35,
        marginRight: 35,
        marginTop: 35,
      ),
      theme: pw.ThemeData.withFont(
        base: font1,
        bold: font2,
      ),
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                width: 1,
                color: PdfColors.indigo,
              ),
            ),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                width: 50,
                height: 50,
                child: pw.Image(image),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Report Product',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    pw.Text(
                      "Periode : ${data.periode}",
                      style: const pw.TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      build: (context) {
        return [
          //Table Detail
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            cellPadding: const pw.EdgeInsets.all(3),
            oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            headers: List<pw.Widget>.generate(
              tableHeader.length,
              (col) {
                return pw.Text(
                  tableHeader[col],
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                );
              },
            ),
            data: List<List<String>>.generate(
              (data.details ?? []).length,
              (row) => List<String>.generate(
                tableHeader.length,
                (col) => (data.details ?? [])[row].getIndex(row, col),
              ),
            ),
            cellAlignments: {
              0: pw.Alignment.centerRight,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
            },
          ),

          //Table Rekap
          pw.SizedBox(height: 20),
          totals.isNotEmpty
              ? pw.TableHelper.fromTextArray(
                  cellPadding: const pw.EdgeInsets.all(3),
                  oddRowDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey100),
                  headers: List<pw.Widget>.generate(
                    tableHeader2.length,
                    (col) {
                      return pw.Text(
                        tableHeader2[col],
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  data: List<List<pw.Widget>>.generate(
                    totals.length,
                    (row) => List<pw.Widget>.generate(
                      tableHeader2.length,
                      (col) => totals[row].getIndex2(row, col),
                    ),
                  ),
                  cellAlignments: {
                    0: pw.Alignment.centerRight,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                    5: pw.Alignment.center,
                    6: pw.Alignment.centerRight,
                  },
                )
              : pw.SizedBox.shrink(),
          emptyTotals.isNotEmpty
              ? pw.TableHelper.fromTextArray(
                  cellPadding: const pw.EdgeInsets.all(3),
                  oddRowDecoration:
                      const pw.BoxDecoration(color: PdfColors.grey100),
                  data: List<List<pw.Widget>>.generate(
                    emptyTotals.length,
                    (row) => List<pw.Widget>.generate(
                      5,
                      (col) => emptyTotals[row]
                          .getEmptyIndex(row, col, totals.length),
                    ),
                  ),
                  columnWidths: {
                    0: const pw.FractionColumnWidth(11),
                    1: const pw.FractionColumnWidth(53),
                    2: const pw.FractionColumnWidth(44),
                    3: const pw.FractionColumnWidth(27),
                    4: const pw.FractionColumnWidth(27),
                  },
                  cellAlignments: {
                    0: pw.Alignment.centerRight,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.centerRight,
                  },
                )
              : pw.SizedBox.shrink(),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "Total :",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "Rp. ${Common.oCcy.format(data.amount ?? 0)}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.Spacer(),
          pw.Text("Administrator"),
          pw.SizedBox(height: 100),
          pw.Text("(............................)")
        ];
      },
    ));
    return pdf.save();
  }

  pw.Widget container(String data, {double? width, double? height}) {
    return pw.Container(
      width: width,
      height: height ?? 30,
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      child: pw.Center(child: pw.Text(data)),
    );
  }

  pw.Widget rowHeader(String title, String data) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2.0 * PdfPageFormat.mm),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.SizedBox(width: 100, child: pw.Text(title)),
          pw.SizedBox(width: 20, child: pw.Text(":")),
          pw.Expanded(
            child: pw.Text(
              data,
              textAlign: pw.TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
