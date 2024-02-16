import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'dart:math' as math;

import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/screen/theme/hexcolor.dart';

import '../../daily_task/screen/daily_task_screen2.dart';

class PackageCard extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final List<DailyTask>? dailyTasks;
  final List<Expedition> expeditions;

  const PackageCard({
    super.key,
    this.animationController,
    this.animation,
    this.dailyTasks,
    required this.expeditions,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  Expedition? expedition;

  List<Expedition> existExpedition = [];

  @override
  void initState() {
    if ((widget.dailyTasks ?? []).isNotEmpty) {
      for (DailyTask e in (widget.dailyTasks ?? [])) {
        existExpedition.add(e.expedition!);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              30 * (1.0 - widget.animation!.value),
              0.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 16,
                bottom: 18,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.grey.withOpacity(0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: (widget.dailyTasks ?? []).isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: CircleTotalPackage(
                                totalPackage: 0,
                                animation: widget.animation!,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                "Tugas Harian Belum Dibuat",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.darkText.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ButtonTask(
                              title: "Buat Tugas",
                              width: 120,
                              onTap: _showBottomDialog,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 4),
                                    child: Column(
                                        children:
                                            (widget.dailyTasks ?? []).map((e) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (__) => DailyTaskScreen2(
                                                animationController:
                                                    widget.animationController,
                                                dailyTaskId: e.id!,
                                                platform:
                                                    e.expedition?.alias ?? "",
                                              ),
                                            ),
                                          ).then((value) {
                                            context
                                                .read<HomeBloc>()
                                                .add(GetData());
                                          });
                                        },
                                        child: ExpeditionPackage(
                                          title: e.expedition?.name ?? "",
                                          totalPackage: e.receipts?.length ?? 0,
                                        ),
                                      );
                                    }).toList()),
                                  ),
                                ),
                                CircleTotalPackage(
                                  totalPackage: getTotalPackage(),
                                  animation: widget.animation!,
                                )
                              ],
                            ),
                            ButtonTask(
                              title: "Tambah Tugas",
                              width: 150,
                              onTap: _showBottomDialog,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  int getTotalPackage() {
    int total = 0;
    widget.dailyTasks?.forEach((e) {
      total = total + (e.receipts ?? []).length;
    });
    return total;
  }

  _showBottomDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        List<Expedition> expeditions = [];
        return StatefulBuilder(builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Pilih Expedisi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.nearlyBlack,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  color: AppTheme.nearlyBlack,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, i) {
                    Expedition e = widget.expeditions[i];
                    bool enable = existExpedition.any((ee) => ee.id == e.id)
                        ? false
                        : true;

                    return CheckboxListTile(
                      value: expeditions.contains(e),
                      enabled: enable,
                      activeColor: AppTheme.nearlyBlue,
                      title: Text(e.name ?? "Expedition"),
                      visualDensity: const VisualDensity(vertical: -2),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        setState(() {
                          if (val ?? true) {
                            expeditions.add(e);
                          } else {
                            expeditions.remove(e);
                          }
                        });
                      },
                    );
                  },
                  itemCount: widget.expeditions.length,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Divider(
                  height: 1,
                  color: AppTheme.nearlyBlack,
                ),
              ),
              Center(
                child: ButtonTask(
                  title: "Submit",
                  width: 100,
                  color: Colors.blue[900]!.withOpacity(0.7),
                  icon: const Icon(
                    Icons.save_alt,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (expeditions.isNotEmpty) {
                      context
                          .read<HomeBloc>()
                          .add(OnSaveDailyTask(expeditions));
                    }
                  },
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

class ButtonTask extends StatelessWidget {
  const ButtonTask({
    super.key,
    required this.title,
    required this.width,
    required this.onTap,
    this.color,
    this.icon,
  });
  final String title;
  final double width;
  final Color? color;
  final Icon? icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 3),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color ?? AppTheme.nearlyDarkBlue.withOpacity(0.7),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                icon ??
                    const Icon(
                      Icons.add_circle_outline,
                      color: AppTheme.white,
                    ),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircleTotalPackage extends StatelessWidget {
  final int totalPackage;
  final Animation<double> animation;
  const CircleTotalPackage(
      {super.key, required this.totalPackage, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                  border: Border.all(
                      width: 4,
                      color: AppTheme.nearlyDarkBlue.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${(totalPackage * animation.value).toInt()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        letterSpacing: 0.0,
                        color: AppTheme.nearlyDarkBlue,
                      ),
                    ),
                    Text(
                      'Total Paket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.0,
                        color: AppTheme.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomPaint(
                painter: CurvePainter(colors: [
                  AppTheme.nearlyDarkBlue,
                  HexColor("#8A98E8"),
                  HexColor("#8A98E8")
                ], angle: 340),
                child: const SizedBox(
                  width: 118,
                  height: 118,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExpeditionPackage extends StatelessWidget {
  final String title;
  final String? imagePath;
  final int totalPackage;
  final Color? lineColor;
  const ExpeditionPackage({
    super.key,
    required this.title,
    this.imagePath,
    required this.totalPackage,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 48,
          width: 2,
          decoration: BoxDecoration(
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 2),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: -0.1,
                    color: AppTheme.grey.withOpacity(0.9),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Image.asset(imagePath ?? "assets/images/eaten.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 3),
                    child: Text(
                      '$totalPackage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkerText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 3),
                    child: Text(
                      'Paket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: -0.2,
                        color: AppTheme.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shdowPaint);

    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    const gradient1 = SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = Paint();
    cPaint.shader = gradient1.createShader(rect);
    cPaint.color = Colors.white;
    cPaint.strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(const Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
