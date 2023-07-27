import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final String _databaseName = "topservicedb6.db";
  static final int _databaseVersion = 1;

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
        id TEXT PRIMARY KEY,
        nome TEXT,
        raca TEXT,
        sexo TEXT,
        nascimento TEXT,
        peso TEXT,
        imagem TEXT,
        tutor TEXT,
        local_imagem TEXT
      )
    """);

    await db.execute("""
      CREATE TABLE tb_vacinas (
        id TEXT PRIMARY KEY,
        nome TEXT,
        peso TEXT,
        dose TEXT,
        data_vacinacao TEXT,
        proxima_vacinacao TEXT,
        pet_id TEXT,
        imagem TEXT,
        local_imagem TEXT,
        FOREIGN KEY(pet_id) REFERENCES tb_pets(id)
      )
    """);

    await db.execute("""
      CREATE TABLE tb_vermifugos (
        id TEXT PRIMARY KEY,
        nome TEXT,
        peso TEXT,
        dose TEXT,
        data_vacinacao TEXT,
        proxima_vacinacao TEXT,
        pet_id TEXT,
        imagem TEXT,
        local_imagem TEXT,
        FOREIGN KEY(pet_id) REFERENCES tb_pets(id)
      )
    """);
  }
}
