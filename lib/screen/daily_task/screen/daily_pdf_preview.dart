import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DailyPdfPreviewScreen extends StatefulWidget {
  const DailyPdfPreviewScreen({super.key});

  @override
  State<DailyPdfPreviewScreen> createState() => _DailyPdfPreviewScreenState();
}

class _DailyPdfPreviewScreenState extends State<DailyPdfPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Document'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => _generatePdf(format, "Data Title"),
        canDebug: false,
        canChangeOrientation: false,
        pdfFileName: DateTime.now().millisecond.toString(),
        // actions: actions,
        // onPrinted: _showPrintedToast,
        // onShared: _showSharedToast,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final image = await imageFromAssetBundle('assets/images/logo.png');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(child: pw.Image(image)),
              pw.Center(
                child: pw.Text(title, style: const pw.TextStyle(fontSize: 24)),
              ),
              pw.SizedBox(height: 20),
              // pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
