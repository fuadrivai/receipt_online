import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/string_uppercase.dart';
import 'package:receipt_online_shop/screen/daily_task/bloc/daily_task_bloc.dart';
import 'package:receipt_online_shop/screen/daily_task/screen/daily_pdf_preview.dart';
import 'package:receipt_online_shop/screen/daily_task/screen/daily_task_detail.dart';
import 'package:receipt_online_shop/screen/daily_task/screen/daily_task_header.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/default_color.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DailyTaskScreen2 extends StatefulWidget {
  const DailyTaskScreen2({
    super.key,
    required this.dailyTaskId,
    required this.platform,
  });
  final int dailyTaskId;
  final String platform;

  @override
  State<DailyTaskScreen2> createState() => _DailyTaskScreen2State();
}

class _DailyTaskScreen2State extends State<DailyTaskScreen2> {
  late bool visible;
  bool isSearching = false;
  late TextEditingController txtSearch = TextEditingController();
  late FocusNode searchNode = FocusNode();
  @override
  void initState() {
    context.read<DailyTaskBloc>().add(GetDailyTask(widget.dailyTaskId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            isSearching
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 20,
                      right: 8,
                      bottom: 10,
                    ),
                    child: TextFormField(
                      focusNode: searchNode,
                      enabled: true,
                      readOnly: false,
                      controller: txtSearch,
                      onChanged: (text) {
                        List<String> listChar = [];
                        for (var rune in text.runes) {
                          var character = String.fromCharCode(rune);
                          listChar.add(character.upperCase());
                        }
                        context
                            .read<DailyTaskBloc>()
                            .add(SearchReceipt(listChar.join()));
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        hintText: "Masukan Nomor Resi",
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          onPressed: () {
                            isSearching = false;
                            txtSearch.clear();
                            context.read<DailyTaskBloc>().add(ClearSearch());
                            setState(() {});
                          },
                          icon: const FaIcon(FontAwesomeIcons.circleXmark),
                        ),
                      ),
                    ),
                  )
                : CustomAppbar(
                    leading: IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.topCenter,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    title: "Tugas Harian",
                    actions: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<DailyTaskBloc, DailyTaskState>(
                          builder: (context, state) {
                            return IconButton(
                                padding: const EdgeInsets.all(0),
                                alignment: Alignment.topCenter,
                                onPressed: () {
                                  isSearching = true;
                                  searchNode.requestFocus();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.search));
                          },
                        ),
                        BlocBuilder<DailyTaskBloc, DailyTaskState>(
                          builder: (context, state) {
                            return IconButton(
                                padding: const EdgeInsets.all(0),
                                alignment: Alignment.topCenter,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (__) =>
                                              DailyPdfPreviewScreen(
                                                dailyTask: state.dailyTask!,
                                              )));
                                },
                                icon: const Icon(Icons.print));
                          },
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.topCenter,
                          icon: const Icon(Icons.qr_code_scanner_outlined),
                          onPressed: () {
                            Common.scanBarcodeNormal(context,
                                onSuccess: (barcodeScanner) {
                              context.read<DailyTaskBloc>().add(PostReceipt(
                                  widget.dailyTaskId,
                                  widget.platform,
                                  barcodeScanner));
                            });
                          },
                        )
                      ],
                    ),
                  ),
            Expanded(
              child: BlocBuilder<DailyTaskBloc, DailyTaskState>(
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
                              child: ListView(
                                padding: const EdgeInsets.all(0),
                                children: [
                                  DailyTaskHeader(
                                    title:
                                        state.dailyTask?.expedition?.name ?? "",
                                    date: Jiffy.parse(state.dailyTask?.date ??
                                            DateTime.now().toString())
                                        .format(pattern: 'd MMMM yyyy'),
                                    dataScan:
                                        (state.dailyTask?.receipts?.length ??
                                            0),
                                    totalPackage:
                                        (state.dailyTask?.totalPackage ?? 0),
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
                                  DailyTaskDetail(
                                    dailyTask: state.tempDailyTask,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Visibility(
                                      visible:
                                          !(state.dailyTask?.status ?? false),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: !showDeleteBtn,
                                            child: SizedBox(
                                              width: 150,
                                              height: 45,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      DefaultColor.primary,
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<DailyTaskBloc>()
                                                      .add(FinishDailyTask(state
                                                          .dailyTask!.id!));
                                                },
                                                child: const Text(
                                                  "Selesaikan",
                                                  style: TextStyle(
                                                    color: Color(0xffffffff),
                                                  ),
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
                                                onPressed: () {
                                                  context
                                                      .read<DailyTaskBloc>()
                                                      .add(RemoveDailyTask(state
                                                          .dailyTask!.id!));
                                                },
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
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
