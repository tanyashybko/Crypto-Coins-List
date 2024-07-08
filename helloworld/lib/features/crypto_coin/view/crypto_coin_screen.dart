import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:helloworld/features/crypto_coin/bloc/crypto_coin_details_bloc.dart';
import 'package:helloworld/features/crypto_list/widgets/base_card.dart';
import 'package:helloworld/repositories/crypto_coins/abstract_coins_repository.dart';
import 'package:helloworld/repositories/models/crypto_coin.dart';

@RoutePage() // Аннотация для указания страницы навигации

class CryptoCoinScreen extends StatefulWidget {
  const CryptoCoinScreen({
    super.key,
    required this.coin,
  });

  final CryptoCoin coin; // Выбранная криптовалюта

  @override
  State<CryptoCoinScreen> createState() => _CryptoCoinScreenState();
}

class _CryptoCoinScreenState extends State<CryptoCoinScreen> {
  final _coinDetailsBloc = CryptoCoinDetailsBloc(
    GetIt.I<AbstractCoinRepository>(),
  ); // BLoC для управления состоянием деталей криптовалюты

  @override
  void initState() {
    _coinDetailsBloc.add(LoadCryptoCoinDetails(currencyCode: widget.coin.name)); // Загрузка деталей криптовалюты при инициализации
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // AppBar экрана деталей криптовалюты
      body: BlocBuilder<CryptoCoinDetailsBloc, CryptoCoinDetailsState>(
        bloc: _coinDetailsBloc,
        builder: (context, state) {
          if (state is CryptoCoinDetailsLoaded) {
            final coin = state.coin;
            final coinDetails = coin.details;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: Image.network(coinDetails.fullImageUrl), // Изображение криптовалюты
                  ),
                  const SizedBox(height: 24),
                  Text(
                    coin.name, // Название криптовалюты
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BaseCard(
                    child: Center(
                      child: Text(
                        '${coinDetails.priceInUSD} \$', // Цена криптовалюты
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  BaseCard(
                    child: Column(
                      children: [
                        _DataRow(
                          title: 'High 24 Hour',
                          value: '${coinDetails.high24Hour} \$', // Высокая цена за 24 часа
                        ),
                        const SizedBox(height: 6),
                        _DataRow(
                          title: 'Low 24 Hour',
                          value: '${coinDetails.low24Hours} \$', // Низкая цена за 24 часа
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator()); // Отображение индикатора загрузки при загрузке данных
        },
      ),
    );
  }
}

// Виджет для отображения строки данных
class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.title,
    required this.value,
  });

  final String title; // Заголовок строки
  final String value; // Значение строки

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 140, child: Text(title)), // Заголовок с ограничением по ширине
        const SizedBox(width: 32), // Промежуток между заголовком и значением
        Flexible(
          child: Text(value), // Гибкое отображение значения строки
        ),
      ],
    );
  }
}
