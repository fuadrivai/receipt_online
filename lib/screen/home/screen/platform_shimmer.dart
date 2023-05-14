import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shimmer/shimmer.dart';

class PlatformShimmer extends StatelessWidget {
  const PlatformShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
      child: ResponsiveGridRow(
        children: List.generate(6, (i) {
          return ResponsiveGridCol(
              xs: 4,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 70,
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }
}
