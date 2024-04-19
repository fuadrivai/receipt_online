import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/home/data/home_api.dart';

part 'lazada_auth_event.dart';
part 'lazada_auth_state.dart';

class LazadaAuthBloc extends Bloc<LazadaAuthEvent, LazadaAuthState> {
  LazadaAuthBloc() : super(const LazadaAuthState()) {
    on<OnGetLink>(_onGetLink);
  }

  void _onGetLink(OnGetLink event, Emitter<LazadaAuthState> emit) async {
    emit(state.copyWith(loading: true, isError: false));
    try {
      String link = await HomeApi.lazadaAuthLink();
      emit(state.copyWith(loading: false, isError: false, link: link));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }
}
