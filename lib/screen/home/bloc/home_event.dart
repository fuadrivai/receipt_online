part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetData extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class OnChangeExpedition extends HomeEvent {
  final Expedition expedition;
  const OnChangeExpedition(this.expedition);

  @override
  List<Object?> get props => [expedition];
}

class OnChangeTotal extends HomeEvent {
  final int totalPackage;
  const OnChangeTotal(this.totalPackage);

  @override
  List<Object?> get props => [totalPackage];
}

class OnSaveDailyTask extends HomeEvent {
  @override
  List<Object?> get props => [];
}
