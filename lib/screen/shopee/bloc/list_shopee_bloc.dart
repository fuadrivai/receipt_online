import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/shopee/logistic.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/shopee/data/shopee_api.dart';

part 'list_shopee_event.dart';
part 'list_shopee_state.dart';

class ListShopeeBloc extends Bloc<ListShopeeEvent, ListShopeeState> {
  // final NavigationService _nav = locator<NavigationService>();
  ListShopeeBloc() : super(ListShopeeLoading()) {
    on<GetListShopeeOrder>(_getOrders);
  }

  void _getOrders(
      GetListShopeeOrder event, Emitter<ListShopeeState> emit) async {
    try {
      emit(ListShopeeLoading());
      List<TransactionOnline> listOrder = await ShopeeApi.getOrders();
      List<LogisticChannel> logistics = [];
      for (TransactionOnline order in listOrder) {
        LogisticChannel exitingChannel = logistics.firstWhere(
            (data) => data.name == order.pickupBy,
            orElse: () => LogisticChannel());
        if (exitingChannel.name == null) {
          LogisticChannel logistic =
              LogisticChannel(name: order.pickupBy, totalOrder: 1);
          logistics.add(logistic);
        } else {
          exitingChannel.totalOrder = exitingChannel.totalOrder! + 1;
        }
      }
      emit(ListShopeeData(listOrder, logistics));
    } catch (e) {
      String message =
          e is DioException ? e.response?.data['message'] : e.toString();
      emit(ListShopeeError(message));
    }
  }
}
