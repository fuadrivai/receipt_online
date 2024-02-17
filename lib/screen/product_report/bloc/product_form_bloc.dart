import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/product_report/data/product.dart';
import 'package:receipt_online_shop/screen/product_report/data/product_api.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc() : super(const ProductFormState()) {
    on<OnGetProduct>(_onGetProduct);
  }

  void _onGetProduct(OnGetProduct event, Emitter<ProductFormState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      Product product = await ProductApi.getByBarcode(event.barcode);
      ReportDetail detail = state.detail ?? ReportDetail();
      detail.product = product;
      emit(state.copyWith(isLoading: false, detail: detail));
    } catch (e) {
      String message =
          e is DioException ? e.response?.data['message'] : e.toString();
      emit(state.copyWith(
        isLoading: false,
        detail: state.detail,
        isError: true,
        errorMessage: message,
      ));
    }
  }
}
