import 'package:app_condominios/utils.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final dd_MM_yyyy = DateFormat("dd/MM/yyyy", "pt-BR");
final valorFmt = NumberFormat("###,##0.00","pt_BR");

class BaseEntity {
  String? id;

  BaseEntity({this.id}) {
    id ??= const Uuid().v4();
  }

  BaseEntity.fromMap(Map<String, dynamic> map) {
    id = map['id'];
  }
}

class Morador extends BaseEntity {
  Condominio? condominio;
  String? nome;
  String? cpf;
  DateTime? nascimento;
  int? apto;
  String? bloco;
  String? imagemAsset;

  Morador(
      {String? id,
      this.condominio,
      this.nascimento,
      this.cpf,
      this.nome,
      this.apto,
      this.bloco,
      this.imagemAsset})
      : super(id: id);

  Morador.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    condominio = map['condominio'] == null
        ? null
        : Condominio.fromMap(map['condominio']);
    nome = map['nome'];
    cpf = map['cpf'];
    nascimento =
        map['nascimento'] == null ? null : DateTime.tryParse(map['nascimento']);
    apto = map['apto'];
    bloco = map['bloco'];
    imagemAsset = map['imagemAsset'];
  }

  static int compararAptoAsc(Morador a, Morador b) {
    return (a.apto ?? 0).compareTo(b.apto ?? 0);
  }

  static int compararAptoDesc(Morador a, Morador b) {
    return (b.apto ?? 0).compareTo(a.apto ?? 0);
  }

  static int compararNomeAsc(Morador a, Morador b) {
    return (a.nome?.toLowerCase() ?? '').compareTo(b.nome?.toLowerCase() ?? '');
  }

  static int compararNomeDesc(Morador a, Morador b) {
    return (b.nome?.toLowerCase() ?? '').compareTo(a.nome?.toLowerCase() ?? '');
  }
}

class Condominio extends BaseEntity {
  String? nome;
  String? endereco;
  String? bairro;
  String? cidade;
  String? uf;

  Condominio(
      {String? id, this.nome, this.bairro, this.cidade, this.endereco, this.uf})
      : super(id: id);

  Condominio.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    nome = map['nome'];
    endereco = map['endereco'];
    bairro = map['bairro'];
    cidade = map['cidade'];
    uf = map['uf'];
  }
}

class Boleto extends BaseEntity {
  Morador? morador;
  DateTime? dataRef;
  DateTime? dataEmissao;
  DateTime? dataVencto;
  double? valorDoc;
  double? percJuros;
  double? percMulta;
  double? valorJuros;
  double? valorMulta;
  double? valorFinal;
  DateTime? dataPagto;
  double? valorPago;

  Boleto(
      String? id,
      this.morador,
      this.dataRef,
      this.dataEmissao,
      this.dataVencto,
      this.valorDoc,
      this.percJuros,
      this.percMulta,
      this.valorJuros,
      this.valorMulta,
      this.valorFinal,
      this.dataPagto,
      this.valorPago)
      : super(id: id);

  Boleto.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    morador = map['morador'] == null ? null : Morador.fromMap(map['morador']);
    dataRef = map['dataRef'] == null ? null : DateTime.tryParse(map['dataRef']);
    dataEmissao =
        map['dataEmissao'] == null ? null : DateTime.tryParse(map['dataEmissao']);
    valorDoc = map['valorDoc'];
    percJuros = map['percJuros'];
    percMulta = map['percMulta'];
    valorJuros = map['valorJuros'];
    valorMulta = map['valorMulta'];
    valorFinal = map['valorFinal'];
    dataPagto =
        map['dataPagto'] == null ? null : DateTime.tryParse(map['dataPagto']);
    valorPago = map['valorPAgo'];
    dataVencto =  map['dataVencto'] == null ? null : DateTime.tryParse(map['dataVencto']);
  }
  SituacaoBoleto getSituacao(){
    if(dataPagto != null){
      return SituacaoBoleto.PAGO;
    }
    final hoje = today();
    if(dataVencto!.isBefore(hoje)){
      return SituacaoBoleto.VENCIDO;
    }
    return SituacaoBoleto.ABERTO;
  }
}

class Usuario extends BaseEntity {
  String? nomeUsuario;
  String? senha;
  PerfilUsuario? perfil;
  Morador? morador;

  Usuario({String? id, this.nomeUsuario, this.senha, this.perfil, this.morador})
      : super(id: id);

  Usuario.fromMap(Map<String, dynamic> map) {
    nomeUsuario = map['nomeUsuario'];
    senha = map['senha'];
    perfil = perfilUsuarioFromId(map['perfil']);
    morador = map['morador'] == null ? null : Morador.fromMap(map['morador']);
  }
}

class Sessao {
  String? token;
  Usuario? usuario;
  DateTime? inicio;

  Sessao({this.token, this.usuario, this.inicio});

  Sessao.fromMap(Map<String, dynamic> map) {
    token = map['token'];
    usuario = map['usuario'] == null ? null : Usuario.fromMap(map['usuario']);
    inicio = map['inicio'] == null ? null : DateTime.tryParse(map['inicio']);
  }
}

enum PerfilUsuario { ADMIN, MORADOR }

enum SituacaoBoleto { ABERTO, PAGO, VENCIDO }

int? perfilUsuarioToId(PerfilUsuario? perfil) {
  if (perfil == null) {
    return null;
  }
  switch (perfil) {
    case PerfilUsuario.ADMIN:
      return 1;
    case PerfilUsuario.MORADOR:
      return 2;
    default:
      return null;
  }
}

PerfilUsuario? perfilUsuarioFromId(int? id) {
  if (id == null) {
    return null;
  }
  switch (id) {
    case 1:
      return PerfilUsuario.ADMIN;
    case 2:
      return PerfilUsuario.MORADOR;
    default:
      return null;
  }
}

int? situacaoBoletoToId(SituacaoBoleto? sit) {
  if (sit == null) {
    return null;
  }
  switch (sit) {
    case SituacaoBoleto.ABERTO:
      return 1;
    case SituacaoBoleto.PAGO:
      return 2;
    case SituacaoBoleto.VENCIDO:
      return 3;
    default:
      return null;
  }
}

SituacaoBoleto? situacaoBoletoFromId(int? id) {
  if (id == null) {
    return null;
  }
  switch (id) {
    case 1:
      return SituacaoBoleto.ABERTO;
    case 2:
      return SituacaoBoleto.PAGO;
    case 3:
      return SituacaoBoleto.VENCIDO;
    default:
      return null;
  }
}
String? situacaoBoletoToStr(SituacaoBoleto? sit) {
  if (sit == null) {
    return null;
  }
  switch (sit) {
    case SituacaoBoleto.ABERTO:
      return 'Aberto';
    case SituacaoBoleto.PAGO:
      return 'Pago';
    case SituacaoBoleto.VENCIDO:
      return 'Vencido';
    default:
      return null;
  }
}
