import 'package:app_condominios/model.dart';
import 'package:app_condominios/server.dart';
import 'package:app_condominios/utils.dart';
import 'package:flutter/material.dart';

class TelaBoletos extends StatefulWidget {
  const TelaBoletos({Key? key, required this.sessao}) : super(key: key);
  final Sessao sessao;

  @override
  State<TelaBoletos> createState() => _TelaBoletosState(sessao: sessao);
}

class _TelaBoletosState extends State<TelaBoletos> {
  final Sessao sessao;
  SituacaoBoleto? _situacaoFiltrar;
  List<Boleto>? _boletos;
  final List<MenuItem> _opcoes = [
    MenuItem(label: 'Todos', situacao: null),
    MenuItem(label: 'Abertos', situacao: SituacaoBoleto.ABERTO),
    MenuItem(label: 'Pagos', situacao: SituacaoBoleto.PAGO),
    MenuItem(label: 'Vencidos', situacao: SituacaoBoleto.VENCIDO),
  ];

  _TelaBoletosState({required this.sessao});

  @override
  void initState() {
    super.initState();
    _consultarBoletos();
  }

  void _consultarBoletos() {
    _fetchBoletos().then((lista) {
      setState(() {
        _boletos = lista;
      });
    }, onError:(ex){
      showMsg(ctx: context, titulo: 'Não foi possível consultar', mensagem: ex.toString());
    });
  }

  Future<List<Boleto>> _fetchBoletos() async {
    String? moradorId;
    if (sessao.usuario?.perfil == PerfilUsuario.MORADOR) {
      moradorId = sessao.usuario?.morador?.id;
    }
    final condominioId = sessao.usuario!.morador!.condominio!.id!;
    return srvGetBoletos(
        full: true,
        condominioId: condominioId,
        situacao: _situacaoFiltrar,
        moradorId: moradorId,
        token: sessao.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: const Text('Boletos'), actions: [
      PopupMenuButton<MenuItem>(
          onSelected: _onSelectMenuItem,
          icon: const Icon(Icons.assignment_outlined, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return _opcoes
                .map((e) => PopupMenuItem(
                      value: e,
                      child: Text(e.label),
                    ))
                .toList();
          })
    ]);
  }

  void _onSelectMenuItem(MenuItem item) {
          _situacaoFiltrar = item.situacao;
          setState(() {
            _boletos = null;
          });
          _consultarBoletos();
        }

  Widget _buildBody() {
    if (_boletos == null) {
      return buildWidgetAguarde();
    }
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _boletos!.length,
        itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    final boleto = _boletos![index];
    final venc = boleto.dataVencto;
    final valor = boleto.valorDoc;
    return Card(
        child: ListTile(
            leading: Icon(Icons.picture_as_pdf_outlined, size: 30.0),
            title: Text(boleto.morador?.nome ?? '?',
                style: TextStyle(color: Colors.grey.shade800, fontSize: 14.0)),
            subtitle:
                Text('Vencto: ${venc == null ? '?' : dd_MM_yyyy.format(venc)}'),
            trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('R\$ ${valor == null ? '?' : valorFmt.format(valor)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800)),
                  _buildWidgetSituacao(boleto),
                ])));
  }

  Widget _buildWidgetSituacao(Boleto boleto) {
    final situacao = boleto.getSituacao();
    final cor = getCorSituacao(situacao);
    return Text('${situacaoBoletoToStr(situacao)}',
        style: TextStyle(color: cor));
  }

  Color getCorSituacao(SituacaoBoleto situacao) {
    switch (situacao) {
      case SituacaoBoleto.PAGO:
        return Colors.green;
      case SituacaoBoleto.ABERTO:
        return Colors.blue;
      case SituacaoBoleto.VENCIDO:
        return Colors.red;
    }
  }
}

class MenuItem {
  final String label;
  final SituacaoBoleto? situacao;

  MenuItem({required this.label, this.situacao});
}
