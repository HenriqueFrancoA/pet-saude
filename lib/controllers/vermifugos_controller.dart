import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:pet_care/apis/vermifugos_api.dart';
import 'package:pet_care/models/vermifugos.dart';
import 'package:pet_care/utils/vermifugosDAO.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VermifugosController extends GetxController {
  RxList vermifugos = RxList();
  RxList vermifugosAux = RxList();

  final VermifugosDAO vermifugosDAO = VermifugosDAO();
  late Reference storageRef;

  Future<Vermifugos> baixarImage(Vermifugos vermifugo) async {
    if (!vermifugo.imagem!.contains("vermifugo.jpg")) {
      String ref = vermifugo.imagem!;
      Reference storageRef = FirebaseStorage.instance.ref().child(ref);

      String downloadURL = await storageRef.getDownloadURL();
      http.Response response = await http.get(Uri.parse(downloadURL));

      Directory? appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      final directoryPath = Directory("${appDocumentsDirectory.path}/pets");
      await directoryPath.create(recursive: true);

      String localImagePath = "${directoryPath.path}/${vermifugo.id}.jpg";
      File localImageFile = File(localImagePath);
      bool exists = await localImageFile.exists();

      if (!exists) {
        await localImageFile.writeAsBytes(response.bodyBytes);
      }

      vermifugo.localImagem = localImagePath;
    }
    await vermifugosDAO.insertVermifugo(vermifugo);

    return vermifugo;
  }

  carregarVermifugos(String petId) async {
    vermifugosAux.addAll(await VermifugosApi.obterVermifugos(petId));
    for (Vermifugos vermifugo in vermifugosAux) {
      vermifugos.add(await baixarImage(vermifugo));
    }
    vermifugosAux.clear();
  }

  criarVermifugo(Vermifugos vermifugo) async {
    await vermifugosDAO.insertVermifugo(vermifugo);
    vermifugos.add(vermifugo);
  }
}
