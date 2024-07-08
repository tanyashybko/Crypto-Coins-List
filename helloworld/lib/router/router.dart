import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/features/crypto_coin/view/crypto_coin_screen.dart';
import 'package:helloworld/repositories/models/crypto_coin.dart';

import '../features/crypto_list/view/crypto_list_screen.dart';


part 'router.gr.dart';

// Аннотация для автоматической конфигурации маршрутизатора
@AutoRouterConfig()
class AppRouter extends _$AppRouter { // Создание класса маршрутизатора, который наследуется от сгенерированного класса

  // Определение списка маршрутов
  @override
  List<AutoRoute> get routes => [
    // Маршрут для страницы со списком криптовалют
    AutoRoute(page: CryptoListRoute.page, path: '/'),

    // Маршрут для страницы с деталями криптовалюты
    AutoRoute(page: CryptoCoinRoute.page),
  ];
}

// final routes = {
//   '/' : (context) => const CryptoListScreen(),
//   '/coin' : (context) => const CryptoCoinScreen(),
// };