import 'package:app_condominios/dao.dart';
import 'package:app_condominios/model.dart';
import 'package:app_condominios/server.dart';
import 'package:app_condominios/utils.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _StateTelaLogin();
}

class _StateTelaLogin extends State<TelaLogin> {
  final TextEditingController _loginControler = TextEditingController();
  final TextEditingController _senhaControler = TextEditingController();
  final FocusNode _loginFocus = FocusNode();
  final FocusNode _senhaFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: _buildBody(),
        bottomNavigationBar: BottomAppBar(
            child: ListTile(
                onTap: login,
                trailing: Wrap(children: const [
                  Text('Login',
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                  Icon(Icons.arrow_forward, color: Colors.white)
                ])),
            color: Colors.blue));
  }

  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
            child: Form(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
              controller: _loginControler,
              maxLength: 100,
              focusNode: _loginFocus,
              style: const TextStyle(fontSize: 20.0),
              decoration: _buildInputDecoration(
                  hint: 'Digite o usuario', icon: Icons.person)),
          TextFormField(
              controller: _senhaControler,
              focusNode: _senhaFocus,
              maxLength: 20,
              obscureText: true,
              style: const TextStyle(fontSize: 20.0),
              decoration: _buildInputDecoration(
                  hint: 'Digite sua senha', icon: Icons.lock)),
          const SizedBox(height: 20.0)
        ]))));
  }

  InputDecoration _buildInputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
        hintText: hint,
        helperStyle: const TextStyle(fontSize: 12.0, color: Colors.grey),
        hintStyle: const TextStyle(fontSize: 20.0, color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: normalTxtColor)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: focusedTxtColor, width: 2.0)),
        icon: Icon(icon, color: Colors.blue));
  }

  void login() {
    final login = _loginControler.text;
    final senha = _senhaControler.text;
    server.srvPostLogin(login, senha).then((Sessao sessao) async {
      await DAO.get().saveSessao(sessao);
      Navigator.pop(context);
    }, onError: (ex) {
      showMsg(
          ctx: context,
          titulo: 'Não foi possivel efetuar login',
          mensagem: ex.toString());
    });
  }
}
