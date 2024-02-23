import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/screen/product/bloc/product_bloc.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/screen/product_report/screen/product_form.dart';
import 'package:receipt_online_shop/screen/theme/app_theme.dart';
import 'package:receipt_online_shop/widget/custom_appbar.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: CustomAppbar(
          title: "Produk",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: (state.products ?? []).length,
                    itemBuilder: (c, i) {
                      Product product = (state.products ?? [])[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProductFormScreen(
                                    barcode: product.barcode!,
                                  );
                                },
                              )).then((value) {
                                if (value != null) {
                                  Navigator.pop(context, value);
                                }
                              });
                            },
                            leading: Image.asset("assets/images/logo.png"),
                            title: Text(
                              (product.name ?? '').toUpperCase(),
                              style: const TextStyle(
                                  color: AppTheme.nearlyDarkBlue),
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
                                  "Rp. ${product.price}",
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
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
