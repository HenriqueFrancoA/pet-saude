import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_care/models/dto/versao_dto.dart';
import 'package:pet_care/models/versao.dart';

abstract class VersaoApi {
  static Future<Versao?> criarVersao(
    String uId,
    int versao,
  ) async {
    var db = FirebaseFirestore.instance;
    VersaoDTO versaoDto = VersaoDTO(
      uId: uId,
      versao: versao,
    );
    try {
      DocumentReference doc =
          await db.collection("VERSAO").add(versaoDto.toJson());

      Versao versaoCriada = Versao(
        id: doc.id,
        uId: uId,
        versao: versao,
      );
      return versaoCriada;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> atualizarVersao(
    String id,
    String uId,
    int versao,
  ) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("VERSAO").doc(id);
    documentRef.update({
      "UID": uId,
      "VERSAO": versao,
    }).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  static Future<Versao?> obterVersao(String uId) async {
    Versao? versao;

    var db = FirebaseFirestore.instance;

    QuerySnapshot snapshot;

    try {
      snapshot =
          await db.collection("VERSAO").where("UID", isEqualTo: uId).get();
    } catch (e) {
      return null;
    }

    if (snapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        versao = Versao.fromSnapshot(doc);
      }
    } else {
      versao = await criarVersao(uId, 1);
    }

    return versao;
  }

  static Future<dynamic> deletarVersao(String id) async {
    var db = FirebaseFirestore.instance;
    DocumentReference documentRef = db.collection("VERSAO").doc(id);
    await documentRef.delete();
  }
}
