part of 'crypto_list_bloc.dart';

// Абстрактный класс для состояний BLoC списка криптовалют
abstract class CryptoListState extends Equatable {}

// Начальное состояние списка криптовалют
class CryptoListInitial extends CryptoListState {
  @override
  List<Object?> get props => [];
}

// Состояние загрузки списка криптовалют
class CryptoListLoading extends CryptoListState {
  @override
  List<Object?> get props => [];
}

// Состояние успешной загрузки списка криптовалют
class CryptoListLoaded extends CryptoListState {
  CryptoListLoaded({
    required this.coinsList,
  });

  final List<CryptoCoin> coinsList; // Список криптовалют

  @override
  List<Object?> get props => [coinsList];
}

// Состояние ошибки при загрузке списка криптовалют
class CryptoListLoadingFailure extends CryptoListState {
  CryptoListLoadingFailure({
    required this.exception,
  });

  final Object? exception; // Исключение, вызвавшее ошибку

  @override
  List<Object?> get props => [exception];
}
