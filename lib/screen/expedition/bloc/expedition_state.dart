part of 'expedition_bloc.dart';

class ExpeditionState extends Equatable {
  final Expedition? expedition;
  final List<Expedition>? expeditions;
  final bool isLoading;

  const ExpeditionState({
    this.expedition,
    this.expeditions,
    this.isLoading = false,
  });

  ExpeditionState copyWith({
    expedition,
    expedditions,
    isLoading,
  }) {
    return ExpeditionState(
      expedition: expedition ?? this.expedition,
      expeditions: expeditions,
      isLoading: isLoading ?? this.isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [
        expedition,
        expeditions,
        isLoading,
      ];
}
