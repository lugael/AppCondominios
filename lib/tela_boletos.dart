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
  List<Boleto>? _boletos;

  _TelaBoletosState({required this.sessao});

  @override
  void initState() {
    super.initState();
    fetchBoletos().then((lista) {
      setState(() {
        _boletos = lista;
      });
    });
  }

  Future<List<Boleto>> fetchBoletos() async {
    String? moradorId;
    if (sessao.usuario?.perfil == PerfilUsuario.MORADOR) {
      moradorId = sessao.usuario?.morador?.id;
    }
    final condominioId = sessao.usuario!.morador!.condominio!.id!;
    return srvGetBoletos(
        full: true,
        condominioId: condominioId ,
        moradorId: moradorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.blue.shade200,
      appBar:  AppBar(title:  const Text('Boletos')),
      body: _buildBody(),
    );
  }
  Widget _buildBody(){
    if(_boletos == null){
      return buildWidgetAguarde();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _boletos!.length,
      itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index){
    final boleto = _boletos![index];
    final venc = boleto.dataVencto;
    final valor = boleto.valorDoc;
    return Card(
      child: ListTile(
        leading: Icon(Icons.picture_as_pdf_outlined, size: 30.0),
        title: Text(boleto.morador?.nome ?? '?',
        style: TextStyle(color: Colors.grey.shade800, fontSize: 14.0)),
        subtitle: Text('Vencto: ${venc == null ? '?' : dd_MM_yyyy.format(venc)}'),
        trailing: Column(
          mainAxisSize:  MainAxisSize.min,
          crossAxisAlignment:  CrossAxisAlignment.end,
          children:[
            Text('R\$ ${valor == null ? '?': valorFmt.format(valor)}'),
            Text('${situacaoBoletoToStr(boleto.getSituacao())}'),
      ]))
    );
  }
}
