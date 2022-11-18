import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/home/screen/home_screen.dart';
import 'package:receipt_online_shop/screen/jdid/jdid_detail_screen.dart';
import 'package:receipt_online_shop/screen/lazada/lazada_by_id_screen.dart';
import 'package:receipt_online_shop/screen/lazada/lazada_screen.dart';
import 'package:receipt_online_shop/screen/product_checker/screen/product_checker_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
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
            label: "Lazada",
            icon: Image.asset(
              "assets/images/lazada.jpg",
              width: 30.0,
              height: 30.0,
              fit: BoxFit.cover,
            ),
          ),
          const BottomNavigationBarItem(
            label: "Lazada",
            icon: Icon(
              Icons.fire_truck,
              size: 23.0,
            ),
          ),
          const BottomNavigationBarItem(
            label: "JD ID",
            icon: Icon(
              Icons.fire_truck,
              size: 23.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget callPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ProductCheckerScreen();
      case 2:
        return const LazadaByIdScreen();
      case 3:
        return const LazadaScreen();
      case 4:
        return const JdIdDetailScreen();
      default:
        return const HomeScreen();
    }
  }
}
