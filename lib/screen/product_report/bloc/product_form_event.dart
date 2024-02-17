part of 'product_form_bloc.dart';

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();
  @override
  List<Object> get props => [];
}

class OnGetProduct extends ProductFormEvent {
  final String barcode;
  const OnGetProduct(this.barcode);
}
