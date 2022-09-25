import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String? title;
  final Color? backgroundColor;

  const LoadingScreen({Key? key, this.title, this.backgroundColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircularProgressIndicator(
              strokeWidth: 8,
              color: Colors.blueAccent,
              backgroundColor: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title ?? "Data sedang diproses . . . .",
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
