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
  RxList vermifugosPet = RxList();
  RxBool isLoading = false.obs;

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
      final directoryPath =
          Directory("${appDocumentsDirectory.path}/vermifugos");
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
    isLoading.value = true;
    RxList vermifugosAux = RxList();

    vermifugosAux.addAll(await VermifugosApi.obterVermifugos(petId));
    for (Vermifugos vermifugo in vermifugosAux) {
      vermifugos.add(await baixarImage(vermifugo));
    }
    isLoading.value = false;
  }

  criarVermifugo(Vermifugos vermifugo) async {
    await vermifugosDAO.insertVermifugo(vermifugo);
    vermifugos.add(vermifugo);
  }

  obterVermifugo(String petId) async {
    vermifugosPet.clear();
    for (Vermifugos vermifugo in vermifugos) {
      if (vermifugo.pet!.id == petId) {
        bool alreadyExists = vermifugosPet.any((v) => v.id == vermifugo.id);
        if (!alreadyExists) {
          vermifugosPet.add(vermifugo);
        }
      }
    }
  }

  Future<void> deletarVermifugos() async {
    isLoading.value = true;
    for (Vermifugos vermifugo in vermifugos) {
      if (vermifugo.imagem != null &&
          !vermifugo.imagem!.contains("vermifugo.jpg")) {
        final storageRef =
            FirebaseStorage.instance.ref().child(vermifugo.imagem!);
        await storageRef.delete();
      }
      await VermifugosApi.deletarVermifugo(vermifugo.id!);
      await vermifugosDAO.deleteVermifugo(vermifugo.id!);
      if (vermifugo.localImagem != null &&
          File(vermifugo.localImagem!).existsSync()) {
        File(vermifugo.localImagem!).deleteSync();
      }
    }
    vermifugos.clear();
    isLoading.value = false;
  }
}
