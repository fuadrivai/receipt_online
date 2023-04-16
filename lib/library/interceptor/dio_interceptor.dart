import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';

import 'injector.dart';

class DioInterceptors extends InterceptorsWrapper {
  final Dio dio;
  DioInterceptors(this.dio);
  final NavigationService _nav = locator<NavigationService>();

  @override
  Future onError(err, handler) async {
    int? responseCode = err.response?.statusCode;
    var data = err.response?.data;
    // ignore: avoid_print
    print(data);
    if (responseCode != null) {
      if (responseCode == 403) {
        // AppRouter.router.navigateTo(
        //   _nav.navKey.currentContext!,
        //   AppRoutes.loginRoute.route,
        //   replace: true,
        //   clearStack: true,
        // );
        // ignore: avoid_print
        print('403');
      } else {
        Common.modalInfo(
          _nav.navKey.currentContext!,
          title: "Error",
          message: err.response?.data['message'] ?? "Gagal Mengakses Server",
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
            size: 30,
          ),
        );
      }
    } else {
      Common.modalInfo(
        _nav.navKey.currentContext!,
        title: "Error",
        message: err.response?.data['message'] ?? "Gagal Mengakses Server",
        icon: const Icon(
          Icons.cancel_outlined,
          color: Colors.red,
          size: 30,
        ),
      );
    }
    super.onError(err, handler);
  }
}
