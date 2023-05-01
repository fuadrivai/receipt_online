import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/daily_task/bloc/daily_task_bloc.dart';
import 'package:receipt_online_shop/screen/daily_task/screen/daily_pdf_preview.dart';
import 'package:receipt_online_shop/screen/daily_task/screen/search_daily_task.dart';
import 'package:receipt_online_shop/widget/default_color.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

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
          BlocBuilder<DailyTaskBloc, DailyTaskState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: SearchTaskDelegate(
                            state.dailyTask?.receipts ?? []));
                  },
                  icon: const Icon(Icons.search));
            },
          ),
          BlocBuilder<DailyTaskBloc, DailyTaskState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (__) => DailyPdfPreviewScreen(
                                  dailyTask: state.dailyTask!,
                                )));
                  },
                  icon: const Icon(Icons.print));
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(context, onSuccess: (barcodeScanner) {
                context.read<DailyTaskBloc>().add(PostReceipt(
                    widget.dailyTaskId, widget.platform, barcodeScanner));
              });
            },
          )
        ],
      ),
      body: BlocBuilder<DailyTaskBloc, DailyTaskState>(
        builder: (__, state) {
          bool showDeleteBtn =
              (state.dailyTask?.receipts ?? []).isEmpty ? true : false;
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
                                  data: Jiffy.parse(state.dailyTask!.date!)
                                      .format(pattern: 'd MMMM yyyy'),
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
                                          onPressed: () async {
                                            // ignore: use_build_context_synchronously
                                            if (await confirm(
                                              context,
                                              content: Text(
                                                  'Yakin Ingin Menghapus Nomor Resi ${e.number}'),
                                              textOK: const Text('Yes'),
                                              textCancel: const Text('No'),
                                            )) {
                                              if (context.mounted) {
                                                context
                                                    .read<DailyTaskBloc>()
                                                    .add(RemoveReceipt(
                                                        e.number!));
                                              }
                                            }
                                          },
                                          icon: const FaIcon(
                                            FontAwesomeIcons.trash,
                                            size: 20,
                                            color: Colors.red,
                                          )),
                                      title: Text(e.number ?? "--"),
                                      subtitle: Text(Jiffy.parseFromDateTime(
                                              DateTime.parse(e.createdAt!)
                                                  .toLocal())
                                          .yMMMdjm),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                left: 8,
                                right: 8,
                              ),
                              child: Visibility(
                                visible: !(state.dailyTask?.status ?? false),
                                child: Row(
                                  mainAxisAlignment: showDeleteBtn
                                      ? MainAxisAlignment.spaceEvenly
                                      : MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 45,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: DefaultColor.primary,
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          "Selesaikan",
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: showDeleteBtn,
                                      child: SizedBox(
                                        width: 150,
                                        height: 45,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 190, 17, 4),
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            "Hapus",
                                            style: TextStyle(
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
