import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:pet_care/apis/vacinas_api.dart';
import 'package:pet_care/models/vacinas.dart';
import 'package:pet_care/utils/vacinasDAO.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VacinasController extends GetxController {
  RxList vacinas = RxList();
  RxList vacinasAux = RxList();

  final VacinasDAO vacinasDAO = VacinasDAO();
  late Reference storageRef;

  Future<Vacinas> baixarImage(Vacinas vacina) async {
    if (!vacina.imagem!.contains("vacina.jpg")) {
      String ref = vacina.imagem!;
      Reference storageRef = FirebaseStorage.instance.ref().child(ref);

      String downloadURL = await storageRef.getDownloadURL();
      http.Response response = await http.get(Uri.parse(downloadURL));

      Directory? appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      final directoryPath = Directory("${appDocumentsDirectory.path}/pets");
      await directoryPath.create(recursive: true);

      String localImagePath = "${directoryPath.path}/${vacina.id}.jpg";
      File localImageFile = File(localImagePath);
      bool exists = await localImageFile.exists();

      if (!exists) {
        await localImageFile.writeAsBytes(response.bodyBytes);
      }

      vacina.localImagem = localImagePath;
    }
    await vacinasDAO.insertVacina(vacina);

    return vacina;
  }

  carregarVacinas(String petId) async {
    vacinasAux.addAll(await VacinasApi.obterVacinas(petId));
    for (Vacinas vacina in vacinasAux) {
      vacinas.add(await baixarImage(vacina));
    }
    vacinasAux.clear();
  }

  criarVacina(Vacinas vacina) async {
    try {
      vacinasDAO.insertVacina(vacina);
      vacinas.add(vacina);
    } catch (e) {}
  }
}
