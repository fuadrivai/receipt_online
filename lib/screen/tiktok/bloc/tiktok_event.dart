part of 'tiktok_bloc.dart';

abstract class TiktokEvent extends Equatable {
  const TiktokEvent();
}

class GetOrders extends TiktokEvent {
  const GetOrders();
  @override
  List<Object?> get props => [];
}
