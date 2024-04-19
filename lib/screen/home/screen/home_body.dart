import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/model/expired_token.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:receipt_online_shop/screen/home/screen/auth_screen.dart';
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
    this.expired,
  });
  final List<DailyTask>? dailyTasks;
  final List<Expedition> expeditions;
  final List<Platform> platforms;
  final Widget? activePackageShimmer;
  final Widget? platformShimmer;
  final ExpiredToken? expired;
  static const int count = 9;

  @override
  Widget build(BuildContext context) {
    int days = (expired?.days ?? 0);
    Color textColor =
        days < 0 ? Colors.white : const Color.fromARGB(255, 121, 121, 121);
    return ListView(
      children: [
        Visibility(
          visible: expired?.showWarning ?? false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: days < 0
                    ? const Color.fromARGB(255, 250, 128, 119)
                    : const Color.fromARGB(255, 252, 220, 133),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                dense: true,
                title: Text(
                  expired?.message ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
                trailing: Icon(
                  FontAwesomeIcons.arrowRight,
                  color: textColor,
                  size: 15,
                ),
                onTap: () {
                  days < 0
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return const LazadaAuthScreen();
                        })).then((value) {
                          context.read<HomeBloc>().add(GetData());
                        })
                      : context.read<HomeBloc>().add(OnRefreshToken());
                },
              ),
            ),
          ),
        ),
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
