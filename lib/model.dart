import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final dd_MM_yyyy = DateFormat("dd/MM/yyyy", "pt-BR");

class BaseEntity {
  String? id;

  BaseEntity({this.id}) {
    id ??= const Uuid().v4();
  }
  BaseEntity.fromMap(Map<String, dynamic> map){
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

  Morador.fromMap(Map<String, dynamic> map) :super.fromMap(map) {
    condominio = map['condominio'] == null ? null : Condominio.fromMap(map['condominio']);
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

  Condominio({String? id, this.nome, this.bairro, this.cidade, this.endereco,this.uf})
      : super(id: id);

  Condominio.fromMap(Map<String, dynamic> map): super.fromMap(map){
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
  double? valor;
  double? percJuros;
  double? percMulta;
  double? valorJuros;
  double? valorMulta;
  double? valorFinal;
  DateTime? dataPago;
  double? valorPago;

  Boleto(
      String? id,
      this.morador,
      this.dataRef,
      this.dataEmissao,
      this.dataVencto,
      this.valor,
      this.percJuros,
      this.percMulta,
      this.valorJuros,
      this.valorMulta,
      this.valorFinal,
      this.dataPago,
      this.valorPago)
      : super(id: id);
}

class Usuario extends BaseEntity {
  String? nomeUsuario;
  String? senha;
  PerfilUsuario? perfil;
  Morador? morador;

  Usuario({String? id, this.nomeUsuario, this.senha, this.perfil, this.morador})
      : super(id: id);

  Usuario.fromMap(Map<String, dynamic> map){
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
