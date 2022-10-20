import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/library/seesion_manager.dart';
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
    on<OnChangeSortingEvent>(_onChangeSorting);
    on<OnRefresh>(_onRefresh);
  }

  void _onRefresh(OnRefresh event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      FullOrder fullOrder = FullOrder();
      String sorting = await Session.get("sorting") ?? "DESC";
      switch (event.tab) {
        case 0:
          fullOrder = await LazadaApi.getPendingOrder(sorting);
          break;
        case 1:
          fullOrder = await LazadaApi.getPackedOrder(sorting);
          break;
        case 2:
          fullOrder = await LazadaApi.getRtsOrder(sorting);
          break;
        default:
          fullOrder = await LazadaApi.getPackedOrder(sorting);
          break;
      }
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _onChangeSorting(
      OnChangeSortingEvent event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      FullOrder fullOrder = FullOrder();
      Session.set("sorting", event.sorting);
      switch (event.tab) {
        case 0:
          fullOrder = await LazadaApi.getPendingOrder(event.sorting);
          break;
        case 1:
          fullOrder = await LazadaApi.getPackedOrder(event.sorting);
          break;
        case 2:
          fullOrder = await LazadaApi.getRtsOrder(event.sorting);
          break;
        default:
          fullOrder = await LazadaApi.getPackedOrder(event.sorting);
          break;
      }
      emit(LazadaOnChangeState(event.sorting, event.tab));
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _getPacked(GetPacked event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      String sorting = await Session.get("sorting") ?? "DESC";
      FullOrder fullOrder = await LazadaApi.getPackedOrder(sorting);
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _getRts(GetRts event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      String sorting = await Session.get("sorting") ?? "DESC";
      FullOrder fullOrder = await LazadaApi.getRtsOrder(sorting);
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }

  void _getPending(GetPending event, Emitter<LazadaState> emit) async {
    try {
      emit(LazadaLoadingState());
      String sorting = await Session.get("sorting") ?? "DESC";
      FullOrder fullOrder = await LazadaApi.getPendingOrder(sorting);
      emit(LazadaFullOrderState(fullOrder));
    } catch (e) {
      emit(LazadaErrorState());
    }
  }
}
