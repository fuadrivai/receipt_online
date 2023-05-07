import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/screen/theme/hexcolor.dart';

class CardBanner extends StatelessWidget {
  final String subtitle;
  final String title;
  final Widget? trailing;
  final Widget? leading;
  const CardBanner({
    Key? key,
    required this.subtitle,
    required this.title,
    this.trailing,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HexColor("#8A98E8"),
            AppTheme.nearlyDarkBlue,
          ],
          begin: const FractionalOffset(1.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
          stops: const [0.0, 1.0],
          tileMode: TileMode.repeated,
        ),
        color: AppTheme.nearlyDarkBlue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              leading ?? const SizedBox.shrink(),
              Text.rich(
                TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "$subtitle\n",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
