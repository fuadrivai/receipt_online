part of 'lazada_bloc.dart';

abstract class LazadaEvent {
  LazadaEvent();
}

class GetFullOder extends LazadaEvent {
  GetFullOder();
}

class GetSingleOrder extends LazadaEvent {
  int orderId;
  GetSingleOrder(this.orderId);
}
