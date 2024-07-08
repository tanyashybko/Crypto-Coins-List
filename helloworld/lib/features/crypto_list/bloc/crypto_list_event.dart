part of 'crypto_list_bloc.dart';

// Абстрактный класс для событий BLoC списка криптовалют
abstract class CryptoListEvent extends Equatable {}

// Событие загрузки списка криптовалют
class LoadCryptoList extends CryptoListEvent {
  LoadCryptoList({
    this.completer,
  });

  final Completer? completer; // Completer для завершения асинхронной операции

  @override
  List<Object?> get props => [completer]; // Свойства, используемые для сравнения событий
}
