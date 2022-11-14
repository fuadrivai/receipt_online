import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:receipt_online_shop/model/shopee/logistic.dart';
import 'package:receipt_online_shop/screen/shopee/bloc/list_shopee_bloc.dart';
import 'package:receipt_online_shop/screen/shopee/bloc/shopee_bloc.dart';
import 'package:receipt_online_shop/widget/custom_badge.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/shopee_list_view.dart';
import 'package:receipt_online_shop/widget/shopee_widget_screen.dart';

class ShopeeScreen extends StatefulWidget {
  const ShopeeScreen({super.key});

  @override
  State<ShopeeScreen> createState() => _ShopeeScreenState();
}

class _ShopeeScreenState extends State<ShopeeScreen> {
  int totalOrder = 0;
  late bool visible;
  List<LogisticChannel> logistic = [];
  TextEditingController receiptController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ShopeeWidgetScreen(
      appbarTitle: "Shopee List Order ($totalOrder)",
      showAction: false,
      onInit: () => context.read<ListShopeeBloc>().add(GetListShopeeOrder()),
      onScannBarcode: (value) {},
      textTitle: "Scann Barcode Resi",
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ListShopeeBloc>().add(GetListShopeeOrder());
        },
        child: BlocBuilder<ListShopeeBloc, ListShopeeState>(
          builder: (__, state) {
            if (state is ListShopeeLoading) {
              return const LoadingScreen();
            }
            if (state is ListShopeeData) {
              totalOrder = state.listOrder.length;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.listLogisticChannel.length,
                        itemBuilder: (__, i) {
                          LogisticChannel channel =
                              state.listLogisticChannel[i];
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CustomeBadge(
                              text: "${channel.name} (${channel.totalOrder})",
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                      child: ShopeeListView(
                    orders: state.listOrder,
                    onPressed: () async {
                      if (await confirm(
                        context,
                        content: const Text('Yakin Ingin Memanggil Kurir'),
                        textOK: const Text('Panggil'),
                        textCancel: const Text('Kembali'),
                      )) {
                        context
                            .read<ShopeeDetailBloc>()
                            .add(ShopeeRtsEvent(state.listOrder[0].orderNo!));
                      }
                    },
                  )),
                ],
              );
            }
            if (state is ListShopeeError) {
              return Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints:
                      const BoxConstraints(minHeight: 300, maxHeight: 300),
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
            return const Text('error');
          },
        ),
      ),
    );
  }
}
