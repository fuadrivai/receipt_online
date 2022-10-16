import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/screen/daily_task/bloc/daily_task_bloc.dart';
import 'package:receipt_online_shop/screen/expedition/bloc/expedition_bloc.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/lazada_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/platform_bloc.dart';
import 'package:receipt_online_shop/widget/splash_screen.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NavigationService _nav = locator<NavigationService>();

  @override
  void initState() {
    Jiffy.locale('id');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (__) => HomeBloc()),
        BlocProvider<ExpeditionBloc>(create: (__) => ExpeditionBloc()),
        BlocProvider<DailyTaskBloc>(create: (__) => DailyTaskBloc()),
        BlocProvider<LazadaBloc>(create: (__) => LazadaBloc()),
        BlocProvider<PlatformBloc>(create: (__) => PlatformBloc()),
      ],
      child: MaterialApp(
        navigatorKey: _nav.navKey,
        theme: ThemeData(
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
