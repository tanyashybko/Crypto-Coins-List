import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'router/router.dart';
import 'theme/theme.dart';

// Главный виджет приложения
class CryptoCurrenciesListApp extends StatefulWidget {
  const CryptoCurrenciesListApp({super.key});

  @override
  State<CryptoCurrenciesListApp> createState() =>
      _CryptoCurrenciesListAppState();
}

// Состояние для главного виджета приложения
class _CryptoCurrenciesListAppState extends State<CryptoCurrenciesListApp> {

  final _appRouter = AppRouter(); // Создание экземпляра маршрутизатора

  // Этот виджет является корнем приложения.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CryptoCurrenciesList', // Название приложения
      theme: darkTheme, // Установка темы оформления
      routerConfig: _appRouter.config(
        navigatorObservers: () => [
          TalkerRouteObserver(GetIt.I<Talker>()), // Настройка наблюдателя маршрутов для логирования
        ],
      ),
    );
  }
}
