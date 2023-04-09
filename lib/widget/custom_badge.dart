import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';

class CustomeBadge extends StatelessWidget {
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? icon;
  final String text;
  final GestureTapCallback? onTap;
  const CustomeBadge({
    super.key,
    this.backgroundColor,
    this.borderSide,
    this.borderRadius,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: badge.Badge(
        badgeStyle: badge.BadgeStyle(
          shape: badge.BadgeShape.square,
          badgeColor: backgroundColor ?? Colors.white,
          elevation: 0,
          borderSide: borderSide ??
              const BorderSide(
                width: 1,
                color: Colors.blueAccent,
              ),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        badgeContent: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? const SizedBox(),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        ((backgroundColor ?? Colors.black).computeLuminance() >
                                0.179)
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
