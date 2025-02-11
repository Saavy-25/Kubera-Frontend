import 'package:flutter/material.dart';

class CustomThemes {
  static final ThemeData lightTheme = ThemeData( 
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(68, 152, 91, 87),
      surface: const Color.fromARGB(255, 249, 209, 200),
      brightness: Brightness.light,
    ),

    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),

      titleLarge:TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 194, 154, 154),
      surface:  const Color.fromARGB(255, 119, 88, 88),
      brightness: Brightness.dark,
    ),

    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
      
      titleLarge:TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
