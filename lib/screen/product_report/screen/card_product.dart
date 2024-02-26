import 'package:flutter/material.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:badges/badges.dart' as badge;

class CardProduct extends StatelessWidget {
  final ReportDetail detail;
  final GestureTapCallback onTap;
  const CardProduct({super.key, required this.detail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: (detail.isChecked ?? false)
                ? AppTheme.white
                : Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.nearlyDarkBlue.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                dense: true,
                leading: Image.asset("assets/images/logo.png"),
                title: Text(
                  (detail.product?.name ?? "").toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                    "Rp. ${Common.oCcy.format(detail.product?.price ?? 0)}"),
                trailing: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Total Qty"),
                      badge.Badge(
                        badgeStyle: badge.BadgeStyle(
                          shape: badge.BadgeShape.square,
                          badgeColor: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        badgeContent: Text(
                          Common.oCcy.format(detail.qty),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 30, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Karton"),
                    Text(
                      Common.oCcy.format(
                          ((detail.qty ?? 0) / (detail.qtyCarton ?? 0))
                              .floor()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 25, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Rupiah"),
                    Text(
                      "Rp. ${Common.oCcy.format((detail.qty ?? 0) * (detail.product?.price ?? 0))}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
