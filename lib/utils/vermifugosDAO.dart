import 'package:pet_care/models/vermifugos.dart';
import 'package:pet_care/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class VermifugosDAO {
  Future<int> insertVermifugo(Vermifugos vermifugo) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'tb_vermifugos',
      vermifugo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateVermifugo(Vermifugos vermifugo) async {
    final db = await DatabaseHelper().database;
    return await db.update('tb_vermifugos', vermifugo.toMap(),
        where: 'id_vermifugo = ?', whereArgs: [vermifugo.id]);
  }

  Future<int> deleteVermifugo(int id) async {
    final db = await DatabaseHelper().database;
    return await db
        .delete('tb_vermifugos', where: 'id_vermifugo = ?', whereArgs: [id]);
  }

  Future<List<Vermifugos>> getVermifugosByPetId(int petId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM tb_vermifugos v INNER JOIN tb_pets p ON v.pet_local_id = p.id WHERE v.pet_local_id = ?',
      [petId.toString()],
    );
    return List.generate(
        maps.length, (index) => Vermifugos.fromMap(maps[index]));
  }
}
