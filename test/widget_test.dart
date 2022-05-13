import 'package:app_condominios/model.dart';
import 'server_mock.dart';
import 'package:app_condominios/tela_moradores.dart';
import 'package:app_condominios/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
Sessao? _sessao;
void main() {
  setUpAll(() async{
    server = ServerMock();
    initializeDateFormatting('pt_BR');
      _sessao = await server.srvPostLogin('samuel', 'cun123');
  });

  tearDownAll(() async {
    await server.srvPostLogoff(token: _sessao!.token);
  });

  testWidgets('Teste moradores', (WidgetTester tester) async {
    Widget widget = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(home: TelaMoradores(sessao: _sessao!)));

    await tester.pumpWidget(widget);

    await tester.pumpAndSettle(const Duration(seconds: 10));

    var lista = tester.widgetList<ListTile>(find.byType(ListTile));

    expect((lista.elementAt(0).title as Text).data, 'Bob Marley');
    expect((lista.elementAt(0).trailing as Text).data, '902-A');

    expect((lista.elementAt(1).title as Text).data, 'Bobdy Lan');
    expect((lista.elementAt(1).trailing as Text).data, '803-C');

    expect((lista.elementAt(2).title as Text).data, 'Bon Jovi');
    expect((lista.elementAt(2).trailing as Text).data, '701-E');
    await tester.tap(find.byIcon(Icons.sort_by_alpha));
    await tester.tap(find.byIcon(Icons.sort_by_alpha));
    await tester.pumpAndSettle();

    lista = tester.widgetList<ListTile>(find.byType(ListTile));
    expect((lista.elementAt(0).title as Text).data, 'Taylor');
    expect((lista.elementAt(0).trailing as Text).data, '30-H');
  });
}
