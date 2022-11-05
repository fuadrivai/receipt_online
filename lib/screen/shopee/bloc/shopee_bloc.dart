import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
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
      List<TransactionOnline> listOrder =
          await ShopeeApi.getShopeeOrderByNo(event.orderSn);
      emit(ShopeeOrderDetail(listOrder));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ShopeeDetailError(message));
    }
  }
}
