import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';
// import 'package:receipt_online_shop/library/interceptor/injector.dart';
// import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/jdid/data/jdid_api.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';
import 'package:receipt_online_shop/screen/product_checker/data/product_checker_api.dart';
import 'package:receipt_online_shop/screen/shopee/data/shopee_api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

part 'product_checker_event.dart';
part 'product_checker_state.dart';

class ProductCheckerBloc
    extends Bloc<ProductCheckerEvent, ProductCheckerState> {
  final NavigationService _nav = locator<NavigationService>();
  ProductCheckerBloc() : super(ProductCheckerInitialState()) {
    on<ProductCheckerStandByEvent>(_standBy);
    on<ProductCheckerOnTabEvent>(_onTabPlatform);
    on<GetOrderEvent>(_getOrder);
    on<RtsEvent>(_rts);
  }

  void _standBy(ProductCheckerStandByEvent event,
      Emitter<ProductCheckerState> emit) async {
    try {
      emit(ProductCheckerLoadingState());
      List<Platform> platforms = await ProductCheckerApi.getPlatforms();
      Platform platform = platforms.isEmpty ? Platform() : platforms[0];
      // emit(ProductCheckerDataState(platforms: platforms));
      emit(
          ProductCheckerStandByState(platforms: platforms, platform: platform));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ProductCheckerErrorState(message: message));
    }
  }

  void _onTabPlatform(
      ProductCheckerOnTabEvent event, Emitter<ProductCheckerState> emit) async {
    try {
      emit(ProductCheckerStandByState(
          platform: event.platform, platforms: event.platforms));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ProductCheckerErrorState(message: message));
    }
  }

  void _getOrder(GetOrderEvent event, Emitter<ProductCheckerState> emit) async {
    emit(ProductCheckerLoadingState());
    List<Platform> platforms = await ProductCheckerApi.getPlatforms();
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
        default:
      }
      emit(ProductCheckerDataState(
        platforms: platforms,
        platform: event.platform,
        data: listTrans,
      ));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ProductCheckerErrorState(
        message: message,
        platforms: platforms,
        platform: event.platform,
      ));
    }
  }

  void _rts(RtsEvent event, Emitter<ProductCheckerState> emit) async {
    emit(ProductCheckerLoadingState());
    List<Platform> platforms = await ProductCheckerApi.getPlatforms();
    try {
      List<TransactionOnline> listTrans = [];
      TransactionOnline order = event.dataOrder;
      switch (event.platform.name?.toLowerCase()) {
        case "lazada":
          List<int> orderItemIds = [];
          for (Items e in (order.items ?? [])) {
            orderItemIds.add(e.orderItemId!);
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
      emit(ProductCheckerDataState(
        platforms: platforms,
        platform: event.platform,
        data: listTrans,
      ));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ProductCheckerErrorState(
        message: message,
        platforms: platforms,
        platform: event.platform,
      ));
    }
  }
}
