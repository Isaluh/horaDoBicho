import 'package:flutter/material.dart';
import 'package:hora_do_bicho/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hora do Bicho',
      home: SplashPage(),
    );
  }
}