import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/screen/product_checker/bloc/product_checker_bloc.dart';
import 'package:receipt_online_shop/widget/custom_badge.dart';
import 'package:receipt_online_shop/widget/shopee_list_view.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

class ProductCheckerScreen extends StatefulWidget {
  const ProductCheckerScreen({super.key});

  @override
  State<ProductCheckerScreen> createState() => _ProductCheckerScreenState();
}

class _ProductCheckerScreenState extends State<ProductCheckerScreen> {
  final currency = NumberFormat("#,##0", "en_US");
  TextEditingController barcodeController = TextEditingController();
  late bool visible;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<ProductCheckerBloc>().add(ProductCheckerStandByEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Checker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Common.scanBarcodeNormal(
                context,
                onSuccess: (barcodeScanner) {
                  barcodeController.text = barcodeScanner;
                },
              );
            },
          )
        ],
      ),
      body: VisibilityDetector(
        key: const Key('visible-detector-key'),
        onVisibilityChanged: (VisibilityInfo info) {
          visible = info.visibleFraction > 0;
        },
        child: BarcodeKeyboardListener(
          onBarcodeScanned: (String barcode) {
            barcodeController.text = barcode;
          },
          child: Column(
            children: [
              const ListPlatform(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: barcodeController,
                          decoration: TextFormDecoration.box(
                            "Masukan No Pesanan",
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // context.read<ShopeeDetailBloc>().add(
                                  //     GetShopeeOrder(barcodeController.text));
                                }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.searchengin,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: ProductCheckerBody())
            ],
          ),
        ),
      ),
    );
  }
}

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
            onPressed: () async {},
          );
        }
        return const Text('Something Wrong');
      }),
    );
  }
}

class ListPlatform extends StatefulWidget {
  const ListPlatform({super.key});

  @override
  State<ListPlatform> createState() => _ListPlatformState();
}

class _ListPlatformState extends State<ListPlatform> {
  List<Platform> platforms = [];
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
                        setState(() {});
                      },
                      backgroundColor: platform.id == state.platform!.id
                          ? DefaultColor.primary
                          : null,
                    ),
                  );
                },
              ),
            ),
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
