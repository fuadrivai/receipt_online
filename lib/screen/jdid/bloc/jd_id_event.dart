part of 'jd_id_bloc.dart';

abstract class JdIdEvent extends Equatable {
  const JdIdEvent();
}

class GetJdIdOrder extends JdIdEvent {
  final String orderSn;
  const GetJdIdOrder(this.orderSn);

  @override
  List<Object?> get props => [orderSn];
}

class JdIdStandBy extends JdIdEvent {
  @override
  List<Object?> get props => [];
}

class JdIdRtsEvent extends JdIdEvent {
  final String orderSn;
  const JdIdRtsEvent(this.orderSn);
  @override
  List<Object?> get props => [orderSn];
}
