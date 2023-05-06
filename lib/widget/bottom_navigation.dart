import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/home/screen/home_screen2.dart';
import 'package:receipt_online_shop/screen/jdid/jdid_detail_screen.dart';
import 'package:receipt_online_shop/screen/lazada/lazada_screen.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_screen2.dart';
import 'package:receipt_online_shop/screen/tiktok/tiktok_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  int _currentIndex = 0;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        fixedColor: const Color(0xFF6991C7),
        onTap: (i) {
          _currentIndex = i;
          setState(() {});
        },
        items: [
          const BottomNavigationBarItem(
            label: "Dashboard",
            icon: Icon(
              Icons.home,
              size: 23.0,
            ),
          ),
          BottomNavigationBarItem(
            label: "Checker",
            icon: Image.asset(
              "assets/images/logo.png",
              width: 30.0,
              height: 30.0,
              fit: BoxFit.cover,
            ),
          ),
          BottomNavigationBarItem(
            label: "Tiktok",
            icon: Image.asset(
              "assets/images/tiktok.png",
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          BottomNavigationBarItem(
            label: "Lazada",
            icon: Image.asset(
              "assets/images/lazada.jpg",
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget callPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen2(animationController: animationController);
      case 1:
        return ProductCheckerScreen2(animationController: animationController);
      case 2:
        return const TiktokScreen();
      case 3:
        return const LazadaScreen();
      // return const LazadaScreen();
      case 4:
        return const JdIdDetailScreen();
      default:
        return HomeScreen2(animationController: animationController);
    }
  }
}
