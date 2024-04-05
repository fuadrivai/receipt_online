import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/screen/product/bloc/product_bloc.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ProductScreenSingle extends StatefulWidget {
  const ProductScreenSingle({super.key});

  @override
  State<ProductScreenSingle> createState() => _ProductScreenSingleState();
}

class _ProductScreenSingleState extends State<ProductScreenSingle> {
  Map<String, dynamic> map = {};
  final ScrollController _controller = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    context.read<ProductBloc>().add(OnGetProduct(map));
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        context.read<ProductBloc>().add(const OnLoadMore());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.isLoading ?? true) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: CustomAppbar(
                title: "Produk",
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
            body: const LoadingScreen(),
          );
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: CustomAppbar(
              title: "Produk",
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ProductBloc>().add(OnGetProduct(map));
            },
            child: SingleChildScrollView(
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (value) {
                        map = {"search": searchController.text};
                        context.read<ProductBloc>().add(OnGetProduct(map));
                        setState(() {});
                      },
                      decoration: TextFormDecoration.box(
                        "Produk atau Barcode",
                        suffixIcon: IconButton(
                          onPressed: () {
                            map = {"search": searchController.text};
                            context.read<ProductBloc>().add(OnGetProduct(map));
                            setState(() {});
                          },
                          icon: const Icon(
                            FontAwesomeIcons.searchengin,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: (state.products ?? []).length,
                    itemBuilder: (c, i) {
                      Product product = (state.products ?? [])[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop<Product>(context, product);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                              ),
                            ),
                            child: ListTile(
                              dense: true,
                              title: Text(
                                (product.name ?? '').toUpperCase(),
                                style: const TextStyle(
                                  color: AppTheme.nearlyDarkBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.barcode ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.nearlyDarkBlue
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    "Rp. ${Common.oCcy.format(product.price ?? 0)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.nearlyDarkBlue
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
