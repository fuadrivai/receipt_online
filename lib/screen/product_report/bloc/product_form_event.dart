part of 'product_form_bloc.dart';

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();
  @override
  List<Object> get props => [];
}

class OnGetProductByBarcode extends ProductFormEvent {
  final String barcode;
  const OnGetProductByBarcode(this.barcode);
}

class OnInitReportDetail extends ProductFormEvent {
  final ReportDetail detail;
  const OnInitReportDetail(this.detail);
}

class OnChangedAge extends ProductFormEvent {
  final String? val;
  const OnChangedAge(this.val);
}

class OnChangedTaste extends ProductFormEvent {
  final String? val;
  const OnChangedTaste(this.val);
}

class OnChangedSize extends ProductFormEvent {
  final String? val;
  const OnChangedSize(this.val);
}

class OnChangedQty extends ProductFormEvent {
  final int val;
  const OnChangedQty(this.val);
}

class OnChangedQtyCarton extends ProductFormEvent {
  final int val;
  const OnChangedQtyCarton(this.val);
}
