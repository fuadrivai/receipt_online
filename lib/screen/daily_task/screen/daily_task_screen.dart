import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/screen/daily_task/bloc/daily_task_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DailyTaskScreen extends StatefulWidget {
  final int dailyTaskId;
  const DailyTaskScreen(
    this.dailyTaskId, {
    super.key,
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.print)),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {},
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
                      print(barcode);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
