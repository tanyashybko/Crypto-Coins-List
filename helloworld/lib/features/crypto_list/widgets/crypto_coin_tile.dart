import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helloworld/repositories/models/crypto_coin.dart';
import 'package:helloworld/router/router.dart';

// Виджет для отображения информации о криптовалюте в виде элемента списка
class CryptoCoinTile extends StatelessWidget {
  const CryptoCoinTile({
    Key? key,
    required this.coin,
  }) : super(key: key);

  final CryptoCoin coin; // Поле для хранения информации о криптовалюте

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Получение текущей темы приложения
    final coinDetails = coin.details; // Получение деталей криптовалюты

    return ListTile(
      leading: Image.network(coinDetails.fullImageUrl), // Изображение криптовалюты
      title: Text(
        coin.name,
        style: Theme.of(context).textTheme.bodyMedium, // Название криптовалюты
      ),
      subtitle: Text(
        '${coinDetails.priceInUSD} \$',
        style: Theme.of(context).textTheme.labelSmall, // Цена криптовалюты в USD
      ),
      trailing: const Icon(Icons.arrow_forward_ios), // Значок "вперед"
      // Обработка нажатия на элемент списка
      onTap: () {
        AutoRouter.of(context).push(CryptoCoinRoute(coin: coin)); // Переход на страницу с деталями криптовалюты
        // Navigator.of(context).pushNamed(
        //   '/coin',
        //   arguments: coin,
        // );
      },
    );
  }
}
