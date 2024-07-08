import 'package:helloworld/repositories/models/crypto_coin.dart';

import 'package:helloworld/repositories/models/crypto_coin_details.dart';

// Абстрактный класс для репозитория криптовалют
abstract class AbstractCoinRepository {
  // Метод для получения списка криптовалют
  Future<List<CryptoCoin>> getCoinsList();

  // Метод для получения деталей конкретной криптовалюты по её коду
  Future<CryptoCoin> getCoinDetails(String currencyCode);
}
