import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/lazada/order.dart';
import 'package:receipt_online_shop/model/lazada/order_rts.dart';

part 'platform_event.dart';
part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
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
      OrderRTS orderRTS = event.orderRts;
      print(orderRTS);
    } catch (e) {
      emit(PlatformError());
    }
  }
}
