// import 'package:crypto_coins_list/repositories/crypto_coins/crypto_coins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:helloworld/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:helloworld/repositories/models/crypto_coin.dart';
import 'package:helloworld/repositories/models/crypto_coin_details.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'crypto_coin_details_event.dart'; // Импорт событий для BLoC
part 'crypto_coin_details_state.dart'; // Импорт состояний для BLoC

class CryptoCoinDetailsBloc
    extends Bloc<CryptoCoinDetailsEvent, CryptoCoinDetailsState> {
  CryptoCoinDetailsBloc(this.coinsRepository)
      : super(const CryptoCoinDetailsState()) {
    on<LoadCryptoCoinDetails>(_load); // Обработчик события загрузки деталей криптовалюты
  }

  final AbstractCoinRepository coinsRepository; // Репозиторий криптовалют

  Future<void> _load(
      LoadCryptoCoinDetails event,
      Emitter<CryptoCoinDetailsState> emit,
      ) async {
    try {
      if (state is! CryptoCoinDetailsLoaded) {
        emit(const CryptoCoinDetailsLoading()); // Отправка состояния загрузки
      }
      final CryptoCoin = await coinsRepository.getCoinDetails(event.currencyCode); // Получение деталей криптовалюты

      emit(CryptoCoinDetailsLoaded(CryptoCoin)); // Отправка состояния с загруженными деталями криптовалюты
    } catch (e, state) {
      emit(CryptoCoinDetailsLoadingFailure(e)); // Отправка состояния ошибки загрузки
      GetIt.I<Talker>().handle(e, state as StackTrace?); // Обработка ошибки через Talker
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace); // Обработка ошибок BLoC через Talker
  }
}
