import 'package:flutter/material.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:responsive_grid/responsive_grid.dart';

class PlatformBody extends StatelessWidget {
  const PlatformBody({super.key, required this.platforms});
  final List<Platform> platforms;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: ResponsiveGridRow(
        children: List.generate(platforms.length, (i) {
          Platform platform = platforms[i];
          return ResponsiveGridCol(
              xs: 4,
              child: Card(
                shadowColor: AppTheme.dark_grey.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(
                        platform.logo!,
                        height: 60,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        platform.name ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }),
      ),
    );
  }
}
