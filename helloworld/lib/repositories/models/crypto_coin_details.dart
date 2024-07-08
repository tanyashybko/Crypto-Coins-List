import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto_coin_details.g.dart';

// Аннотации HiveType и JsonSerializable для регистрации типа данных в Hive и автоматической сериализации JSON
@HiveType(typeId: 1)
@JsonSerializable()
class CryptoCoinDetail extends Equatable {
  // Константный конструктор класса CryptoCoinDetail
  const CryptoCoinDetail({
    required this.priceInUSD, // Цена в долларах США
    required this.imageUrl, // URL изображения
    required this.toSymbol, // Символ валюты
    required this.lastUpdate, // Время последнего обновления
    required this.high24Hour, // Высшая цена за последние 24 часа
    required this.low24Hours, // Низшая цена за последние 24 часа
  });

  // Аннотации HiveField и JsonKey для регистрации полей в Hive и привязки ключей JSON
  @HiveField(0)
  @JsonKey(name: "TOSYMBOL")
  final String toSymbol; // Поле для хранения символа валюты

  @HiveField(1)
  @JsonKey(
    name: "LASTUPDATE",
    toJson: _dateTimeToJson,
    fromJson: _dateTimeFromJson,
  )
  final DateTime lastUpdate; // Поле для хранения времени последнего обновления

  @HiveField(2)
  @JsonKey(name: "HIGH24HOUR")
  final double high24Hour; // Поле для хранения высшей цены за последние 24 часа

  @HiveField(3)
  @JsonKey(name: "LOW24HOUR")
  final double low24Hours; // Поле для хранения низшей цены за последние 24 часа

  @HiveField(4)
  @JsonKey(name: "PRICE")
  final double priceInUSD; // Поле для хранения цены в долларах США

  @HiveField(5)
  @JsonKey(name: "IMAGEURL")
  final String imageUrl; // Поле для хранения URL изображения

  // Метод для получения полного URL изображения
  String get fullImageUrl => "https://www.cryptocompare.com/$imageUrl";

  // Метод для создания объекта из JSON
  factory CryptoCoinDetail.fromJson(Map<String, dynamic> json) => _$CryptoCoinDetailFromJson(json);

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$CryptoCoinDetailToJson(this);

  // Метод для преобразования даты и времени в JSON
  static int _dateTimeToJson(DateTime time) => time.millisecondsSinceEpoch;

  // Метод для создания даты и времени из JSON
  static DateTime _dateTimeFromJson(int milliseconds) => DateTime.fromMillisecondsSinceEpoch(milliseconds);

  // Переопределение метода props для Equatable, чтобы включить поля в список свойств
  @override
  List<Object> get props => [
    toSymbol,
    lastUpdate,
    high24Hour,
    low24Hours,
    priceInUSD,
    imageUrl,
  ];
}
