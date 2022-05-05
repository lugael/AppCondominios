import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
final dd_MM_yyyy = DateFormat("dd/MM/yyyy","pt-BR");
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
  static int compararAptoAsc(Morador a, Morador b){
    return (a.apto ?? 0).compareTo(b.apto ?? 0);
  }
  static int compararAptoDesc(Morador a, Morador b){
    return (b.apto ?? 0).compareTo(a.apto ?? 0);
  }
  static int compararNomeAsc(Morador a, Morador b){
    return (a.nome?.toLowerCase() ?? '').compareTo(b.nome?.toLowerCase() ?? '');
  }
  static int compararNomeDesc(Morador a, Morador b){
    return (b.nome?.toLowerCase() ?? '').compareTo(a.nome?.toLowerCase() ?? '');
  }
}

class Condominio extends BaseEntity{
  String? nome;
  String? endereco;
  String? bairro;
  String? cidade;

  Condominio({String? id,this.nome, this.bairro,this.cidade,this.endereco}) : super(id:id);
}