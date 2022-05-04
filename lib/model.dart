
import 'package:uuid/uuid.dart';

class BaseEntity{
  String? id;

  BaseEntity({this.id}){
   id ??= const Uuid().v4();
  }
}

class Morador extends BaseEntity{
  Condominio? condominio;
  String? nome;
  String? cpf;
  DateTime? nascimento;
  int? apto;
  String? bloco;
  String? imagemAsset;

  Morador({String? id,this.condominio,this.nascimento,this.cpf,this.nome,this.apto,this.bloco,this.imagemAsset}) : super(id: id);
}

class Condominio extends BaseEntity{
  String? nome;
  String? endereco;
  String? bairro;
  String? cidade;

  Condominio({String? id,this.nome, this.bairro,this.cidade,this.endereco}) : super(id:id);
}