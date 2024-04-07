import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/model/receipt_detail_product.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/jdid/data/jdid_api.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/screen/product_checker/data/product_checker_api.dart';
import 'package:receipt_online_shop/screen/shopee/data/shopee_api.dart';
import 'package:receipt_online_shop/screen/tiktok/data/tiktok_api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

part 'product_checker_event.dart';
part 'product_checker_state.dart';

class ProductCheckerBloc
    extends Bloc<ProductCheckerEvent, ProductCheckerState> {
  final NavigationService _nav = locator<NavigationService>();
  ProductCheckerBloc() : super(const ProductCheckerState()) {
    on<ProductCheckerStandByEvent>(_standBy);
    on<ProductCheckerOnTabEvent>(_onTabPlatform);
    on<GetOrderEvent>(_getOrder);
    on<RtsEvent>(_rts);
    on<CreateOrderEvent>(_createOrder);
    on<OnInputGift>(_onInputGift);
    on<OnInputProduct>(_onInputProduct);
    on<OnChangeQtyProduct>(_onChangeQtyProduct);
    on<OnRemoveProduct>(_onRemoveProduct);
    on<OnRemoveGift>(_onRemoveGift);
  }

  void _standBy(ProductCheckerStandByEvent event,
      Emitter<ProductCheckerState> emit) async {
    try {
      emit(state.copyWith(
          isLoading: true, isError: false, data: [], platform: Platform()));
      List<Platform> platforms = await ProductCheckerApi.getActivePlatform();
      Platform platform = platforms.isEmpty ? Platform() : platforms[0];

      emit(state.copyWith(
        platforms: platforms,
        platform: platform,
        isLoading: false,
        isError: false,
      ));
    } catch (e) {
      String message =
          e is DioException ? e.response?.data['message'] : e.toString();
      emit(state.copyWith(
        errorMessage: message,
        isLoading: false,
        isError: true,
      ));
    }
  }

  void _onTabPlatform(
      ProductCheckerOnTabEvent event, Emitter<ProductCheckerState> emit) async {
    emit(state.copyWith(
      platform: event.platform,
      data: [],
      isError: false,
    ));
  }

  void _onInputProduct(
      OnInputProduct event, Emitter<ProductCheckerState> emit) async {
    List<TransactionOnline> trans = state.data ?? [];
    for (TransactionOnline e in trans) {
      for (Items item in (e.items ?? [])) {
        if (item.itemSku == event.item.itemSku) {
          if (item.manuals == null) {
            List<ReceiptDetailProduct> manuals = [];
            ReceiptDetailProduct detail = ReceiptDetailProduct();
            detail.qty = 1;
            detail.product = event.product;
            manuals.add(detail);
            item.manuals = manuals;
          } else {
            ReceiptDetailProduct detail = ReceiptDetailProduct();
            detail.qty = 1;
            detail.product = event.product;
            item.manuals!.add(detail);
          }
        }
      }
    }
    emit(state.copyWith(
      data: trans,
      isError: false,
    ));
  }

  void _onChangeQtyProduct(
      OnChangeQtyProduct event, Emitter<ProductCheckerState> emit) async {
    List<TransactionOnline> trans = state.data ?? [];
    for (TransactionOnline e in trans) {
      for (Items item in (e.items ?? [])) {
        if (item.itemSku == event.item.itemSku) {
          for (ReceiptDetailProduct m in (item.manuals ?? [])) {
            if (m.product?.barcode == event.barcode) {
              m.qty = event.qty;
            }
          }
        }
      }
    }
    emit(state.copyWith(
      data: trans,
      isError: false,
    ));
  }

  void _onInputGift(
      OnInputGift event, Emitter<ProductCheckerState> emit) async {
    List<TransactionOnline> trans = state.data ?? [];
    for (TransactionOnline e in trans) {
      for (Items item in (e.items ?? [])) {
        if (item.itemSku == event.item.itemSku) {
          if (item.gifts == null) {
            List<ReceiptDetailProduct> gifts = [];
            ReceiptDetailProduct detail = ReceiptDetailProduct();
            detail.qty = 1;
            detail.product = event.product;
            gifts.add(detail);
            item.gifts = gifts;
          } else {
            ReceiptDetailProduct detail = ReceiptDetailProduct();
            detail.qty = 1;
            detail.product = event.product;
            item.gifts!.add(detail);
          }
        }
      }
    }
    emit(state.copyWith(
      data: trans,
      isError: false,
    ));
  }

  void _onRemoveGift(
      OnRemoveGift event, Emitter<ProductCheckerState> emit) async {
    List<TransactionOnline> trans = state.data ?? [];
    for (TransactionOnline e in trans) {
      for (Items item in (e.items ?? [])) {
        if (item.itemSku == event.item.itemSku) {
          item.gifts!.removeWhere((m) => m.product?.barcode == event.barcode);
        }
      }
    }
    emit(state.copyWith(
      data: trans,
      isError: false,
    ));
  }

  void _onRemoveProduct(
      OnRemoveProduct event, Emitter<ProductCheckerState> emit) async {
    List<TransactionOnline> trans = state.data ?? [];
    for (TransactionOnline e in trans) {
      for (Items item in (e.items ?? [])) {
        if (item.itemSku == event.item.itemSku) {
          item.manuals!.removeWhere((m) => m.product?.barcode == event.barcode);
        }
      }
    }
    emit(state.copyWith(
      data: trans,
      isError: false,
    ));
  }

  void _getOrder(GetOrderEvent event, Emitter<ProductCheckerState> emit) async {
    emit(state.copyWith(isLoading: true, isError: false));
    try {
      List<TransactionOnline> listTrans = [];
      switch (event.platform.name?.toLowerCase()) {
        case "lazada":
          TransactionOnline trans = await LazadaApi.getOrder(event.orderSn);
          listTrans = [trans];
          break;
        case "jdid":
          TransactionOnline trans =
              await JdIdApi.getJdIdOrderByNo(event.orderSn);
          listTrans = [trans];
          break;
        case "shopee":
          List<TransactionOnline> trans =
              await ShopeeApi.getShopeeOrderByNo(event.orderSn);
          listTrans = trans;
          break;
        case "tiktok":
          List<String> ordersn = [event.orderSn];
          List<TransactionOnline> trans =
              await TiktokApi.getorder(ordersn.join(","));
          listTrans = trans;
          break;
        default:
      }

      for (var order in listTrans) {
        List<Items> listItem = [];
        (order.items ?? []).sort(
            (a, b) => (b.orderStatus ?? "").compareTo(a.orderStatus ?? ""));
        for (Items e in (order.items ?? [])) {
          bool isExis = listItem.any((el) =>
              (el.skuId == e.skuId) && (el.orderStatus == e.orderStatus));
          if (isExis) {
            if (e.skuId == null) {
              listItem.add(e);
            } else {
              listItem
                  .where((elm) =>
                      (elm.skuId == e.skuId) &&
                      (elm.orderStatus == e.orderStatus))
                  .toList()
                  .forEach((elm) => elm.qty = elm.qty! + 1);
            }
          } else {
            listItem.add(e);
          }
        }
        order.items = listItem;
      }
      List<List<bool>> expands = [];
      for (TransactionOnline e in listTrans) {
        for (var i = 0; i < (e.items ?? []).length; i++) {
          Items item = (e.items ?? [])[i];
          List<bool> listManual = [];
          listManual.add((item.manuals ?? []).isEmpty ? false : true);
          listManual.add((item.gifts ?? []).isEmpty ? false : true);
          expands.add(listManual);
        }
      }

      emit(state.copyWith(
        platform: event.platform,
        data: listTrans,
        isLoading: false,
        listManual: expands,
      ));
    } catch (e) {
      String message =
          e is DioException ? e.response?.data['message'] : e.toString();
      emit(state.copyWith(
        errorMessage: message,
        isError: true,
        isLoading: false,
        data: state.data,
        platform: state.platform,
      ));
    }
  }

  void _createOrder(
      CreateOrderEvent event, Emitter<ProductCheckerState> emit) async {
    try {
      TransactionOnline order = event.dataOrder;
      switch (event.platform.name?.toLowerCase()) {
        case "lazada":
          print(
              "${event.platform.name?.toLowerCase()} , ${order.trackingNumber}");
          break;
        case "jdid":
          print(
              "${event.platform.name?.toLowerCase()} , ${order.trackingNumber}");
          break;
        case "shopee":
          print(
              "${event.platform.name?.toLowerCase()} , ${order.trackingNumber}");
          break;
        case "tiktok":
          print(
              "${event.platform.name?.toLowerCase()} , ${order.trackingNumber}");
          break;
        default:
      }
    } catch (e) {
      // String message =
      //     e is DioException ? e.response?.data['message'] : e.toString();
      // emit(ProductCheckerErrorState(
      //   message: message,
      //   platforms: platforms,
      //   platform: event.platform,
      // ));
    }
  }

  void _rts(RtsEvent event, Emitter<ProductCheckerState> emit) async {
    emit(state.copyWith(isLoading: true, isError: false));
    try {
      List<TransactionOnline> listTrans = [];
      TransactionOnline order = event.dataOrder;
      switch (event.platform.name?.toLowerCase()) {
        case "lazada":
          List<int> orderItemIds = [];
          for (Items e in (order.items ?? [])) {
            if (e.orderStatus != "BATAL") {
              orderItemIds.add(e.orderItemId!);
            }
          }
          OrderRTS orderRTS = OrderRTS(
            deliveryType: 'dropship',
            orderItemIds: orderItemIds,
            trackingNumber: order.trackingNumber,
            shipmentProvider: order.deliveryBy,
          );
          await LazadaApi.orderRts(orderRTS);
          await Flushbar(
            title: 'Berhasil',
            message: 'Nomor Pesanan ${order.orderNo} Berhasil RTS',
            duration: const Duration(seconds: 1),
            backgroundColor: DefaultColor.primary,
          ).show(_nav.navKey.currentContext!);
          TransactionOnline newOrder = await LazadaApi.getOrder(order.orderId!);
          listTrans = [newOrder];
          break;
        case "jdid":
          await JdIdApi.rts(order.orderNo!);
          await Flushbar(
            title: 'Berhasil',
            message: 'Berhasil Memanggil Kurir',
            duration: const Duration(seconds: 1),
            backgroundColor: DefaultColor.primary,
          ).show(_nav.navKey.currentContext!);
          TransactionOnline trans =
              await JdIdApi.getJdIdOrderByNo(order.orderNo!);
          listTrans = [trans];
          break;
        case "shopee":
          await ShopeeApi.rts(order.orderNo!);
          await Flushbar(
            title: 'Berhasil',
            message: 'Berhasil Memanggil Kurir',
            duration: const Duration(seconds: 1),
            backgroundColor: DefaultColor.primary,
          ).show(_nav.navKey.currentContext!);
          listTrans = await ShopeeApi.getShopeeOrderByNo(order.orderNo!);
          break;
        default:
      }
      emit(state.copyWith(
        isLoading: false,
        isError: false,
        data: listTrans,
      ));
    } catch (e) {
      String message =
          e is DioException ? e.response?.data['message'] : e.toString();
      emit(state.copyWith(
        errorMessage: message,
        platforms: state.platforms,
        platform: event.platform,
        data: state.data,
        isLoading: false,
        isError: true,
      ));
    }
  }
}
