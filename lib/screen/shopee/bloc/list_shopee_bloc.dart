import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/shopee/shopee_order.dart';
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
      List<ShopeeOrder> listOrder = await ShopeeApi.getOrders();
      emit(ListShopeeData(listOrder));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ListShopeeError(message));
    }
  }
}
