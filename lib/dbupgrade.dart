
import 'package:sqflite/sqflite.dart';

const dbVersion = 1;
abstract class DBupgrader{
  Future<void> execute(Database db) async{}
}

DBupgrader? getUpgrader(int version){
  switch(version){
    case 1:
      return DBupgraderV1();
    default:
      return null;
  }
}
class DBupgraderV1 extends DBupgrader{
  @override
  Future<void> execute(Database db) async{
    db.execute(
      """
      CREATE TABLE sessao(
        token VARCHAR(100),
        usuario_id char(36),
        usuario_nome VARCHAR(100),
        usuario_perfil INTEGER,
        morador_id char(36),
        morador_nome VARCHAR(200),
        datahora_inicio INTEGER)
      """
    );
  }
}