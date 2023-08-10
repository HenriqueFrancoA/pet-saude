import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:pet_care/apis/pets_api.dart';
import 'package:pet_care/controllers/login_controller.dart';
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
  RxBool isLoading = false.obs;

  final PetsDAO petsDAO = PetsDAO();
  final VermifugosDAO vermifugosDAO = VermifugosDAO();
  final VacinasDAO vacinasDAO = VacinasDAO();

  final versaoController = Get.put(VersaoController());
  final vermifugosController = Get.put(VermifugosController());
  final vacinasController = Get.put(VacinasController());
  final loginController = Get.put(LoginController());
  late Reference storageRef;

  String? localImagePath;

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

      localImagePath = "${directoryPath.path}/${pet.id}.png";
      File localImageFile = File(localImagePath!);
      bool exists = await localImageFile.exists();

      if (!exists) {
        await localImageFile.writeAsBytes(response.bodyBytes);
      }

      pet.localImagem = localImagePath;
    }

    int idPet = await petsDAO.insertPet(pet);
    pet.idLocal = idPet;

    return pet;
  }

  Future<String> saveToLocalFile(
      File? imageFile, Pets novopet, bool imagemSelecionada) async {
    Directory? appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final directoryPath = Directory("${appDocumentsDirectory.path}/pets");
    await directoryPath.create(recursive: true);

    if (novopet.id != null) {
      localImagePath = "${appDocumentsDirectory.path}/pets/${novopet.id}.png";
    } else {
      localImagePath = "${appDocumentsDirectory.path}/pets/${novopet.id}.png";
    }

    try {
      if (imageFile != null) {
        await imageFile.copy(localImagePath!);
        novopet.localImagem = localImagePath!;
      } else {
        localImagePath = '';
      }
    } catch (e) {
      print(e);
    }

    return localImagePath!;
  }

  Future<UploadTask?> upload(String path, String idPet) async {
    File file = File(path);
    try {
      String ref = 'pets/$idPet.png';
      final storageRef = FirebaseStorage.instance.ref();
      storageRef.child(ref).delete();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=600",
              contentType: "image/png",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage(
      Pets pet, File? croppedImage, bool imagemSelecionada) async {
    File? file = croppedImage;
    if (file != null && pet.id != null) {
      await upload(file.path, pet.id!);
    }
    await saveToLocalFile(file, pet, imagemSelecionada);
  }

  carregarPets(String tutorId) async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int versaoAtual = prefs.getInt("versao") ?? 0;
    RxList petsAux = RxList();
    pets.clear();
    vermifugosController.vermifugos.clear();
    vacinasController.vacinas.clear();
    if (versaoController.versao != null &&
        versaoController.versao!.versao != null &&
        versaoAtual != versaoController.versao!.versao) {
      petsAux.addAll(await PetsApi.obterPets(tutorId));
      for (Pets pet in petsAux) {
        pet = await baixarImage(pet);
        pets.add(pet);
        vermifugosController.carregarVermifugos(pet);
        vacinasController.carregarVacinas(pet);
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
            .addAll(await vermifugosDAO.getVermifugosByPetId(pet.idLocal!));
        vacinasController.vacinas
            .addAll(await vacinasDAO.getVacinasByPetId(pet.idLocal!));
      }
    }
    petsAux.clear();
    isLoading.value = false;
  }

  atualizarPet(Pets pet, bool imagemSelecionada, File? croppedImage) async {
    if (imagemSelecionada &&
        pet.imagem != null &&
        pet.imagem!.contains("pet.png") &&
        pet.id != null) {
      pet.imagem = 'pets/${pet.id}.png';
    } else if (imagemSelecionada &&
        pet.imagem != null &&
        pet.imagem!.contains("pet.png")) {
      pet.imagem = 'pets/${pet.id}.png';
    }
    if (pet.id != null) {
      PetsApi.atualizarPet(pet);
      versaoController.atualizarVersao();
    }

    await pickAndUploadImage(pet, croppedImage, imagemSelecionada);
    if (pet.localImagem == null || pet.localImagem == "") {
      pet.localImagem = localImagePath;
    }
    await petsDAO.updatePet(pet);
    if (pet.id != null) {
      int index = pets.indexWhere((p) => p.idLocal == pet.idLocal);
      if (index != -1) {
        pets[index] = pet;
        pets.refresh();
      }
    } else {
      int index = pets.indexWhere((p) => p.idLocal == pet.idLocal);
      if (index != -1) {
        pets[index] = pet;
        pets.refresh();
      }
    }
  }

  criarPet(Pets novoPet, bool imagemSelecionada, File? croppedImage) async {
    if (loginController.uID.value != "DEFAULT") {
      await PetsApi.criarPet(novoPet).then((String id) {
        novoPet.id = id;
        versaoController.atualizarVersao();
        if (imagemSelecionada) {
          PetsApi.atualizarImagem(id, 'pets/$id.png');
        } else {
          PetsApi.atualizarImagem(id, 'pets/pet.png');
        }
      });
    }
    int idPet = await petsDAO.insertPet(novoPet);
    novoPet.idLocal = idPet;
    await pickAndUploadImage(novoPet, croppedImage, imagemSelecionada);
    novoPet.localImagem = localImagePath;
    petsDAO.updatePet(novoPet);
    pets.add(novoPet);
  }

  Future<void> deletarPets(bool limpar) async {
    isLoading.value = true;
    for (Pets pet in pets) {
      if (loginController.uID.value != "DEFAULT" && !limpar) {
        if (pet.imagem != null && !pet.imagem!.contains("pet.png")) {
          final storageRef = FirebaseStorage.instance.ref().child(pet.imagem!);
          await storageRef.delete();
        }
        await PetsApi.deletarPet(pet.id!);
      }
      if (pet.localImagem != null && File(pet.localImagem!).existsSync()) {
        File(pet.localImagem!).deleteSync();
      }
    }
    await petsDAO.excluirBanco();
    pets.clear();
    isLoading.value = false;
  }
}
