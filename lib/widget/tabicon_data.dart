// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/screen/theme/hexcolor.dart';

class TabIconData {
  TabIconData({
    required this.imagePath,
    this.index = 0,
    required this.selectedImagePath,
    this.isSelected = false,
    this.animationController,
  });

  Widget imagePath;
  Widget selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: const Icon(
        Icons.home,
        color: AppTheme.dark_grey,
        size: 40,
      ),
      selectedImagePath: Icon(
        Icons.home,
        color: HexColor("#8A98E8"),
        size: 40,
      ),
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: Image.asset(
        "assets/images/logo.png",
        width: 30.0,
        height: 30.0,
        fit: BoxFit.cover,
      ),
      selectedImagePath: Image.asset(
        "assets/images/logo.png",
        width: 30.0,
        height: 30.0,
        fit: BoxFit.cover,
      ),
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: Image.asset(
        "assets/images/logo.png",
        width: 30.0,
        height: 30.0,
        fit: BoxFit.cover,
      ),
      selectedImagePath: Image.asset(
        "assets/images/logo.png",
        width: 30.0,
        height: 30.0,
        fit: BoxFit.cover,
      ),
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: Image.asset(
        "assets/images/logo.png",
        width: 30.0,
        height: 30.0,
        fit: BoxFit.cover,
      ),
      selectedImagePath: Image.asset(
        "assets/images/logo.png",
        width: 30.0,
        height: 30.0,
        fit: BoxFit.cover,
      ),
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
