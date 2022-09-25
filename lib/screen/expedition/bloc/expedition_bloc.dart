import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition_api.dart';

part 'expedition_event.dart';
part 'expedition_state.dart';

class ExpeditionBloc extends Bloc<ExpeditionEvent, ExpeditionState> {
  ExpeditionBloc() : super(const ExpeditionState()) {
    on<ExpeditionEvent>((event, emit) async {
      if (event is GetExpedition) {
        emit(const ExpeditionState(isLoading: true));
        ExpeditionState expeditionState = await _getExpedition(event, emit);
        emit(expeditionState);
      }
    });
  }

  Future<ExpeditionState> _getExpedition(
      GetExpedition event, Emitter<ExpeditionState> emit) async {
    try {
      List<Expedition> expeditions = await ExpeditionApi.findAll();
      emit(ExpeditionState(expeditions: expeditions, isLoading: false));
      return state.copyWith(
        expedditions: expeditions,
        isLoading: false,
      );
    } catch (e) {
      emit(const ExpeditionState(isLoading: false));
      return state.copyWith(isLoading: false);
    }
  }
}
