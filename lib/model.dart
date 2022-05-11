import 'package:app_condominios/utils.dart';
import 'package:uuid/uuid.dart';

class BaseEntity {
  String? id;

  BaseEntity({this.id}) {
    id ??= const Uuid().v4();
  }

  BaseEntity.fromMap(Map<String, dynamic> map) {
    id = map['id'];
  }
}
//Morador ----------------------------------------------------------------------
class Morador extends BaseEntity {
  Condominio? condominio;
  String? nome;
  String? cpf;
  DateTime? nascimento;
  int? apto;
  String? bloco;
  String? imagemAsset;

  Morador({String? id,
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
//Condominio -------------------------------------------------------------------
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
//Boleto-----------------------------------------------------------------------
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

  Boleto(String? id,
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
    dataVencto =
    map['dataVencto'] == null ? null : DateTime.tryParse(map['dataVencto']);
  }

  SituacaoBoleto getSituacao() {
    if (dataPagto != null) {
      return SituacaoBoleto.pago;
    }
    final hoje = today();
    if (dataVencto!.isBefore(hoje)) {
      return SituacaoBoleto.vencido;
    }
    return SituacaoBoleto.aberto;
  }
}
enum SituacaoBoleto { aberto, pago, vencido }

int? situacaoBoletoToId(SituacaoBoleto? sit) {
  if (sit == null) {
    return null;
  }
  switch (sit) {
    case SituacaoBoleto.aberto:
      return 1;
    case SituacaoBoleto.pago:
      return 2;
    case SituacaoBoleto.vencido:
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
      return SituacaoBoleto.aberto;
    case 2:
      return SituacaoBoleto.pago;
    case 3:
      return SituacaoBoleto.vencido;
    default:
      return null;
  }
}

String? situacaoBoletoToStr(SituacaoBoleto? sit) {
  if (sit == null) {
    return null;
  }
  switch (sit) {
    case SituacaoBoleto.aberto:
      return 'Aberto';
    case SituacaoBoleto.pago:
      return 'Pago';
    case SituacaoBoleto.vencido:
      return 'Vencido';
    default:
      return null;
  }
}

//Espaco -----------------------------------------------------------------------
class Espaco extends BaseEntity {
  Condominio? condominio;
  String? nome;
  TipoEspaco? tipo;

  Espaco({String? id, this.condominio, this.nome, this.tipo}) :super(id: id);

  Espaco.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    condominio =
    map['condominio'] == null ? null : Condominio.fromMap(map['condominio']);
    nome = map['nome'];
    tipo = idToTipoEspaco(map['tipo']);
  }
}
enum TipoEspaco {salaoFesta, quiosque, piscina, academia, salaJogos, quadraEsportiva, sauna, playGround}
int? tipoEspacoToId(TipoEspaco? tipo) {
  if (tipo == null) {
    return null;
  }
  switch (tipo) {
    case TipoEspaco.salaoFesta:
      return 1;
    case TipoEspaco.quiosque:
      return 2;
    case TipoEspaco.piscina:
      return 3;
    case TipoEspaco.academia:
      return 4;
    case TipoEspaco.salaJogos:
      return 5;
    case TipoEspaco.quadraEsportiva:
      return 6;
    case TipoEspaco.sauna:
      return 7;
    case TipoEspaco.playGround:
      return 8;
    default:
      return null;
  }
}
TipoEspaco? idToTipoEspaco(int? id) {
  if (id == null) {
    return null;
  }
  switch (id) {
    case 1:
      return TipoEspaco.salaoFesta;
    case 2:
      return TipoEspaco.quiosque;
    case 3:
      return TipoEspaco.piscina;
    case 4:
      return TipoEspaco.academia;
    case 5:
      return TipoEspaco.salaJogos;
    case 6:
      return TipoEspaco.quadraEsportiva;
    case 7:
      return TipoEspaco.sauna;
    case 8:
      return TipoEspaco.playGround;
    default:
      return null;
  }
}

//Reserva-----------------------------------------------------------------------
class Reserva extends BaseEntity {
  DateTime? data;
  Periodo? periodo;
  Espaco? espaco;
  Morador? morador;

  Reserva({String? id, this.data, this.periodo, this.espaco, this.morador})
      : super (id: id);

  Reserva.fromMap(Map<String, dynamic> map) : super.fromMap(map){
    data = map['data'] == null ? null : DateTime.tryParse(map['data']);
    periodo = periodoToId(map['periodo']);
    espaco = map['espaco'] == null ? null : Espaco.fromMap(map['espaco']);
    morador = map['morador'] == null ? null : Morador.fromMap(map['morador']);
  }
}
enum Periodo { manha, tarde, noite }
Periodo? periodoToId(int? id) {
  if (id == null) {
    return null;
  }
  switch (id) {
    case 1:
      return Periodo.manha;
    case 2:
      return Periodo.tarde;
    case 3:
      return Periodo.noite;
  }
}

int? idToPeriodo(Periodo? periodo) {
  if (periodo == null) {
    return null;
  }
  switch (periodo) {
    case Periodo.manha:
      return 1;
    case Periodo.tarde:
      return 2;
    case Periodo.noite:
      return 3;
  }
}
String? periodoToStr(Periodo? periodo) {
  if (periodo == null) {
    return null;
  }
  switch (periodo) {
    case Periodo.manha:
      return 'Manhã';
    case Periodo.tarde:
      return 'Tarde';
    case Periodo.noite:
      return 'Noite';
  }
}

String? periodoToStrHora(Periodo? periodo) {
  if (periodo == null) {
    return null;
  }
  switch (periodo) {
    case Periodo.manha:
      return '6:00 às 11:00';
    case Periodo.tarde:
      return '11:30 às 17:00';
    case Periodo.noite:
      return '17:30 às 23:30';
  }
}
//Usuario ----------------------------------------------------------------------
class Usuario extends BaseEntity {
  String? nomeUsuario;
  String? senha;
  PerfilUsuario? perfil;
  Morador? morador;

  Usuario({String? id, this.nomeUsuario, this.senha, this.perfil, this.morador})
      : super(id: id);

  Usuario.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    nomeUsuario = map['nomeUsuario'];
    senha = map['senha'];
    perfil = perfilUsuarioFromId(map['perfil']);
    morador = map['morador'] == null ? null : Morador.fromMap(map['morador']);
  }
}
enum PerfilUsuario { admin, morador }
int? perfilUsuarioToId(PerfilUsuario? perfil) {
  if (perfil == null) {
    return null;
  }
  switch (perfil) {
    case PerfilUsuario.admin:
      return 1;
    case PerfilUsuario.morador:
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
      return PerfilUsuario.admin;
    case 2:
      return PerfilUsuario.morador;
    default:
      return null;
  }
}
//Sessao -----------------------------------------------------------------------
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

