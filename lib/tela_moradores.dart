import 'dart:io';

import 'package:app_condominios/fakes.dart';
import 'package:app_condominios/model.dart';
import 'package:flutter/material.dart';

class TelaMoradores extends StatefulWidget {
  const TelaMoradores({Key? key}) : super(key: key);

  @override
  State<TelaMoradores> createState() => _TelaMoradoresState();
}

class _TelaMoradoresState extends State<TelaMoradores> {
  List<Morador>? _moradores;
  bool _ordemAsc = false;

  @override
  void initState() {
    super.initState();
    fetchMoradores().then((lista) {
      setState(() {
        _moradores = lista;
      });
    });
  }

  Future<List<Morador>> fetchMoradores() async {
    await Future.delayed(const Duration(seconds: 2));
    return fakeMoradores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: _buildAppBar(),
        body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(title: Text('Moradores'), actions: _moradores == null ? [] : [
        IconButton(onPressed: _ordenar, icon: Icon(Icons.sort_by_alpha))
      ]);
  }

  Widget _buildBody() {
    if (_moradores == null) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(),
        Text('Aguarde. Carregando dados...',
            style: TextStyle(color: Colors.blue.shade800, fontSize: 14.0))
      ]));
    } else {}
    return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _moradores!.length,
        itemBuilder: (BuildContext context, int index) {
          final morador = _moradores![index];
          return Card(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                      leading: CircleAvatar(
                          radius: 28.0,
                          backgroundImage:
                              AssetImage('assets/${morador.imagemAsset}')),
                      title: Text('${morador.nome}',
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 14.0)),
                      subtitle: Text(
                          morador.nascimento == null
                              ? 'null'
                              : dd_MM_yyyy.format(morador.nascimento!),
                          style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                      trailing: Text('${morador.apto} - ${morador.bloco}'))));
        });
  }

  void _ordenar() {
      _ordemAsc = !_ordemAsc;
    setState(() {
      if (_ordemAsc) {
        _moradores!.sort((Morador.compararNomeAsc));
      } else {
        _moradores!.sort((Morador.compararNomeAsc));
      }
    });
  }
}
