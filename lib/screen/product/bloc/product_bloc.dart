import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/serverside.dart';
import 'package:receipt_online_shop/screen/product/data/product.dart';
import 'package:receipt_online_shop/screen/product/data/product_api.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductState()) {
    on<OnGetProduct>(_onGetProduct);
    on<OnLoadMore>(_onLoadMore);
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
