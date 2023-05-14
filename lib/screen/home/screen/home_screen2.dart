import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:receipt_online_shop/screen/home/screen/active_packages_shimmer.dart';
import 'package:receipt_online_shop/screen/home/screen/platform_shimmer.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';

import 'home_body.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key, this.animationController});
  final AnimationController? animationController;
  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

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
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomAppbar(
            leading: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset("assets/images/logo.png"),
            ),
            title: "SSMART10",
            animationController: widget.animationController,
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (_, state) {
            if (state is HomeLoadingState) {
              return HomeBody(
                expeditions: const [],
                platforms: const [],
                animationController: widget.animationController,
                activePackageShimmer: ActivePackageShimmer(
                  animationController: widget.animationController,
                ),
                platformShimmer: const PlatformShimmer(),
              );
            }
            if (state is HomeErrorState) {
              return Center(
                child: Text(state.error.toString()),
              );
            }

            if (state is DataState) {
              return HomeBody(
                animationController: widget.animationController,
                dailyTasks: state.dailyTasks,
                expeditions: state.expeditions ?? [],
                platforms: state.platforms ?? [],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
