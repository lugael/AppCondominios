import 'dart:io';
import 'package:app_condominios/model.dart';
import 'package:app_condominios/server.dart';
import 'package:app_condominios/tela_moradores.dart';
import 'package:app_condominios/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uuid/uuid.dart';

void main() {
  setUpAll((){
      initialize();
  });
  testWidgets('Teste moradores', (WidgetTester tester) async {
    Sessao sessao = _criarSessao();
    Widget widget = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(home: TelaMoradores(sessao: sessao)));

    await tester.pumpWidget(widget);

    await tester.pumpAndSettle(const Duration(seconds: 10));

    var lista = tester.widgetList<ListTile>(find.byType(ListTile));

    expect((lista.elementAt(0).title as Text).data, 'Bob Marley');
    expect((lista.elementAt(0).trailing as Text).data, '902-A');

    expect((lista.elementAt(1).title as Text).data, 'Bobdy Lan');
    expect((lista.elementAt(1).trailing as Text).data, '803-C');

    expect((lista.elementAt(2).title as Text).data, 'Bon Jovi');
    expect((lista.elementAt(2).trailing as Text).data, '701-E');
  });
}

Sessao _criarSessao() => Sessao(
    inicio: DateTime.now(),
    usuario: Usuario(
        perfil: PerfilUsuario.morador,
        nomeUsuario: 'luis',
        id: const Uuid().v4(),
        morador: Morador(id: const Uuid().v4(), nome: 'Ozzy Osburne')));

void initialize() {
  modoTeste = true;
  initializeDateFormatting('pt_BR');
}
