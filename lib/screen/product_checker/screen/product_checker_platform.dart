import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/custom_badge.dart';
import 'package:receipt_online_shop/widget/default_color.dart';
import 'package:shimmer/shimmer.dart';

class ListPlatform extends StatefulWidget {
  final Function(Platform)? getPlatform;
  final Function(Platform)? onTap;
  const ListPlatform({super.key, this.getPlatform, this.onTap});

  @override
  State<ListPlatform> createState() => _ListPlatformState();
}

class _ListPlatformState extends State<ListPlatform> {
  List<Platform> platforms = [];

  @override
  void initState() {
    context.read<ProductCheckerBloc>().add(ProductCheckerStandByEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCheckerBloc, ProductCheckerState>(
      builder: (context, state) {
        if (state is ProductCheckerLoadingState) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
              height: 38,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (__, i) {
                    return const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: CustomeBadge(
                        width: 50,
                        text: "",
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
        if (state is ProductCheckerStandByState) {
          platforms = (state.platforms ?? []);
          widget.getPlatform!(state.platform!);
          return PlatformList(
            platforms: platforms,
            onTap: (pl) {
              widget.onTap!(pl);
              setState(() {});
            },
            state: state.platform!,
          );
        }
        if (state is ProductCheckerDataState) {
          platforms = (state.platforms ?? []);
          widget.getPlatform!(state.platform!);
          return PlatformList(
            platforms: platforms,
            onTap: (pl) {
              widget.onTap!(pl);
              setState(() {});
            },
            state: state.platform!,
          );
        }
        if (state is ProductCheckerErrorState) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Data Tidak Tersedia'));
      },
    );
  }
}

class PlatformList extends StatelessWidget {
  final List<Platform> platforms;
  final Function(Platform) onTap;
  final Platform state;
  const PlatformList({
    super.key,
    required this.platforms,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: platforms.length,
          itemBuilder: (__, i) {
            Platform platform = platforms[i];
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomeBadge(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(platform.icon!),
                    radius: 7,
                  ),
                ),
                text: "${platform.name}",
                onTap: () {
                  context
                      .read<ProductCheckerBloc>()
                      .add(ProductCheckerOnTabEvent(platform, platforms));
                  onTap(platform);
                },
                backgroundColor:
                    platform.id == state.id ? DefaultColor.primary : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
