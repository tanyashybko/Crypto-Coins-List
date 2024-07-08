part of 'crypto_coin_details_bloc.dart';

class CryptoCoinDetailsState extends Equatable {
  const CryptoCoinDetailsState();

  @override
  List<Object?> get props => [];
}

class CryptoCoinDetailsLoading extends CryptoCoinDetailsState {
  const CryptoCoinDetailsLoading(); // Состояние загрузки деталей криптовалюты

  @override
  List<Object?> get props => [];
}

class CryptoCoinDetailsLoaded extends CryptoCoinDetailsState {
  const CryptoCoinDetailsLoaded(this.coin); // Состояние успешно загруженных деталей криптовалюты

  final CryptoCoin coin;

  @override
  List<Object?> get props => [coin];
}

class CryptoCoinDetailsLoadingFailure extends CryptoCoinDetailsState {
  const CryptoCoinDetailsLoadingFailure(this.exception); // Состояние ошибки загрузки деталей криптовалюты

  final Object exception;

  @override
  List<Object?> get props => super.props..add(exception);
}
