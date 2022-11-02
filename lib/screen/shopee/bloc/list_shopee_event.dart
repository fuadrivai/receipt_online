part of 'list_shopee_bloc.dart';

abstract class ListShopeeEvent extends Equatable {
  const ListShopeeEvent();
}

class GetListShopeeOrder extends ListShopeeEvent {
  @override
  List<Object?> get props => [];
}
