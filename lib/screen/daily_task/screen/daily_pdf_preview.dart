import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:receipt_online_shop/model/daily_task.dart';

class DailyPdfPreviewScreen extends StatefulWidget {
  final DailyTask dailyTask;
  const DailyPdfPreviewScreen({super.key, required this.dailyTask});

  @override
  State<DailyPdfPreviewScreen> createState() => _DailyPdfPreviewScreenState();
}

class _DailyPdfPreviewScreenState extends State<DailyPdfPreviewScreen> {
  List<pw.TableRow> tableRow = [];
  List<String> tableHeader = ["NO", "RESI", "JAM"];

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
        pdfFileName: DateTime.now().millisecond.toString(),
        // actions: actions,
        // onPrinted: _showPrintedToast,
        // onShared: _showSharedToast,
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, BuildContext cc) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final image = await imageFromAssetBundle('assets/images/logo.png');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 50,
                    height: 50,
                    child: pw.Image(image),
                  ),
                  pw.SizedBox(width: 15),
                  pw.Expanded(
                    child: pw.Text(
                      'Lampiran Resi SSMART 10',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(height: 4),
              pw.SizedBox(height: 15),
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
                                fontSize: 15,
                              ),
                            ),
                            pw.Text(
                              'Total Paket',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
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
                                fontSize: 15,
                              ),
                            ),
                            pw.Text(
                              ':',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(width: 15),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              widget.dailyTask.expedition!.name!,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            pw.Text(
                              widget.dailyTask.totalPackage.toString(),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
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
                                  fontSize: 15,
                                ),
                              ),
                              pw.Text(
                                'Total Resi',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 15,
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
                                  fontSize: 15,
                                ),
                              ),
                              pw.Text(
                                ':',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(width: 15),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                Jiffy(widget.dailyTask.date)
                                    .format('dd MMMM yyyy'),
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              pw.Text(
                                (widget.dailyTask.receipts ?? [])
                                    .length
                                    .toString(),
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 15,
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
              pw.SizedBox(height: 20),
              pw.Text(
                'Detail',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Table(children: tableRow),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  _appenTableRow() {
    // List<String> tableData = [];
    tableRow.add(
      pw.TableRow(
        children: tableHeader.map((e) => pw.Text(e)).toList(),
      ),
    );
  }
}
