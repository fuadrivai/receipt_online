import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/library/seesion_manager.dart';
import 'package:receipt_online_shop/screen/daily_task/bloc/daily_task_bloc.dart';
import 'package:receipt_online_shop/screen/expedition/bloc/expedition_bloc.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:receipt_online_shop/screen/jdid/bloc/jd_id_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/by_id_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/lazada_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/bloc/platform_bloc.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/screen/shopee/bloc/list_shopee_bloc.dart';
import 'package:receipt_online_shop/screen/shopee/bloc/shopee_bloc.dart';
import 'package:receipt_online_shop/screen/tiktok/bloc/tiktok_bloc.dart';
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
    Session.checkValue("sorting").then((value) {
      if (!value) {
        Session.set("sorting", "DESC");
      }
    });
    Jiffy.setLocale('id');
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
        BlocProvider<ShopeeDetailBloc>(create: (__) => ShopeeDetailBloc()),
        BlocProvider<ListShopeeBloc>(create: (__) => ListShopeeBloc()),
        BlocProvider<ByIdBloc>(create: (__) => ByIdBloc()),
        BlocProvider<JdIdBloc>(create: (__) => JdIdBloc()),
        BlocProvider<ProductCheckerBloc>(create: (__) => ProductCheckerBloc()),
        BlocProvider<TiktokBloc>(create: (__) => TiktokBloc()),
      ],
      child: MaterialApp(
        navigatorKey: _nav.navKey,
        theme: ThemeData(
          fontFamily: 'Lato',
          scaffoldBackgroundColor: const Color.fromARGB(255, 247, 246, 246),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
