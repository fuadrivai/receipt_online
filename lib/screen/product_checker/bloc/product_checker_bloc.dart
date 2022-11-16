import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:receipt_online_shop/library/interceptor/injector.dart';
// import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/platform.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/product_checker/data/product_checker_api.dart';

part 'product_checker_event.dart';
part 'product_checker_state.dart';

class ProductCheckerBloc
    extends Bloc<ProductCheckerEvent, ProductCheckerState> {
  // final NavigationService _nav = locator<NavigationService>();
  ProductCheckerBloc() : super(ProductCheckerInitialState()) {
    on<ProductCheckerStandByEvent>(_standBy);
    on<ProductCheckerOnTabEvent>(_onTabPlatform);
  }

  void _standBy(ProductCheckerStandByEvent event,
      Emitter<ProductCheckerState> emit) async {
    try {
      emit(ProductCheckerLoadingState());
      List<Platform> platforms = await ProductCheckerApi.getPlatforms();
      Platform platform = platforms.isEmpty ? Platform() : platforms[0];
      // emit(ProductCheckerDataState(platforms: platforms));
      emit(
          ProductCheckerStandByState(platforms: platforms, platform: platform));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ProductCheckerErrorState(message));
    }
  }

  void _onTabPlatform(
      ProductCheckerOnTabEvent event, Emitter<ProductCheckerState> emit) async {
    try {
      emit(ProductCheckerStandByState(
          platform: event.platform, platforms: event.platforms));
    } catch (e) {
      String message =
          e is DioError ? e.response?.data['message'] : e.toString();
      emit(ProductCheckerErrorState(message));
    }
  }
}