import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/shopee/data/shopee_api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

part 'shopee_event.dart';
part 'shopee_state.dart';

class ShopeeDetailBloc extends Bloc<ShopeeDetailEvent, ShopeeDetailState> {
  final NavigationService _nav = locator<NavigationService>();
  ShopeeDetailBloc() : super(ShopeeDetailStandBy()) {
    on<GetShopeeOrder>(_getSingleOrder);
    on<ShopeeStandBy>(_shopeeStandBy);
    on<ShopeeRtsEvent>(_shopeeRts);
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

  void _shopeeRts(ShopeeRtsEvent event, Emitter<ShopeeDetailState> emit) async {
    try {
      emit(ShopeeDetailLoading());
      await ShopeeApi.rts(event.orderSn);
      await Flushbar(
        title: 'Berhasil',
        message: 'Berhasil Memanggil Kurir',
        duration: const Duration(seconds: 1),
        backgroundColor: DefaultColor.primary,
      ).show(_nav.navKey.currentContext!);
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
