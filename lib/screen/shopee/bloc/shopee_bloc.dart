import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:receipt_online_shop/library/interceptor/injector.dart';
// import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/shopee/shopee_order.dart';
import 'package:receipt_online_shop/screen/shopee/data/shopee_api.dart';

part 'shopee_event.dart';
part 'shopee_state.dart';

class ShopeeDetailBloc extends Bloc<ShopeeDetailEvent, ShopeeDetailState> {
  // final NavigationService _nav = locator<NavigationService>();
  ShopeeDetailBloc() : super(ShopeeDetailStandBy()) {
    on<GetShopeeOrder>(_getSingleOrder);
    on<ShopeeStandBy>(_shopeeStandBy);
  }

  void _shopeeStandBy(
      ShopeeStandBy event, Emitter<ShopeeDetailState> emit) async {
    emit(ShopeeDetailStandBy());
  }

  void _getSingleOrder(
      GetShopeeOrder event, Emitter<ShopeeDetailState> emit) async {
    try {
      emit(ShopeeDetailLoading());
      List<ShopeeOrder> listOrder =
          await ShopeeApi.getShopeeOrderByNo(event.orderSn);
      emit(ShopeeOrderDetail(listOrder));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ShopeeDetailError(message));
    }
  }
}
