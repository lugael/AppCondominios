import 'package:app_condominios/tela_inicial.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppCondominio());
}

class AppCondominio extends StatelessWidget {
  const AppCondominio({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Condominios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TelaInicial(),
    );
  }
}
