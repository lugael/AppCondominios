import 'package:app_condominios/model.dart';
import 'package:app_condominios/server_online.dart';
import 'package:app_condominios/utils.dart';
import 'package:flutter/material.dart';

class TelaMoradores extends StatefulWidget {
  const TelaMoradores({Key? key, required this.sessao}) : super(key: key);
  final Sessao sessao;

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
    }, onError: (ex) {
      showMsg(
          ctx: context,
          titulo: 'Não foi possível consultar',
          mensagem: ex.toString());
    });
  }

  Future<List<Morador>> fetchMoradores() async {
    return await server.srvGetMoradores(token: widget.sessao.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: _buildAppBar(),
        body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
        title: const Text('Moradores'),
        actions: _moradores == null
            ? []
            : [
                IconButton(
                    onPressed: _ordenar, icon: const Icon(Icons.sort_by_alpha)),
                IconButton(
                    onPressed: _ordenarPorApto,
                    icon: const Icon(Icons.apartment_outlined))
              ]);
  }

  Widget _buildBody() {
    if (_moradores == null) {
      return buildWidgetAguarde();
    } else {}
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
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
                          backgroundImage: _buildImagemMorador(morador)),
                      title: Text('${morador.nome}',
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 14.0)),
                      subtitle: Text(
                          morador.nascimento == null
                              ? 'null'
                              : ddMMyyyy.format(morador.nascimento!),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14.0)),
                      trailing: Text('${morador.apto}-${morador.bloco}'))));
        });
  }

  ImageProvider _buildImagemMorador(Morador morador) {
    return server.buildImage(
        url: 'https://$urlSrv/imagens/${morador.imagemAsset}',
        token: widget.sessao.token);
  }

  void _ordenar() {
    _ordemAsc = !_ordemAsc;
    setState(() {
      if (_ordemAsc) {
        _moradores!.sort((Morador.compararNomeAsc));
      } else {
        _moradores!.sort((Morador.compararNomeDesc));
      }
    });
  }

  void _ordenarPorApto() {
    setState(() {
      _ordemAsc = !_ordemAsc;
      if (_ordemAsc) {
        _moradores!.sort(Morador.compararAptoAsc);
      } else {
        _moradores!.sort(Morador.compararAptoDesc);
      }
    });
  }
}
