import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:pet_care/apis/pets_api.dart';
import 'package:pet_care/controllers/vacinas_controller.dart';
import 'package:pet_care/controllers/vermifugos_controller.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/utils/petsDAO.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PetsController extends GetxController {
  RxList pets = RxList();
  RxList petsAux = RxList();

  final PetsDAO petsDAO = PetsDAO();
  final vermifugosController = Get.put(VermifugosController());
  final vacinasController = Get.put(VacinasController());
  late Reference storageRef;

  Future<Pets> baixarImage(Pets pet) async {
    if (!pet.imagem!.contains("pet.png")) {
      // Pegar o caminho (referência) da imagem no Firebase Storage
      String ref = pet.imagem!;
      Reference storageRef = FirebaseStorage.instance.ref().child(ref);

      // Fazer o download da imagem a partir do URL
      String downloadURL = await storageRef.getDownloadURL();
      http.Response response = await http.get(Uri.parse(downloadURL));

      // Obter o diretório de armazenamento externo do aplicativo
      Directory? appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      final directoryPath = Directory("${appDocumentsDirectory.path}/pets");
      await directoryPath.create(recursive: true);

      // Verificar se a imagem local já existe
      String localImagePath = "${directoryPath.path}/${pet.id}.jpg";
      File localImageFile = File(localImagePath);
      bool exists = await localImageFile.exists();

      // Salvar a imagem no armazenamento local apenas se ela ainda não existir
      if (!exists) {
        await localImageFile.writeAsBytes(response.bodyBytes);
      }

      // Atualizar o atributo localImagem do objeto Pets com o caminho da imagem local
      pet.localImagem = localImagePath;
    }

    // Inserir ou atualizar o registro do pet no banco de dados local
    await petsDAO.insertPet(pet);

    return pet;
  }

  carregarPets(String tutorId) async {
    pets.clear();
    vermifugosController.vermifugos.clear();
    vacinasController.vacinas.clear();
    petsAux.addAll(await PetsApi.obterPets(tutorId));
    for (Pets pet in petsAux) {
      pets.add(await baixarImage(pet));
      vermifugosController.carregarVermifugos(pet.id!);
      vacinasController.carregarVacinas(pet.id!);
    }
    petsAux.clear();
  }

  atualizarPet(Pets pet) async {
    await petsDAO.updatePet(pet);
    int index = pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      pets[index] = pet;
      pets.refresh();
    }
  }

  criarPet(Pets pet) async {
    await petsDAO.insertPet(pet);
    pets.add(await baixarImage(pet));
  }
}
