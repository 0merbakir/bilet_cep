import 'package:bilet_cep/main.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

final themeProvider = StateProvider<ThemeData>((ref) {
  return ThemeData(
            scaffoldBackgroundColor: Color(0xFFEEF1F8),
        primarySwatch: Colors.blue, // Temel renk paleti mavi olarak belirlendi
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          // kullanılacak input formlar için genel tema belirlendi
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
  ); // Initial default theme
});

// change theme function
