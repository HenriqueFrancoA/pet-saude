import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:pet_care/apis/pets_api.dart';
import 'package:pet_care/controllers/vacinas_controller.dart';
import 'package:pet_care/controllers/vermifugos_controller.dart';
import 'package:pet_care/controllers/versao_controller.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/utils/petsDAO.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pet_care/utils/vacinasDAO.dart';
import 'package:pet_care/utils/vermifugosDAO.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetsController extends GetxController {
  RxList pets = RxList();
  RxList petsAux = RxList();
  RxBool isLoading = false.obs;

  final PetsDAO petsDAO = PetsDAO();
  final VermifugosDAO vermifugosDAO = VermifugosDAO();
  final VacinasDAO vacinasDAO = VacinasDAO();

  final versaoController = Get.put(VersaoController());
  final vermifugosController = Get.put(VermifugosController());
  final vacinasController = Get.put(VacinasController());
  late Reference storageRef;

  Future<Pets> baixarImage(Pets pet) async {
    if (!pet.imagem!.contains("pet.png")) {
      String ref = pet.imagem!;
      Reference storageRef = FirebaseStorage.instance.ref().child(ref);

      String downloadURL = await storageRef.getDownloadURL();
      http.Response response = await http.get(Uri.parse(downloadURL));

      Directory? appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      final directoryPath = Directory("${appDocumentsDirectory.path}/pets");
      await directoryPath.create(recursive: true);

      String localImagePath = "${directoryPath.path}/${pet.id}.png";
      File localImageFile = File(localImagePath);
      bool exists = await localImageFile.exists();

      if (!exists) {
        await localImageFile.writeAsBytes(response.bodyBytes);
      }

      pet.localImagem = localImagePath;
    }

    await petsDAO.insertPet(pet);

    return pet;
  }

  carregarPets(String tutorId) async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int versaoAtual = prefs.getInt("versao") ?? 0;
    pets.clear();
    vermifugosController.vermifugos.clear();
    vacinasController.vacinas.clear();
    if (versaoAtual != versaoController.versao!.versao) {
      petsAux.addAll(await PetsApi.obterPets(tutorId));
      for (Pets pet in petsAux) {
        pets.add(await baixarImage(pet));
        vermifugosController.carregarVermifugos(pet.id!);
        vacinasController.carregarVacinas(pet.id!);
      }
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('versao', versaoController.versao!.versao!);
      });
      versaoAtual = versaoController.versao!.versao!;
    } else {
      petsAux.addAll(await petsDAO.getPetsByTutor(tutorId));
      for (Pets pet in petsAux) {
        pets.add(pet);
        vermifugosController.vermifugos
            .addAll(await vermifugosDAO.getVermifugosByPetId(pet.id!));
        vacinasController.vacinas
            .addAll(await vacinasDAO.getVacinasByPetId(pet.id!));
      }
    }
    petsAux.clear();
    isLoading.value = false;
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
    pets.add(pet);
  }

  Future<void> deletarPets() async {
    isLoading.value = true;
    for (Pets pet in pets) {
      if (pet.imagem != null && !pet.imagem!.contains("pet.png")) {
        final storageRef = FirebaseStorage.instance.ref().child(pet.imagem!);
        await storageRef.delete();
      }
      await PetsApi.deletarPet(pet.id!);
      await petsDAO.deletePet(pet.id!);
      if (pet.localImagem != null && File(pet.localImagem!).existsSync()) {
        File(pet.localImagem!).deleteSync();
      }
    }
    pets.clear();
    isLoading.value = false;
  }
}
