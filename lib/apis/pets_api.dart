import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/models/dto/pets_dto.dart';
import 'package:pet_care/models/pets.dart';

abstract class PetsApi {
  static Future<String> criarPet(
    String nome,
    String raca,
    String sexo,
    Timestamp nascimento,
    double peso,
    String tutor,
  ) async {
    var db = FirebaseFirestore.instance;
    PetsDTO pet = PetsDTO(
      nome: nome,
      raca: raca,
      sexo: sexo,
      nascimento: nascimento,
      peso: peso,
      tutor: tutor,
    );
    try {
      DocumentReference doc = await db.collection("PETS").add(pet.toJson());
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

  static Future<dynamic> atualizarPet(
    String id,
    String nome,
    String raca,
    String sexo,
    Timestamp nascimento,
    double peso,
    String imagem,
  ) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("PETS").doc(id);
    documentRef.update({
      "NOME": nome,
      "RACA": raca,
      "SEXO": sexo,
      "NASCIMENTO": nascimento,
      "PESO": peso,
      "IMAGEM": imagem,
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
