import 'package:flutter/material.dart';

// Определение базового карточного виджета
class BaseCard extends StatelessWidget {
  // Конструктор для создания экземпляра BaseCard с обязательным дочерним виджетом
  const BaseCard({super.key, required this.child});

  // Поле для хранения дочернего виджета
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16, // Горизонтальные отступы
        vertical: 8, // Вертикальные отступы
      ),
      width: double.infinity, // Ширина контейнера на всю ширину родительского виджета
      padding: const EdgeInsets.all(16), // Внутренние отступы
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Радиус закругления углов
        color: const Color.fromARGB(255, 21, 21, 21), // Цвет фона контейнера
      ),
      child: child, // Вставка дочернего виджета
    );
  }
}
