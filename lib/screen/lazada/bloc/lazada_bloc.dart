import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lazada_event.dart';
part 'lazada_state.dart';

class LazadaBloc extends Bloc<LazadaEvent, LazadaState> {
  LazadaBloc() : super(LazadaLoadingState()) {
    on<GetFullOrderEvent>(_getFullOrder);
  }

  void _getFullOrder(GetFullOrderEvent event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      FullOrder fullOrder = await LazadaApi.getOrders();
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }
}
