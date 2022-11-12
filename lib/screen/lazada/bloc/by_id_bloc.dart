import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

part 'by_id_event.dart';
part 'by_id_state.dart';

class ByIdBloc extends Bloc<ByIdEvent, ByIdState> {
  final NavigationService _nav = locator<NavigationService>();
  ByIdBloc() : super(ByIdDetailStandBy()) {
    on<GetOrderById>(_getSingleOrder);
    on<LazadaStandBy>(_lazadaStandBy);
    on<LazadaRtsEvent>(_lazadaRts);
  }

  void _lazadaStandBy(LazadaStandBy event, Emitter<ByIdState> emit) async {
    emit(ByIdDetailStandBy());
  }

  void _getSingleOrder(GetOrderById event, Emitter<ByIdState> emit) async {
    try {
      emit(ByIdDetailLoading());
      TransactionOnline listOrder = await LazadaApi.getOrder(event.orderSn);
      emit(ByIdOrderDetail(listOrder));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ByIdDetailError(message));
    }
  }

  void _lazadaRts(LazadaRtsEvent event, Emitter<ByIdState> emit) async {
    try {
      emit(ByIdDetailLoading());
      TransactionOnline order = event.data;
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
        message: 'Nomor Pesanan ${event.data.orderNo} Berhasil RTS',
        duration: const Duration(seconds: 1),
        backgroundColor: DefaultColor.primary,
      ).show(_nav.navKey.currentContext!);
      TransactionOnline newOrder =
          await LazadaApi.getOrder(event.data.orderId!);
      emit(ByIdOrderDetail(newOrder));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ByIdDetailError(message));
    }
  }
}
