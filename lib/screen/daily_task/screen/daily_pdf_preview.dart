import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/receipt.dart';

class DailyPdfPreviewScreen extends StatefulWidget {
  final DailyTask dailyTask;
  const DailyPdfPreviewScreen({super.key, required this.dailyTask});

  @override
  State<DailyPdfPreviewScreen> createState() => _DailyPdfPreviewScreenState();
}

class _DailyPdfPreviewScreenState extends State<DailyPdfPreviewScreen> {
  List<pw.TableRow> tableRow = [];
  List<String> tableHeader = ["NO", "RESI", "Waktu Scann"];

  @override
  void initState() {
    _appenTableRow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Document'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => _generatePdf(format, "Data Title", context),
        canDebug: false,
        canChangeOrientation: false,
        allowSharing: false,
        canChangePageFormat: false,
        pdfFileName: DateTime.now().millisecond.toString(),
        // actions: actions,
        // onPrinted: _showPrintedToast,
        // onShared: _showSharedToast,
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, BuildContext cc) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      // compress: true,
      // pageMode: PdfPageMode.outlines,
    );
    final image = await imageFromAssetBundle('assets/images/logo.png');

    pdf.addPage(pw.MultiPage(
      pageFormat: format.copyWith(
        marginBottom: 1.5 * PdfPageFormat.cm,
        marginLeft: 35,
        marginRight: 35,
        marginTop: 35,
      ),
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.Theme.of(context).defaultTextStyle.copyWith(
                  color: PdfColors.grey,
                ),
          ),
        );
      },
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Row(
            children: [
              pw.Container(
                width: 50,
                height: 50,
                child: pw.Image(image),
              ),
              pw.SizedBox(width: 13),
              pw.Expanded(
                child: pw.Text(
                  'Lampiran Resi SSMART10',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              width: MediaQuery.of(cc).size.width / 2,
              child: pw.Row(
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Expedisi',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      pw.Text(
                        'Total Paket',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(width: 15),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        ':',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      pw.Text(
                        ':',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(width: 11),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        widget.dailyTask.expedition!.name!,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      pw.Text(
                        (widget.dailyTask.receipts ?? []).length.toString(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Container(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Tanggal',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 11),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          ':',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(width: 11),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          Jiffy.parse(widget.dailyTask.date!)
                              .format(pattern: 'dd MMMM yyyy'),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 13),
        pw.Text(
          'Detail',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(children: tableRow),
      ],
    ));
    return pdf.save();
  }

  _appenTableRow() {
    tableRow.add(
      pw.TableRow(
        children: tableHeader
            .map((e) =>
                pw.Text(e, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))
            .toList(),
      ),
    );
    for (int i = 0; i < (widget.dailyTask.receipts ?? []).length; i++) {
      List<String> tableData = [];
      Receipt receipt = (widget.dailyTask.receipts ?? [])[i];
      tableData.add(
        "${i + 1}",
      );
      tableData.add(
        receipt.number ?? "",
      );
      tableData.add(
        Jiffy.parseFromDateTime(
                DateTime.parse(receipt.createdAt ?? "").toLocal())
            .format(pattern: "d MMM yyyy HH:mm:ss"),
      );
      tableRow.add(
        pw.TableRow(
          children: tableData
              .map((e) => pw.Text(e, style: const pw.TextStyle(fontSize: 10)))
              .toList(),
        ),
      );
    }
  }
}
