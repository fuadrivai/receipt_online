import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/product_checker/data/product_checker_api.dart';

part 'product_checker_event.dart';
part 'product_checker_state.dart';

class ProductCheckerBloc
    extends Bloc<ProductCheckerEvent, ProductCheckerState> {
  ProductCheckerBloc() : super(ProductCheckerInitialState()) {
    on<ProductCheckerStandByEvent>(_standBy);
  }

  void _standBy(ProductCheckerStandByEvent event,
      Emitter<ProductCheckerState> emit) async {
    try {
      emit(ProductCheckerLoadingState());
      List<Platform> platforms = await ProductCheckerApi.getPlatforms();
      // emit(ProductCheckerDataState(platforms: platforms));
      emit(ProductCheckerStandByState(platforms: platforms));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ProductCheckerErrorState(message));
    }
  }
}
