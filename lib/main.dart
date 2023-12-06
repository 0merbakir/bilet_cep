
import 'package:bilet_cep/dashboard.dart';
import 'package:bilet_cep/screens/home/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bilet_cep/screens/onboding/onboding_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
 
/*hemeData(
        primaryColor: MaterialColor(
          primaryColorCode,
          <int, Color>{
            50: const Color(primaryColorCode).withOpacity(0.1),
            100: const Color(primaryColorCode).withOpacity(0.2),
            200: const Color(primaryColorCode).withOpacity(0.3),
            300: const Color(primaryColorCode).withOpacity(0.4),
            400: const Color(primaryColorCode).withOpacity(0.5),
            500: const Color(primaryColorCode).withOpacity(0.6),
            600: const Color(primaryColorCode).withOpacity(0.7),
            700: const Color(primaryColorCode).withOpacity(0.8),
            800: const Color(primaryColorCode).withOpacity(0.9),
            900: const Color(primaryColorCode).withOpacity(1.0),
          },
        ),
        scaffoldBackgroundColor: const Color(0xFF171821),
        fontFamily: 'IBMPlexSans',
        brightness: Brightness.dark);
        */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hata ayıklama modu etiketi kapatıldı
      title: 'The Flutter Way',
      theme: ThemeData(
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
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final userId = FirebaseAuth.instance.currentUser!.uid;
            if (userId == 'UH1HJ5Up79NVaS8RLMkgvZNFMLg1') {
              return DashBoard();
            } else {
              return BottomBar();
            }
          }
          return OnboardingScreen();
        },
      ), // uygulama tanıtım ekranı gösterilir
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  // InputDecorationTheme için defaultInputBorder widget oluşutuldu
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
