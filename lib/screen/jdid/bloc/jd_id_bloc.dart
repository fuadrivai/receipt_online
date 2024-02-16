import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/jdid/data/jdid_api.dart';
import 'package:receipt_online_shop/widget/default_color.dart';

part 'jd_id_event.dart';
part 'jd_id_state.dart';

class JdIdBloc extends Bloc<JdIdEvent, JdIdState> {
  final NavigationService _nav = locator<NavigationService>();
  JdIdBloc() : super(JdIdDetailStandBy()) {
    on<GetJdIdOrder>(_getSingleOrder);
    on<JdIdStandBy>(_jdIdStandBy);
    on<JdIdRtsEvent>(_jdIdRts);
  }

  void _jdIdStandBy(JdIdStandBy event, Emitter<JdIdState> emit) async {
    emit(JdIdDetailStandBy());
  }

  void _getSingleOrder(GetJdIdOrder event, Emitter<JdIdState> emit) async {
    try {
      emit(JdIdDetailLoading());
      TransactionOnline listOrder =
          await JdIdApi.getJdIdOrderByNo(event.orderSn);
      emit(JdIdOrderDetail(listOrder));
    } catch (e) {
      String message =
          e is DioException ? e.response?.data['message'] : e.toString();
      emit(JdIdDetailError(message));
    }
  }

  void _jdIdRts(JdIdRtsEvent event, Emitter<JdIdState> emit) async {
    try {
      emit(JdIdDetailLoading());
      // await JdIdApi.rts(event.orderSn);
      await Flushbar(
        title: 'Berhasil',
        message: 'Berhasil Memanggil Kurir',
        duration: const Duration(seconds: 1),
        backgroundColor: DefaultColor.primary,
      ).show(_nav.navKey.currentContext!);
      TransactionOnline listOrder =
          await JdIdApi.getJdIdOrderByNo(event.orderSn);
      emit(JdIdOrderDetail(listOrder));
    } catch (e) {
      String message =
          e is DioException ? e.response?.data['message'] : e.toString();
      emit(JdIdDetailError(message));
    }
  }
}
