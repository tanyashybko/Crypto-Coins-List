// import 'dart:async';
//
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:helloworld/crypto_coins_list_app.dart';
// import 'package:helloworld/repositories/crypto_coins/crypto_coins.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:talker_bloc_logger/talker_bloc_logger.dart';
// import 'package:talker_dio_logger/talker_dio_logger.dart';
// import 'package:talker_flutter/talker_flutter.dart';
//
// import 'firebase_options.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final talker = TalkerFlutter.init();
//   GetIt.I.registerSingleton(talker);
//   GetIt.I<Talker>().debug('Talker Started');
//
//   await Hive.initFlutter();
//
//   Hive.registerAdapter(CryptoCoinAdapter());
//   Hive.registerAdapter(CryptoCoinDetailAdapter());
//
//   final cryptoCoinsBox = await Hive.openBox<CryptoCoin>('crypto_coins_box');
//
//   final app = await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   talker.info(app.options.projectId);
//
//   final dio = Dio();
//   dio.interceptors.add(TalkerDioLogger(
//       talker: talker,
//       settings: const TalkerDioLoggerSettings(
//           printResponseData: false,
//       ),
//   ),
//   );
//
//   Bloc.observer = TalkerBlocObserver(
//       talker: talker,
//     settings: const TalkerBlocLoggerSettings(
//       printStateFullData: false,
//       printEventFullData: false,
//     ),
//   );
//
//   GetIt.I.registerLazySingleton<AbstractCoinRepository>(
//           () => CryptoCoinsRepository(
//               dio: dio,
//               cryptoCoinsBox: cryptoCoinsBox
//           ),
//   ); //репозитории создаются по мере необходимости
//
//   FlutterError.onError = (details) =>  GetIt.I<Talker>().handle(details.exception, details.stack);
//
//   runZonedGuarded(() => runApp(const CryptoCurrenciesListApp()),
//           (error, stack) => GetIt.I<Talker>().handle(error, stack),
//   );
// }
//
//
//
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:helloworld/crypto_coins_list_app.dart';
import 'package:helloworld/repositories/crypto_coins/crypto_coins.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'firebase_options.dart';


void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Инициализация виджетов Flutter
    final talker = TalkerFlutter.init(); // Инициализация Talker для логирования
    GetIt.I.registerSingleton(talker); // Регистрация singleton Talker
    GetIt.I<Talker>().debug('Talker Started'); // Логирование начала работы Talker

    const cryptoCoinsBoxName = 'crypto_coins_box'; // Имя коробки для хранения данных о криптовалютах

    await Hive.initFlutter(); // Инициализация Hive

    // Регистрация адаптеров Hive для хранения данных о криптовалютах
    Hive.registerAdapter(CryptoCoinAdapter());
    Hive.registerAdapter(CryptoCoinDetailAdapter());

    final cryptoCoinsBox = await Hive.openBox<CryptoCoin>(cryptoCoinsBoxName); // Открытие коробки для хранения данных о криптовалютах

    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Инициализация Firebase с текущей платформой
    );

    talker.info(app.options.projectId); // Логирование ID проекта Firebase

    final dio = Dio(); // Создание экземпляра Dio
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker, // Добавление логирования запросов Dio
        settings: const TalkerDioLoggerSettings(
          printResponseData: false, // Отключение печати данных ответа
        ),
      ),
    );

    // Настройка наблюдателя для BLoC с логированием
    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printStateFullData: false, // Отключение печати полных данных состояния
        printEventFullData: false, // Отключение печати полных данных событий
      ),
    );

    // Регистрация ленивого singleton для репозитория криптовалют
    GetIt.I.registerLazySingleton<AbstractCoinRepository>(
          () => CryptoCoinsRepository(
        dio: dio,
        cryptoCoinsBox: cryptoCoinsBox,
      ),
    );

    // Обработка ошибок Flutter
    FlutterError.onError = (details) =>
        GetIt.I<Talker>().handle(details.exception, details.stack);

    runApp(const CryptoCurrenciesListApp()); // Запуск приложения
  },
          (error, stackTrace) {
        print('Unhandled error: $error'); // Печать необработанной ошибки
        print('Stack trace:\n$stackTrace'); // Печать трассировки стека
      });
}
