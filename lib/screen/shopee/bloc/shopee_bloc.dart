import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shopee_event.dart';
part 'shopee_state.dart';

class ShopeeBloc extends Bloc<ShopeeEvent, ShopeeState> {
  ShopeeBloc() : super(ShopeeInitial()) {
    on<ShopeeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
