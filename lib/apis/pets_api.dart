import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/models/dto/pets_dto.dart';
import 'package:pet_care/models/pets.dart';

abstract class PetsApi {
  static Future<String> criarPet(
    Pets pet,
  ) async {
    var db = FirebaseFirestore.instance;
    PetsDTO novoPet = PetsDTO(
      nome: pet.nome,
      raca: pet.raca,
      sexo: pet.sexo,
      nascimento: pet.nascimento,
      peso: pet.peso,
      tutor: pet.tutor,
    );
    try {
      DocumentReference doc = await db.collection("PETS").add(novoPet.toJson());
      return doc.id;
    } catch (e) {
      return '';
    }
  }

  static Future<dynamic> atualizarImagem(
    String id,
    String image,
  ) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("PETS").doc(id);
    documentRef.update({
      "IMAGEM": image,
    }).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<dynamic> atualizarPet(Pets pet) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("PETS").doc(pet.id);
    documentRef.update({
      "NOME": pet.nome,
      "RACA": pet.raca,
      "SEXO": pet.sexo,
      "NASCIMENTO": pet.nascimento,
      "PESO": pet.peso,
      "IMAGEM": pet.imagem,
    }).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<List<Pets>> obterPets(String idTutor) async {
    List<Pets> listPets = [];

    var db = FirebaseFirestore.instance;

    QuerySnapshot snapshot;

    try {
      snapshot =
          await db.collection("PETS").where("TUTOR", isEqualTo: idTutor).get();
    } catch (e) {
      return listPets;
    }

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Pets pets = Pets.fromSnapshot(doc);
        listPets.add(pets);
      }
    }

    return listPets;
  }

  static Future<dynamic> deletarPet(String id) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("PETS").doc(id);
    await documentRef.delete();
  }
}
