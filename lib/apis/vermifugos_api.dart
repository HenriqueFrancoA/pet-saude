import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/models/dto/vermifugos_dto.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/models/vermifugos.dart';

abstract class VermifugosApi {
  static Future<String> criarVermifugo(Vermifugos vermifugos) async {
    var db = FirebaseFirestore.instance;
    VermifugosDTO vermifugo = VermifugosDTO(
      nome: vermifugos.nome,
      peso: vermifugos.peso,
      dose: vermifugos.dose,
      dataVacinacao: vermifugos.dataVacinacao,
      proximaVacinacao: vermifugos.proximaVacinacao,
      pet: db.doc("PETS/${vermifugos.pet!.id}"),
    );
    try {
      DocumentReference doc =
          await db.collection("VERMIFUGOS").add(vermifugo.toJson());
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
    DocumentReference documentRef = db.collection("VERMIFUGOS").doc(id);
    documentRef.update({
      "IMAGEM": image,
    }).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<List<Vermifugos>> obterVermifugos(String idPet) async {
    List<Vermifugos> listPets = [];
    var db = FirebaseFirestore.instance;
    QuerySnapshot snapshot;

    try {
      snapshot = await db
          .collection("VERMIFUGOS")
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
          Vermifugos? vermifugos = Vermifugos(
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

          listPets.add(vermifugos);
        }
      }
      return listPets;
    } catch (e) {
      return listPets;
    }
  }

  static Future<dynamic> deletarVermifugo(String id) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("VERMIFUGOS").doc(id);
    await documentRef.delete();
  }
}
