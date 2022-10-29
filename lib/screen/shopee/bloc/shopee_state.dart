part of 'shopee_bloc.dart';

abstract class ShopeeState extends Equatable {
  const ShopeeState();
  
  @override
  List<Object> get props => [];
}

class ShopeeInitial extends ShopeeState {}
