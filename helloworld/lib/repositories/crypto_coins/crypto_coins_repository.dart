import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:helloworld/repositories/crypto_coins/crypto_coins.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

// Реализация репозитория криптовалют, наследующегося от AbstractCoinRepository
class CryptoCoinsRepository implements AbstractCoinRepository {
  CryptoCoinsRepository({
    required this.dio, // Экземпляр Dio для выполнения HTTP-запросов
    required this.cryptoCoinsBox, // Коробка Hive для локального хранения данных о криптовалютах
  });

  final Dio dio; // Поле для хранения экземпляра Dio
  final Box<CryptoCoin> cryptoCoinsBox; // Поле для хранения коробки Hive

  // Метод для получения списка криптовалют
  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    var cryptoCoinsList = <CryptoCoin>[]; // Локальная переменная для хранения списка криптовалют
    try {
      cryptoCoinsList = await _fetchCoinsListFromApi(); // Попытка получить список криптовалют из API
      final cryptoCoinsMap = {for (var e in cryptoCoinsList) e.name: e}; // Преобразование списка криптовалют в карту
      await cryptoCoinsBox.putAll(cryptoCoinsMap); // Сохранение данных в локальную базу данных Hive
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st); // Логирование ошибки с помощью Talker
      cryptoCoinsList = cryptoCoinsBox.values.toList(); // Получение данных из локальной базы данных в случае ошибки
    }

    // Сортировка списка криптовалют по убыванию цены в USD
    cryptoCoinsList.sort((a, b) => b.details.priceInUSD.compareTo(a.details.priceInUSD));
    return cryptoCoinsList; // Возвращение списка криптовалют
  }

  // Метод для получения списка криптовалют из API
  Future<List<CryptoCoin>> _fetchCoinsListFromApi() async {
    final response = await dio.get(
        'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,BNB,SOL,AID,CAG,DOV&tsyms=USD');
    final data = response.data as Map<String, dynamic>; // Преобразование ответа в карту данных
    final dataRaw = data['RAW'] as Map<String, dynamic>; // Извлечение сырой информации
    final cryptoCoinsList = dataRaw.entries.map((e) {
      final usdData =
      (e.value as Map<String, dynamic>)['USD'] as Map<String, dynamic>; // Извлечение данных в USD
      final details = CryptoCoinDetail.fromJson(usdData); // Создание объекта CryptoCoinDetail из данных JSON
      return CryptoCoin(name: e.key, details: details); // Создание объекта CryptoCoin
    }).toList();
    return cryptoCoinsList; // Возвращение списка криптовалют
  }

  // Метод для получения деталей конкретной криптовалюты
  @override
  Future<CryptoCoin> getCoinDetails(String currencyCode) async {
    try {
      final coin = await _fetchCoinDetailsFromApi(currencyCode); // Попытка получить детали криптовалюты из API
      cryptoCoinsBox.put(currencyCode, coin); // Сохранение данных в локальную базу данных Hive
      return coin; // Возвращение объекта CryptoCoin
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st); // Логирование ошибки с помощью Talker
      return cryptoCoinsBox.get(currencyCode)!; // Получение данных из локальной базы данных в случае ошибки
    }
  }

  // Метод для получения деталей конкретной криптовалюты из API
  Future<CryptoCoin> _fetchCoinDetailsFromApi(String currencyCode) async {
    final response = await dio.get(
        'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=$currencyCode&tsyms=USD');
    final data = response.data as Map<String, dynamic>; // Преобразование ответа в карту данных
    final dataRaw = data['RAW'] as Map<String, dynamic>; // Извлечение сырой информации
    final coinData = dataRaw[currencyCode] as Map<String, dynamic>; // Извлечение данных для конкретной криптовалюты
    final usdData = coinData['USD'] as Map<String, dynamic>; // Извлечение данных в USD
    final details = CryptoCoinDetail.fromJson(usdData); // Создание объекта CryptoCoinDetail из данных JSON
    return CryptoCoin(name: currencyCode, details: details); // Создание и возвращение объекта CryptoCoin
  }
}
