import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/models/dto/vacinas_dto.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/models/vacinas.dart';

abstract class VacinasApi {
  static Future<String> criarVacina(Vacinas vacina) async {
    var db = FirebaseFirestore.instance;
    VacinasDTO vacinas = VacinasDTO(
      nome: vacina.nome,
      peso: vacina.peso,
      dose: vacina.dose,
      dataVacinacao: vacina.dataVacinacao,
      proximaVacinacao: vacina.proximaVacinacao,
      pet: db.doc("PETS/${vacina.pet!.id}"),
    );
    try {
      DocumentReference doc =
          await db.collection("VACINAS").add(vacinas.toJson());
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
    DocumentReference documentRef = db.collection("VACINAS").doc(id);
    documentRef.update({
      "IMAGEM": image,
    }).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<List<Vacinas>> obterVacinas(String idPet) async {
    List<Vacinas> listPets = [];
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot;

    try {
      snapshot = await db
          .collection("VACINAS")
          .where("PET", isEqualTo: db.doc("PETS/$idPet"))
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          DocumentSnapshot petDoc = await doc['PET'].get();
          Map<String, dynamic> dataPet = petDoc.data() as Map<String, dynamic>;

          Pets? pet = Pets(
            id: petDoc.id,
            nome: dataPet['NOME'],
            peso: dataPet['PESO'],
            raca: dataPet['RACA'],
            sexo: dataPet['SEXO'],
            imagem: dataPet['IMAGEM'],
            nascimento: dataPet['NASCIMENTO'],
            tutor: dataPet['TUTOR'],
          );

          Map<String, dynamic> dataServico = doc.data() as Map<String, dynamic>;
          Vacinas? vacinas = Vacinas(
            idFirebase: doc.id,
            nome: dataServico['NOME'],
            peso: dataServico['PESO'],
            dose: dataServico['DOSE'],
            dataVacinacao: dataServico['DATA_VACINACAO'],
            proximaVacinacao: dataServico['PROXIMA_VACINACAO'],
            imagem: dataServico['IMAGEM'],
            pet: pet,
            localPet: pet,
          );

          listPets.add(vacinas);
        }
      }
      return listPets;
    } catch (e) {
      return listPets;
    }
  }

  static Future<dynamic> deletarVacina(String id) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("VACINAS").doc(id);
    await documentRef.delete();
  }
}
