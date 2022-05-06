import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final normalTxtColor = Colors.blue;
final focusedTxtColor = Colors.orange;
String toMd5(String str){
  return md5.convert(utf8.encode(str)).toString();
}

void abrirTela(BuildContext ctx, StatefulWidget tela){
  Navigator.push(ctx,   CupertinoPageRoute(builder: (context) => tela));
}