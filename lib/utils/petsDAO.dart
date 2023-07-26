import 'package:pet_care/models/pets.dart';
import 'package:pet_care/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class PetsDAO {
  Future<int> insertPet(Pets pet) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'tb_pets',
      pet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePet(Pets pet) async {
    final db = await DatabaseHelper().database;
    return await db
        .update('tb_pets', pet.toMap(), where: 'id = ?', whereArgs: [pet.id]);
  }

  Future<int> deletePet(String id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('tb_pets', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Pets>> getPetsByTutor(String tutor) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps =
        await db.query('tb_pets', where: 'tutor = ?', whereArgs: [tutor]);
    return List.generate(maps.length, (index) => Pets.fromMap(maps[index]));
  }
}
