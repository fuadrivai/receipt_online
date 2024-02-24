import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/serverside.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/screen/product/data/product_api.dart';
import 'package:receipt_online_shop/screen/product_report/data/report_detail.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<OnGetProduct>(_onGetProduct);
    on<OnLoadMore>(_onLoadMore);
    on<OnTapProduct>(_onTapProduct);
  }

  void _onTapProduct(OnTapProduct event, Emitter<ProductState> emit) {
    List<ReportDetail> details = state.details ?? [];
    if (event.value) {
      ReportDetail detail = ReportDetail();
      String productName = (event.product.name ?? "").toLowerCase();
      if (productName.contains("chil go")) {
        detail.age = productName.contains("1+")
            ? "1+"
            : productName.contains("3+")
                ? "3+"
                : null;
        detail.taste = productName.contains("vanila")
            ? "vanila"
            : productName.contains("madu")
                ? "madu"
                : null;
        detail.size = productName.contains("1kg")
            ? "1 KG"
            : productName.contains("700gr")
                ? "700gr"
                : productName.contains("300g")
                    ? "300gr"
                    : null;
      }
      detail.product = event.product;
      detail.qty = 1;
      detail.qtyCarton = 1;
      detail.totalCarton =
          ((detail.qty ?? 0) / (detail.qtyCarton ?? 0)).floor();
      detail.subTotal =
          ((detail.qty ?? 0) * (event.product.price ?? 0)).toDouble();
      detail.isChecked = false;
      details.add(detail);
    } else {
      details.removeWhere((e) => e.product?.barcode == event.product.barcode);
    }
    emit(state.copyWith(details: details));
  }

  void _onGetProduct(OnGetProduct event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoading: true));
    ServerSide serverSide = await ProductApi.get(params: event.map);
    List<Product> products = [];
    for (var v in (serverSide.data ?? [])) {
      products.add(Product.fromJson(v));
    }
    emit(state.copyWith(
      isLoading: false,
      serverSide: serverSide,
      products: products,
    ));
  }

  void _onLoadMore(OnLoadMore event, Emitter<ProductState> emit) async {
    if (state.serverSide?.nextPageUrl != null) {
      emit(state.copyWith(loadMore: true));
      Map<String, dynamic> params = {};
      var url = Uri.parse(state.serverSide!.nextPageUrl!);
      List<String> listParam = url.query.split("&");
      for (var v in listParam) {
        params[v.split("=")[0]] = v.split("=")[1];
      }
      ServerSide serverSide = await ProductApi.get(params: params);
      List<Product> products = state.products ?? [];
      for (var v in (serverSide.data ?? [])) {
        products.add(Product.fromJson(v));
      }
      emit(state.copyWith(
        serverSide: serverSide,
        products: products,
        loadMore: false,
      ));
    } else {
      emit(state.copyWith(loadMore: false));
    }
  }
}
