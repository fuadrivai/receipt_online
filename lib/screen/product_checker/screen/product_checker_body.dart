import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/detail_order.dart';
import 'package:shimmer/shimmer.dart';

class ProductCheckerBody extends StatefulWidget {
  const ProductCheckerBody({super.key});

  @override
  State<ProductCheckerBody> createState() => _ProductCheckerBodyState();
}

class _ProductCheckerBodyState extends State<ProductCheckerBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCheckerBloc, ProductCheckerState>(
      builder: ((context, state) {
        if (state.isLoading ?? true) {
          return DefaultCard(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.walkieTalkie,
                    color: Colors.blueAccent,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Silahkan Tunggu",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 63, 43, 245),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (state.isError ?? false) {
          return DefaultCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.circleXmark,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  state.errorMessage ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 248, 30, 15),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        if ((state.data ?? []).isEmpty) {
          return DefaultCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (state.platform!.logo != null)
                    ? Image.network(
                        state.platform!.logo!,
                        scale: 1.5,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.earthEurope,
                        size: 100,
                        color: Colors.blueGrey,
                      ),
                const SizedBox(height: 10),
                const Text(
                  "Silahkan Scann Barcode Pesanan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 63, 43, 245),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return DetailOrder(
          orders: state.data ?? [],
          onCreateOrder: (order) {
            context
                .read<ProductCheckerBloc>()
                .add(CreateOrderEvent(state.platform!, order));
          },
          onPressed: (order) {
            context
                .read<ProductCheckerBloc>()
                .add(RtsEvent(state.platform!, order));
          },
        );
      }),
    );
  }
}

class DefaultCard extends StatelessWidget {
  final Widget child;
  const DefaultCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      constraints: const BoxConstraints(minHeight: 300, maxHeight: 300),
      child: child,
    );
  }
}
