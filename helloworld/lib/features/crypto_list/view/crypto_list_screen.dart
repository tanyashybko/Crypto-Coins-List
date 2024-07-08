import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:helloworld/features/crypto_list/bloc/crypto_list_bloc.dart';
import 'package:helloworld/features/crypto_list/widgets/widgets.dart';
import 'package:helloworld/repositories/crypto_coins/crypto_coins.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage() // Аннотация для автоматической генерации маршрута

// Экран для отображения списка криптовалют
class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  // Создание экземпляра BLoC для списка криптовалют
  final _cryptoListBloc = CryptoListBloc(
      GetIt.I<AbstractCoinRepository>()
  );

  @override
  void initState() {
    // Загрузка списка криптовалют при инициализации состояния
    _cryptoListBloc.add(LoadCryptoList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar для экрана со списком криптовалют
      appBar: AppBar(
        title: const Text("CryptoCurrenciesList"),
        actions: [
          IconButton(
            onPressed: () {
              // Переход на экран Talker для отображения логов
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(
                    talker: GetIt.I<Talker>(),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.document_scanner_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        // Обработка обновления списка при жесте "потянуть для обновления"
        onRefresh: () async {
          final completer = Completer();
          _cryptoListBloc.add(LoadCryptoList(completer: completer));
          return completer.future;
        },
        // Построение виджета в зависимости от состояния BLoC
        child: BlocBuilder<CryptoListBloc, CryptoListState>(
          bloc: _cryptoListBloc,
          builder: (context, state) {
            if (state is CryptoListLoaded) {
              // Отображение списка криптовалют при успешной загрузке
              return ListView.separated(
                padding: const EdgeInsets.only(top: 16),
                itemCount: state.coinsList.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, i) {
                  final coin = state.coinsList[i];
                  return CryptoCoinTile(coin: coin);
                },
              );
            }
            if (state is CryptoListLoadingFailure) {
              // Отображение сообщения об ошибке при неудачной загрузке
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Something went wrong',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Please try again later',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        _cryptoListBloc.add(LoadCryptoList());
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            // Отображение индикатора загрузки при начальной загрузке
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
