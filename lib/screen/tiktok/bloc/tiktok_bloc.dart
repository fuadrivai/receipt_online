import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/library/common.dart';
import 'package:receipt_online_shop/library/interceptor/injector.dart';
import 'package:receipt_online_shop/library/interceptor/navigation_service.dart';
import 'package:receipt_online_shop/model/transaction_online.dart';
import 'package:receipt_online_shop/screen/tiktok/data/tiktok_api.dart';

part 'tiktok_event.dart';
part 'tiktok_state.dart';

class TiktokBloc extends Bloc<TiktokEvent, TiktokState> {
  final NavigationService _nav = locator<NavigationService>();
  TiktokBloc() : super(TiktokLoadingState()) {
    on<GetOrders>(_onGetOrders);
    on<GetOrder>(_onGetOrder);
    on<OnTapScanned>(_onTapScanned);
  }

  void _onTapScanned(OnTapScanned event, Emitter<TiktokState> emit) async {
    try {
      final state =
          BlocProvider.of<TiktokBloc>(_nav.navKey.currentContext!).state;
      List<TransactionOnline> transactions = [];
      List<TransactionOnline> tempTransactions = [];
      if (state is TiktokFullOrderState) {
        transactions = state.transactions;
      }
      for (var e in transactions) {
        TransactionOnline transaction = Common.mappingTempTransaction(e);
        tempTransactions.add(transaction);
      }
      bool? scanned = event.scanned;
      if (scanned != null) {
        tempTransactions =
            transactions.where((e) => e.scanned == scanned).toList();
      } else {
        tempTransactions = [];
        for (var e in transactions) {
          TransactionOnline transaction = Common.mappingTempTransaction(e);
          tempTransactions.add(transaction);
        }
      }
      emit(TiktokFullOrderState(transactions, tempTransactions));
    } catch (e) {
      emit(TiktokErrorState());
    }
  }

  void _onGetOrders(GetOrders event, Emitter<TiktokState> emit) async {
    try {
      emit(TiktokLoadingState());
      List<TransactionOnline> transactions = await TiktokApi.getorders();
      List<TransactionOnline> tempTransactions = [];
      for (var e in transactions) {
        TransactionOnline transaction = Common.mappingTempTransaction(e);
        tempTransactions.add(transaction);
      }
      emit(TiktokFullOrderState(transactions, tempTransactions));
    } catch (e) {
      emit(TiktokErrorState());
    }
  }

  void _onGetOrder(GetOrder event, Emitter<TiktokState> emit) async {
    try {
      emit(TiktokLoadingState());
      List<TransactionOnline> transactions =
          await TiktokApi.getorder(event.orderNumbers.join(","));
      emit(TiktokFullOrderState(transactions, const []));
    } catch (e) {
      emit(TiktokErrorState());
    }
  }
}
