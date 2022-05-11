import 'package:app_condominios/model.dart';
import 'package:app_condominios/server.dart';
import 'package:app_condominios/tela_reservas.dart';
import 'package:app_condominios/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaEspacos extends StatefulWidget {
  const TelaEspacos({Key? key, required this.sessao}) : super(key: key);
  final Sessao sessao;

  @override
  State<TelaEspacos> createState() => _TelaEspacosState();
}

class _TelaEspacosState extends State<TelaEspacos> {
  TipoEspaco? _tipoEspaco;
  List<Espaco>? _espacos;
  final List<MenuItem> _opcoes = [
    MenuItem(label: 'Todos', tipo: null),
    MenuItem(label: 'Salao de Festa', tipo: TipoEspaco.salaoFesta),
    MenuItem(label: 'Quiosque', tipo: TipoEspaco.quiosque),
    MenuItem(label: 'Piscina', tipo: TipoEspaco.piscina),
    MenuItem(label: 'Academia', tipo: TipoEspaco.academia),
    MenuItem(label: 'Sala de jogos', tipo: TipoEspaco.salaJogos),
    MenuItem(label: 'Quadra Espostiva', tipo: TipoEspaco.quadraEsportiva),
    MenuItem(label: 'Sauna', tipo: TipoEspaco.sauna),
    MenuItem(label: 'Playground', tipo: TipoEspaco.playGround),
  ];

  @override
  void initState() {
    super.initState();
    _consultarEspacos();
  }

  void _consultarEspacos() {
    _fetchEspacos().then((value) {
      setState(() {
        _espacos = value;
      });
    }, onError: (ex) {
      showMsg(
          ctx: context,
          titulo: 'Não foi possível consultar',
          mensagem: ex.toString());
    });
  }

  Future<List<Espaco>> _fetchEspacos() async {
    final condominioId = widget.sessao.usuario!.morador!.condominio!.id!;
    return srvGetEspacos(
        full: true,
        tipo: _tipoEspaco,
        condominioId: condominioId,
        token: widget.sessao.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(title: const Text('Espaços'), actions: [
      PopupMenuButton<MenuItem>(
          onSelected: _onSelectMenuItem,
          icon: const Icon(Icons.filter_alt),
          itemBuilder: (BuildContext context) {
            return _opcoes
                .map((e) => PopupMenuItem(value: e, child: Text(e.label)))
                .toList();
          })
    ]);
  }

  void _onSelectMenuItem(MenuItem item) {
    _tipoEspaco = item.tipo;
    setState(() {
      _espacos = null;
    });
    _consultarEspacos();
  }

  Widget _buildBody() {
    if (_espacos == null) {
      return buildWidgetAguarde();
    }
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _espacos!.length,
        itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    final espaco = _espacos![index];
    return Card(
      child: ListTile(
        leading: espaco == null ? null : Icon(_tipoIcon(espaco.tipo!)),
        title: Text(espaco.nome ?? '?'),
        onTap: () => _abrirTela(espaco),
      ),
    );
  }

  IconData _tipoIcon(TipoEspaco tipo) {
    switch (tipo) {
      case TipoEspaco.salaoFesta:
        return Icons.festival;
      case TipoEspaco.quiosque:
        return Icons.beach_access;
      case TipoEspaco.piscina:
        return Icons.pool;
      case TipoEspaco.academia:
        return Icons.sports_mma;
      case TipoEspaco.salaJogos:
        return Icons.sports_esports;
      case TipoEspaco.quadraEsportiva:
        return Icons.sports_soccer;
      case TipoEspaco.sauna:
        return Icons.airline_seat_recline_normal_sharp;
      case TipoEspaco.playGround:
        return Icons.park;
    }
  }

  void _abrirTela(Espaco espaco) {
    abrirTela(context, TelaReservas(sessao: widget.sessao, espaco: espaco));
  }
}

class MenuItem {
  final String label;
  final TipoEspaco? tipo;

  MenuItem({required this.label, this.tipo});
}
