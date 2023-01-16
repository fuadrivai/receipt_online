import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/tiktok/data/tiktok_api.dart';

part 'tiktok_event.dart';
part 'tiktok_state.dart';

class TiktokBloc extends Bloc<TiktokEvent, TiktokState> {
  TiktokBloc() : super(TiktokLoadingState()) {
    on<GetOrders>(_onGetOrders);
  }

  void _onGetOrders(GetOrders event, Emitter<TiktokState> emit) async {
    try {
      emit(TiktokLoadingState());
      List<TransactionOnline> transactions = await TiktokApi.getorders();
      emit(TiktokFullOrderState(transactions));
    } catch (e) {
      emit(TiktokErrorState());
    }
  }
}
