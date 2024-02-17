import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;

  const TitleView({super.key, this.titleTxt = "", this.subTxt = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              titleTxt,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 0.5,
                color: AppTheme.lightText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              subTxt,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                letterSpacing: 0.5,
                color: AppTheme.nearlyDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
