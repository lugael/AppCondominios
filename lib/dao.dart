import 'package:app_condominios/dbupgrade.dart';
import 'package:app_condominios/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DAO{
  static final DAO _dao= DAO._create();
  Database? db;
  DAO._create();

  static DAO get(){
    return _dao;
  }

  Future<void> _initDBIfNeeded() async{
    if(db == null){
      await _init();
    }
  }

  Future<void> open() async{
    await _initDBIfNeeded();
    db?.close();
    db = null;
  }

  Future _init() async{
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "condoapp.db");
    db = await openDatabase(path, version:  dbVersion, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async{
    print("Criando Banco de dados");
    await _upgradeDB(db,0,version);
  }
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async{
    for (int v = oldVersion +1 ; v <=newVersion; v++){
      print("Atualizando banco de dados(versão ${v - 1} para $v)...");
      await getUpgrader(v)?.execute(db);
      print("Atualizando para versão $v!");
    }
  }

  Future<void> saveSessao(Sessao sessao) async{
    await _initDBIfNeeded();
    await db!.delete('sessao');
    await db!.insert('sessao', _mapSessao(sessao));
  }

  Future<Sessao?> findSessao() async{
    await _initDBIfNeeded();
    final rows = await db!.query('sessao',limit: 1);
    if(rows.isEmpty){
      return null;
    }
    return _sessao(rows.first);
  }

  Future<void> deleteSessao() async{
    await _initDBIfNeeded();
    await db!.delete('sessoa');
  }

  Map<String, dynamic> _mapSessao(Sessao sessao){
    return{
      'token': sessao.token,
      'usuario_id': sessao.usuario?.id,
      'usuario_nome': sessao.usuario?.nomeUsuario,
      'usuario_perfil': perfilUsuarioToId(sessao.usuario?.perfil),
      'morador_id': sessao.usuario?.morador?.id,
      'morador_nome': sessao.usuario?.morador?.nome,
      'datahora_inicio': sessao.inicio?.millisecondsSinceEpoch
    };
  }
  Sessao _sessao(Map<String, dynamic> map){
    return Sessao(
      token: map['token'],
      usuario: Usuario(
        id: map['usuario_id'],
        nomeUsuario: map['usuario_nome'],
        perfil: perfilUsuarioFromId(map['usuario_perfil']),
        morador: Morador(id: map['morador_id'], nome: map['morador_nome'])),
      inicio: map['datahora_inicio'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['datahora_inicio'])
    );
  }
}