import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String _databaseName = "petsaude.db";
  final int _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE tb_pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_firebase TEXT,
        nome TEXT,
        raca TEXT,
        sexo TEXT,
        nascimento TIMESTAMP,
        peso DOUBLE,
        imagem TEXT,
        tutor TEXT,
        local_imagem TEXT
      )
    """);

    await db.execute("""
      CREATE TABLE tb_vacinas (
        id_vacina INTEGER PRIMARY KEY AUTOINCREMENT,
        id_vacina_firebase TEXT,
        nome_vacina TEXT,
        peso_vacina DOUBLE,
        dose DOUBLE,
        data_vacinacao TIMESTAMP,
        proxima_vacinacao TIMESTAMP,
        pet_local_id INTEGER,
        imagem_vacina TEXT,
        local_imagem_vacina TEXT,
        FOREIGN KEY(pet_local_id) REFERENCES tb_pets(id)
      )
    """);

    await db.execute("""
      CREATE TABLE tb_vermifugos (
        id_vermifugo INTEGER PRIMARY KEY AUTOINCREMENT,
        id_vermifugo_firebase TEXT,
        nome_vermifugo TEXT,
        peso_vermifugo DOUBLE,
        dose DOUBLE,
        data_vacinacao TIMESTAMP,
        proxima_vacinacao TIMESTAMP,
        pet_local_id INTEGER,
        imagem_vermifugo TEXT,
        local_imagem_vermifugo TEXT,
        FOREIGN KEY(pet_local_id) REFERENCES tb_pets(id)
      )
    """);
  }

  Future<void> deleteAndCloseDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);

    final databaseFile = File(path);

    if (await databaseFile.exists()) {
      await databaseFile.delete();
    } else {}
  }
}
