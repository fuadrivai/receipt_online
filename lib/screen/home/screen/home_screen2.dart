import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:receipt_online_shop/screen/home/screen/package_card.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/title_view.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key, this.animationController});
  final AnimationController? animationController;
  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  static const int count = 9;

  @override
  void initState() {
    context.read<HomeBloc>().add(GetData());
    super.initState();
  }

  Future _refresh() async {
    context.read<HomeBloc>().add(GetData());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            CustomAppbar(
              title: "Dashboard",
              animationController: widget.animationController,
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (_, state) {
                if (state is HomeLoadingState) {
                  return const LoadingScreen();
                }
                if (state is HomeErrorState) {
                  return Center(
                    child: Text(state.error.toString()),
                  );
                }

                if (state is DataState) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      shrinkWrap: true,
                      // physics: const ScrollPhysics(),
                      children: [
                        TitleView(
                          animationController: widget.animationController,
                          animation:
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: widget.animationController!,
                              curve: const Interval(
                                (1 / count) * 0,
                                1.0,
                                curve: Curves.fastOutSlowIn,
                              ),
                            ),
                          ),
                          titleTxt: "Paket Aktif",
                          subTxt: Jiffy.now().format(pattern: "dd MMM yyyy"),
                        ),
                        PackageCard(
                          totalPackage: 0,
                          dailyTasks: state.dailyTasks,
                          animation:
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: widget.animationController!,
                              curve: const Interval(
                                (1 / count) * 1,
                                1.0,
                                curve: Curves.fastOutSlowIn,
                              ),
                            ),
                          ),
                          animationController: widget.animationController!,
                        ),
                        TitleView(
                          animationController: widget.animationController,
                          animation:
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: widget.animationController!,
                              curve: const Interval(
                                (1 / count) * 0,
                                1.0,
                                curve: Curves.fastOutSlowIn,
                              ),
                            ),
                          ),
                          titleTxt: "Expedisi",
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
