import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/screen/home/screen/package_card.dart';
import 'package:receipt_online_shop/screen/home/screen/platform_body.dart';
import 'package:receipt_online_shop/widget/title_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    this.dailyTasks,
    this.activePackageShimmer,
    required this.expeditions,
    required this.platforms,
    this.platformShimmer,
  });
  final List<DailyTask>? dailyTasks;
  final List<Expedition> expeditions;
  final List<Platform> platforms;
  final Widget? activePackageShimmer;
  final Widget? platformShimmer;
  static const int count = 9;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TitleView(
          titleTxt: "Paket Aktif",
          subTxt: Jiffy.now().format(pattern: "dd MMM yyyy"),
        ),
        activePackageShimmer ??
            PackageCard(
              expeditions: expeditions,
              dailyTasks: dailyTasks,
            ),
        const TitleView(titleTxt: "Platform"),
        platformShimmer ?? PlatformBody(platforms: platforms),
      ],
    );
  }
}
