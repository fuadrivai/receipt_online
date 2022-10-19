import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/model/lazada/full_order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/lazada/data/lazada_api.dart';

part 'lazada_event.dart';
part 'lazada_state.dart';

class LazadaBloc extends Bloc<LazadaEvent, LazadaState> {
  LazadaBloc() : super(LazadaLoadingState()) {
    on<GetPacked>(_getPacked);
    on<GetRts>(_getRts);
    on<GetPending>(_getPending);
  }

  void _getPacked(GetPacked event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      FullOrder fullOrder = await LazadaApi.getPackedOrder();
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _getRts(GetRts event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      FullOrder fullOrder = await LazadaApi.getRtsOrder();
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _getPending(GetPending event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      FullOrder fullOrder = await LazadaApi.getPendingOrder();
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }
}
