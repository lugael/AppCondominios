import 'package:sqflite/sqflite.dart';

const dbVersion = 2;

abstract class DBupgrader {
  Future<void> execute(Database db) async {}
}

DBupgrader? getUpgrader(int version) {
  switch (version) {
    case 1:
      return DBupgraderV1();
    case 2:
      return DBupgraderV2();
    default:
      return null;
  }
}

class DBupgraderV1 extends DBupgrader {
  @override
  Future<void> execute(Database db) async {
    db.execute("""
      CREATE TABLE sessao(
        token VARCHAR(100),
        usuario_id char(36),
        usuario_nome VARCHAR(100),
        usuario_perfil INTEGER,
        morador_id char(36),
        morador_nome VARCHAR(200),
        datahora_inicio INTEGER)
      """);
  }
}

class DBupgraderV2 extends DBupgrader {
  @override
  Future<void> execute(Database db) async {
    db.execute("ALTER TABLE sessao ADD condominio_id CHAR(36)");
    db.execute("ALTER TABLE sessao ADD condominio_nome VARCHAR(100)");
  }
}
