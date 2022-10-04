import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receipt_online_shop/screen/daily_task/bloc/daily_task_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DailyTaskScreen extends StatefulWidget {
  final int dailyTaskId;
  final String platform;

  const DailyTaskScreen({
    super.key,
    required this.dailyTaskId,
    required this.platform,
  });

  @override
  State<DailyTaskScreen> createState() => _DailyTaskScreenState();
}

class _DailyTaskScreenState extends State<DailyTaskScreen> {
  late bool visible;

  @override
  void initState() {
    context.read<DailyTaskBloc>().add(GetDailyTask(widget.dailyTaskId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Harian'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () async {
                final pdf = pw.Document();
                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) => pw.Center(
                      child: pw.Text('Hello World!'),
                    ),
                  ),
                );

                await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdf.save());
              },
              icon: const Icon(Icons.print)),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              scanBarcodeNormal(context, onSuccess: (barcodeScanner) {
                context.read<DailyTaskBloc>().add(PostReceipt(
                    widget.dailyTaskId, widget.platform, barcodeScanner));
              });
            },
          )
        ],
      ),
      body: BlocBuilder<DailyTaskBloc, DailyTaskState>(
        builder: (__, state) {
          return state.isLoading
              ? const LoadingScreen()
              : VisibilityDetector(
                  key: const Key('visible-detector-key'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    visible = info.visibleFraction > 0;
                  },
                  child: BarcodeKeyboardListener(
                    onBarcodeScanned: (barcode) {
                      context.read<DailyTaskBloc>().add(PostReceipt(
                          widget.dailyTaskId,
                          state.dailyTask?.expedition?.alias ?? "",
                          barcode));
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<DailyTaskBloc>()
                            .add(GetDailyTask(widget.dailyTaskId));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                        child: ListView(
                          children: [
                            ResponsiveGridRow(
                              children: [
                                _gridCol(
                                  title: "Expedisi",
                                  data: state.dailyTask?.expedition?.name ??
                                      'Expedisi',
                                ),
                                _gridCol(
                                  title: "Tanggal",
                                  data: Jiffy(state.dailyTask?.date)
                                      .format('d MMMM yyyy'),
                                ),
                                _gridCol(
                                  title: "Total Paket",
                                  data: (state.dailyTask?.totalPackage ?? 0)
                                      .toString(),
                                ),
                                _gridCol(
                                  title: "Data Scan",
                                  data: (state.dailyTask?.receipts?.length ?? 0)
                                      .toString(),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Detail Data",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      // color: Colors.blue,
                                      fontSize: 18,
                                    ),
                                  ),
                                  InkWell(
                                    child: const Text(
                                      'Input Manual',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue),
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 6, left: 6, right: 6),
                              child: Column(
                                children:
                                    (state.dailyTask?.receipts ?? []).map((e) {
                                  return Card(
                                    child: ListTile(
                                      trailing: IconButton(
                                          onPressed: () {},
                                          icon: const FaIcon(
                                            FontAwesomeIcons.trash,
                                            size: 20,
                                            color: Colors.red,
                                          )),
                                      title: Text(e.number ?? "--"),
                                      subtitle: Text(Jiffy(e.createdAt)
                                          .format('d MMMM yyyy HH:mm:ss')),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> scanBarcodeNormal(BuildContext context,
      {required Function onSuccess}) async {
    String barcodeScaner;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScaner = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      onSuccess(barcodeScaner);
    } on PlatformException {
      barcodeScaner = 'Failed to get platform version.';
    }
  }

  ResponsiveGridCol _gridCol({
    required String title,
    required String data,
  }) {
    return ResponsiveGridCol(
      xs: 6,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                data,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
