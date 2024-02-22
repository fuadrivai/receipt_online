import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/screen/product/data/product_api.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc() : super(const ProductFormState()) {
    on<OnGetProductByBarcode>(_onGetProduct);
    on<OnChangedAge>(_onChangedAge);
    on<OnChangedTaste>(_onChangedTaste);
    on<OnChangedSize>(_onChangedSize);
    on<OnChangedQty>(_onChangedQty);
    on<OnChangedQtyCarton>(_onChangedQtyCarton);
  }

  void _onChangedQtyCarton(
      OnChangedQtyCarton event, Emitter<ProductFormState> emit) {
    ReportDetail detail = state.detail ?? ReportDetail();
    detail.qtyCarton = event.val;
    if (detail.qtyCarton == 0) {
      detail.totalCarton = 0;
    } else {
      if (detail.qty == 0) {
        detail.totalCarton = 0;
      } else {
        detail.totalCarton =
            ((detail.qty ?? 0) / (detail.qtyCarton ?? 0)).floor();
      }
    }
    emit(state.copyWith(detail: detail));
  }

  void _onChangedQty(OnChangedQty event, Emitter<ProductFormState> emit) {
    ReportDetail detail = state.detail ?? ReportDetail();
    detail.qty = event.val;
    if (detail.qty == 0) {
      detail.totalCarton = 0;
      detail.subTotal = 0;
    } else {
      if (detail.qtyCarton == 0) {
        detail.totalCarton = 0;
      } else {
        detail.totalCarton = (event.val / (detail.qtyCarton ?? 0)).floor();
      }
      detail.subTotal =
          ((detail.product?.price ?? 0) * (detail.qty ?? 0)).toDouble();
    }
    emit(state.copyWith(detail: detail));
  }

  void _onChangedSize(OnChangedSize event, Emitter<ProductFormState> emit) {
    ReportDetail detail = state.detail ?? ReportDetail();
    detail.size = event.val;
    emit(state.copyWith(detail: detail));
  }

  void _onChangedAge(OnChangedAge event, Emitter<ProductFormState> emit) {
    ReportDetail detail = state.detail ?? ReportDetail();
    detail.age = event.val;
    emit(state.copyWith(detail: detail));
  }

  void _onChangedTaste(OnChangedTaste event, Emitter<ProductFormState> emit) {
    ReportDetail detail = state.detail ?? ReportDetail();
    detail.taste = event.val;
    emit(state.copyWith(detail: detail));
  }

  void _onGetProduct(
      OnGetProductByBarcode event, Emitter<ProductFormState> emit) async {
    emit(state.copyWith(isLoading: true, detail: ReportDetail()));
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
