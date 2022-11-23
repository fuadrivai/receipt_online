import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/shopee_list_view.dart';
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
        if (state is ProductCheckerLoadingState) {
          return Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(minHeight: 300, maxHeight: 300),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
            ),
          );
        }
        if (state is ProductCheckerStandByState) {
          return Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(minHeight: 300, maxHeight: 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    state.platform!.logo!,
                    scale: 1.5,
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
            ),
          );
        }
        if (state is ProductCheckerDataState) {
          return ShopeeListView(
            orders: state.data ?? [],
            onPressed: (order) {
              context
                  .read<ProductCheckerBloc>()
                  .add(RtsEvent(state.platform!, order));
            },
          );
        }
        if (state is ProductCheckerErrorState) {
          return Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(minHeight: 300, maxHeight: 300),
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
                    state.message,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 248, 30, 15),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return const Text('Something Wrong');
      }),
    );
  }
}
