import 'package:flutter/material.dart';

class NavigationService {
  // ignore: unnecessary_new
  final GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> pushNamedWithArguments(String routeName) {
    return navKey.currentState!.pushNamed(routeName);
  }
}
