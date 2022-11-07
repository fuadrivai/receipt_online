import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

part 'platform_event.dart';
part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  final NavigationService _nav = locator<NavigationService>();
  PlatformBloc() : super(PlatformLoading()) {
    on<PlatformSingleOrder>(_getSingleOrder);
    on<PlatformRTS>(_rtsOrder);
  }

  void _getSingleOrder(
      PlatformSingleOrder event, Emitter<PlatformState> emit) async {
    try {
      emit(PlatformLoading());
      emit(PlatformOrder(event.order));
    } catch (e) {
      emit(PlatformError());
    }
  }

  void _rtsOrder(PlatformRTS event, Emitter<PlatformState> emit) async {
    try {
      emit(PlatformLoading());
      TransactionOnline order = event.order;
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
        message: 'Resi ${orderRTS.trackingNumber} Berhasil Direquest',
        duration: const Duration(seconds: 1),
        backgroundColor: DefaultColor.primary,
      ).show(_nav.navKey.currentContext!);
      Navigator.pop(_nav.navKey.currentContext!);
    } catch (e) {
      emit(PlatformError());
    }
  }
}
