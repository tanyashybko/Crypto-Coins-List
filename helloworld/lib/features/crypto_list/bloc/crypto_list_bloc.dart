import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:helloworld/repositories/crypto_coins/crypto_coins.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'crypto_list_event.dart'; // Импорт части событий BLoC
part 'crypto_list_state.dart'; // Импорт части состояний BLoC

// BLoC для управления состоянием списка криптовалют
class CryptoListBloc extends Bloc<CryptoListEvent, CryptoListState> {
  // Конструктор BLoC, принимающий репозиторий криптовалют
  CryptoListBloc(this.coinsRepository) : super(CryptoListInitial()) {
    on<LoadCryptoList>(_load); // Обработка события загрузки списка криптовалют
  }

  final AbstractCoinRepository coinsRepository; // Репозиторий криптовалют

  // Приватный метод для загрузки списка криптовалют
  Future<void> _load(
      LoadCryptoList event,
      Emitter<CryptoListState> emit,
      ) async {
    try {
      if (state is! CryptoListLoaded) {
        emit(CryptoListLoading()); // Устанавливаем состояние загрузки, если оно еще не установлено
      }
      final coinsList = await coinsRepository.getCoinsList(); // Получаем список криптовалют из репозитория
      emit(CryptoListLoaded(coinsList: coinsList)); // Устанавливаем состояние загруженного списка криптовалют
    } catch (e) {
      emit(CryptoListLoadingFailure(exception: e)); // Устанавливаем состояние с ошибкой загрузки
      GetIt.I<Talker>().handle(e, state as StackTrace?); // Обрабатываем и логируем ошибку
    } finally {
      event.completer?.complete(); // Завершаем выполнение операции, если передан completer
    }
  }

  // Переопределение метода для обработки ошибок BLoC
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace); // Логируем ошибку
  }
}
