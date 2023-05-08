import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/receipt.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/card_banner.dart';
import 'package:receipt_online_shop/widget/custom_badge.dart';

import '../bloc/daily_task_bloc.dart';

class DailyTaskDetail extends StatefulWidget {
  final DailyTask? dailyTask;
  const DailyTaskDetail({super.key, this.dailyTask});

  @override
  State<DailyTaskDetail> createState() => _DailyTaskDetailState();
}

class _DailyTaskDetailState extends State<DailyTaskDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
      child: Column(
        children: List.generate(
          (widget.dailyTask?.receipts ?? []).length,
          (i) {
            Receipt e = (widget.dailyTask?.receipts ?? [])[i];
            return CardBanner(
              title: e.number ?? "--",
              subtitle: Jiffy.parseFromDateTime(
                      DateTime.parse(e.createdAt!).toLocal())
                  .yMMMdjm,
              leading: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomeBadge(
                  text: "${i + 1}",
                  borderRadius: BorderRadius.circular(25),
                  height: 30,
                  width: 30,
                ),
              ),
              trailing: IconButton(
                  onPressed: () async {
                    // ignore: use_build_context_synchronously
                    if (await confirm(
                      context,
                      content:
                          Text('Yakin Ingin Menghapus Nomor Resi ${e.number}'),
                      textOK: const Text('Yes'),
                      textCancel: const Text('No'),
                    )) {
                      if (context.mounted) {
                        context
                            .read<DailyTaskBloc>()
                            .add(RemoveReceipt(e.number!));
                      }
                    }
                  },
                  icon: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.trash,
                        size: 15,
                        color: Colors.red.withOpacity(0.7),
                      ),
                    ),
                  )),
            );
          },
          growable: true,
        ),
      ),
    );
  }
}
