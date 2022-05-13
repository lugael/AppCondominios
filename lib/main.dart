import 'dart:io';

import 'package:app_condominios/server.dart';
import 'package:app_condominios/server_online.dart';
import 'package:app_condominios/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  initializeDateFormatting('pt_BR').then((v) => runApp(const AppCondominio()));
}

class AppCondominio extends StatelessWidget {
  const AppCondominio({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Condominios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: const TelaInicial(),
    );
  }
}
