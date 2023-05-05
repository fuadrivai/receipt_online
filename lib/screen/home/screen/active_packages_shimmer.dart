import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/home/screen/package_card.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';

class ActivePackageShimmer extends StatelessWidget {
  final AnimationController? animationController;
  const ActivePackageShimmer({super.key, this.animationController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
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
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: Column(
                    children: const [
                      ExpeditionPackage(
                        title: "",
                        totalPackage: 0,
                      ),
                      ExpeditionPackage(
                        title: "",
                        totalPackage: 0,
                      ),
                      ExpeditionPackage(
                        title: "",
                        totalPackage: 0,
                      ),
                      ExpeditionPackage(
                        title: "",
                        totalPackage: 0,
                      ),
                    ],
                  ),
                ),
              ),
              CircleTotalPackage(
                totalPackage: 0,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: const Interval(
                      (1 / 9) * 1,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
