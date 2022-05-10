import 'package:app_condominios/dao.dart';
import 'package:app_condominios/model.dart';
import 'package:app_condominios/tela_boletos.dart';
import 'package:app_condominios/tela_login.dart';
import 'package:app_condominios/tela_moradores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_condominios/utils.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Sessao? _sessao;

  @override
  void initState() {
    super.initState();
    DAO.get().open().then((value) async {
      Sessao? s = await DAO.get().findSessao();
      await DAO.get().close();
      setState(() {
        _sessao = s;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logomarca.png'),
            const SizedBox(height: 20.0),
            Text('Seja bem-vindo(a) ao app para controle de condomínios!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            Container(
              width: 240,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.00),
                  Icon(Icons.info_outline_rounded,
                      size: 50, color: Colors.blueAccent),
                  Text('Acesse as funções do app pelo menu lateral.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Powered by (Luis) @ Proway',
              style: TextStyle(color: Colors.grey.shade400),
            )
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    var drawerItems = <Widget>[
      UserAccountsDrawerHeader(
          accountName: Text((_sessao == null)
              ? 'Não está logado'
              : (_sessao!.usuario?.nomeUsuario?.toUpperCase() ?? '?')),
          accountEmail: Text((_sessao == null)
              ? 'Efetue o login'
              : (_sessao!.usuario?.morador?.nome ?? '?'))),
    ];
    if (_sessao == null) {
      drawerItems.addAll([_buildTileLogin()]);
    } else {
      drawerItems.addAll(
          [_buildTileMoradores(), _buildTileBoletos(), _buildTileLogoff()]);
    }
    return Drawer(child: ListView(children: drawerItems));
  }

  ListTile _buildTileMoradores() {
    return ListTile(
        leading: Icon(Icons.people_alt),
        title: Text('Lista de moradores'),
        onTap: _abrirTelaMoradores);
  }

  ListTile _buildTileLogin() {
    return ListTile(
        leading: Icon(Icons.login),
        title: Text('Efetuar Login'),
        onTap: _abrirTelaLogin);
  }

  ListTile _buildTileBoletos() {
    return ListTile(
        leading: Icon(Icons.assignment_outlined),
        title: Text('Boletos'),
        onTap: _abrirTelaBoletos);
  }

  ListTile _buildTileLogoff() {
    return ListTile(
        leading: Icon(Icons.block_outlined),
        title: Text('Efetuar logoff'),
        onTap: _efetuarLogoff);
  }

  void _abrirTelaLogin() {
    Navigator.pop(context);
    abrirTela(context, const TelaLogin()).then((value) async {
      DAO.get().findSessao().then((value) {
        setState(() {
          _sessao = value;
        });
      });
    });
  }

  void _efetuarLogoff() async {
    Navigator.pop(context);
    await DAO.get().deleteSessao();
    setState(() {
      _sessao = null;
    });
  }

  void _abrirTelaMoradores() {
    Navigator.pop(context);
    abrirTela(context, TelaMoradores(sessao: _sessao!));
  }

  void _abrirTelaBoletos() {
    Navigator.pop(context);
    abrirTela(context, TelaBoletos(sessao: _sessao!));
  }
}
