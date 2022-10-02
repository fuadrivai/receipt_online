import 'package:flutter/material.dart';

class TextFormDecoration {
  static InputDecoration box(
    String title, {
    bool? showLabel,
    bool? showHint,
    double? padding,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      hintText: showHint ?? true ? title : null,
      labelText: showLabel ?? true ? title : null,
      contentPadding: EdgeInsets.all(padding ?? 10),
      suffixIcon: suffixIcon,
    );
  }

  static InputDecoration dateBox(
    String title, {
    bool showLabel = true,
    bool showHint = true,
    double? padding,
    VoidCallback? onPressed,
    BuildContext? context,
  }) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        borderSide: BorderSide(color: Colors.black, width: 0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        borderSide: BorderSide(color: Colors.black, width: 0),
      ),
      hintText: showHint ? title : null,
      labelText: showLabel ? title : null,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      contentPadding: EdgeInsets.all(padding ?? 16),
      suffixIcon: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.date_range,
            color: Colors.white,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
