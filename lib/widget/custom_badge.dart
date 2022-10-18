import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class CustomeBadge extends StatelessWidget {
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final BorderRadiusGeometry? borderRadius;
  final String text;
  final GestureTapCallback? onTap;
  const CustomeBadge({
    super.key,
    this.backgroundColor,
    this.borderSide,
    this.borderRadius,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Badge(
        toAnimate: false,
        shape: BadgeShape.square,
        badgeColor: backgroundColor ?? Colors.white,
        elevation: 0,
        borderSide: borderSide ??
            const BorderSide(
              width: 1,
              color: Colors.blueAccent,
            ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        badgeContent: SizedBox(
          width: MediaQuery.of(context).size.width * 30 / 100,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: ((backgroundColor ?? Colors.black).computeLuminance() >
                          0.179)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
