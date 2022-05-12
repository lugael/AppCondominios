import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final ddMMyyyy = DateFormat("dd/MM/yyyy", "pt-BR");
final yyyyMMdd = DateFormat("yyyy-MM-dd");
final valorFmt = NumberFormat("###,##0.00", "pt_BR");
bool modoTeste = false;

const normalTxtColor = Colors.blue;
const focusedTxtColor = Colors.orange;

String toMd5(String str) {
  return md5.convert(utf8.encode(str)).toString();
}

DateTime onlyDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime today() {
  return onlyDate(DateTime.now());
}

Future<void> abrirTela(BuildContext ctx, StatefulWidget tela) async {
  await Navigator.push(ctx, CupertinoPageRoute(builder: (context) => tela));
}

Future<void> showMsg(
    {required BuildContext ctx,
    required String titulo,
    required String mensagem}) async {
  await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(titulo),
            content: SingleChildScrollView(child: Text(mensagem)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ]);
      });
}

Future<bool> confirme(
    {required BuildContext ctx, required String mensagem}) async {
  bool confirmou = false;
  await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Confirmação'),
            content: SingleChildScrollView(child: Text(mensagem)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    confirmou = false;
                  },
                  child: const Text('Não')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    confirmou = true;
                  },
                  child: const Text('Sim')),
            ]);
      });
  return confirmou;
}

Widget buildWidgetAguarde() {
  return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
    const CircularProgressIndicator(),
    Text('Aguarde. Carregando dados...',
        style: TextStyle(color: Colors.blue.shade800, fontSize: 14.0))
  ]));
}

void showSnackBar({required BuildContext ctx, required String data}) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      backgroundColor: Colors.yellow,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          data,
          style: const TextStyle(color: Colors.black),
        ),
      )));
}
