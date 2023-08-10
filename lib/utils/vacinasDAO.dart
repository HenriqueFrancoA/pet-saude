import 'package:pet_care/models/vacinas.dart';
import 'package:pet_care/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class VacinasDAO {
  Future<int> insertVacina(Vacinas vacina) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'tb_vacinas',
      vacina.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateVacina(Vacinas vacina) async {
    final db = await DatabaseHelper().database;
    return await db.update('tb_vacinas', vacina.toMap(),
        where: 'id_vacina = ?', whereArgs: [vacina.id]);
  }

  Future<int> deleteVacina(int id) async {
    final db = await DatabaseHelper().database;
    return await db
        .delete('tb_vacinas', where: 'id_vacina = ?', whereArgs: [id]);
  }

  Future<List<Vacinas>> getVacinasByPetId(int petId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM tb_vacinas v INNER JOIN tb_pets p ON v.pet_local_id = p.id WHERE v.pet_local_id = ?',
      [petId.toString()],
    );
    return List.generate(maps.length, (index) => Vacinas.fromMap(maps[index]));
  }
}
