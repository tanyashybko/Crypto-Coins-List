import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  // Настройка текста в приложении
  textTheme: TextTheme(
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
    labelSmall: TextStyle(
      color: Colors.white.withOpacity(0.6),
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  ),
  // Настройка фона экрана
  scaffoldBackgroundColor: const Color.fromRGBO(28, 27, 27, 1.0),
  // Настройка основной цветовой схемы
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
  // Настройка цвета разделителя
  dividerColor: Colors.white24,
  // Настройка темы для ListTile
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  // Настройка темы для AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(28, 27, 27, 1.0),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    centerTitle: true,
    // Настройка цвета значков в AppBar
    iconTheme: IconThemeData(color: Colors.white),
  ),
);