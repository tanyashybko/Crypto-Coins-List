import 'package:equatable/equatable.dart';
import 'package:helloworld/repositories/crypto_coins/crypto_coins.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'crypto_coin.g.dart';

// Аннотация HiveType для регистрации типа данных в Hive с уникальным идентификатором
@HiveType(typeId: 2)
class CryptoCoin extends Equatable {
  // Константный конструктор класса CryptoCoin
  const CryptoCoin({
    required this.name, // Имя криптовалюты
    required this.details, // Детали криптовалюты
  });

  // Аннотация HiveField для регистрации поля в Hive с порядковым номером
  @HiveField(0)
  final String name; // Поле для хранения имени криптовалюты

  @HiveField(1)
  final CryptoCoinDetail details; // Поле для хранения деталей криптовалюты

  // Переопределение метода props для Equatable, чтобы включить поля в список свойств
  @override
  List<Object> get props => [name, details];
}
