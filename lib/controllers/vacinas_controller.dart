import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:pet_care/apis/vacinas_api.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/controllers/versao_controller.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/models/vacinas.dart';
import 'package:pet_care/utils/vacinasDAO.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VacinasController extends GetxController {
  RxList vacinas = RxList();
  RxList vacinasPet = RxList();
  RxBool isLoading = false.obs;
  String localImagePath = '';

  final VacinasDAO vacinasDAO = VacinasDAO();
  late Reference storageRef;

  final loginController = Get.put(LoginController());
  final versaoController = Get.put(VersaoController());

  Future<Vacinas> baixarImage(Vacinas vacina, Pets pet) async {
    if (!vacina.imagem!.contains("vacina.jpg")) {
      String ref = vacina.imagem!;
      Reference storageRef = FirebaseStorage.instance.ref().child(ref);

      String downloadURL = await storageRef.getDownloadURL();
      http.Response response = await http.get(Uri.parse(downloadURL));

      Directory? appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      final directoryPath = Directory("${appDocumentsDirectory.path}/vacinas");
      await directoryPath.create(recursive: true);

      String localImagePath = "${directoryPath.path}/${vacina.idFirebase}.jpg";
      File localImageFile = File(localImagePath);
      bool exists = await localImageFile.exists();

      if (!exists) {
        await localImageFile.writeAsBytes(response.bodyBytes);
      }

      vacina.localImagem = localImagePath;
    }
    vacina.localPet = pet;
    await vacinasDAO.insertVacina(vacina);

    return vacina;
  }

  Future<UploadTask?> upload(String path, String id) async {
    File file = File(path);
    try {
      String ref = 'vacinas/$id.jpg';
      final storageRef = FirebaseStorage.instance.ref();
      storageRef.child(ref).delete();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=600",
              contentType: "image/jpg",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future<String> saveToLocalFile(
      File? imageFile, Vacinas vacina, bool imagemSelecionada) async {
    Directory? appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final directoryPath = Directory("${appDocumentsDirectory.path}/vacinas");
    await directoryPath.create(recursive: true);

    if (vacina.idFirebase != null) {
      localImagePath =
          "${appDocumentsDirectory.path}/vacinas/${vacina.idFirebase}.jpg";
    } else {
      localImagePath = "${appDocumentsDirectory.path}/vacinas/${vacina.id}.jpg";
    }

    try {
      if (imageFile != null) {
        await imageFile.copy(localImagePath);
        vacina.localImagem = localImagePath;
      } else {
        localImagePath = '';
      }
    } catch (e) {
      print(e);
    }

    return localImagePath;
  }

  pickAndUploadImage(
      Vacinas vacina, File? croppedImage, bool imagemSelecionada) async {
    File? file = croppedImage;
    if (file != null && vacina.idFirebase != null) {
      await upload(file.path, vacina.idFirebase!);
    }
    await saveToLocalFile(file, vacina, imagemSelecionada);
  }

  carregarVacinas(Pets pet) async {
    isLoading.value = true;
    RxList vacinasAux = RxList();

    vacinasAux.addAll(await VacinasApi.obterVacinas(pet.id!));
    for (Vacinas vacina in vacinasAux) {
      vacinas.add(await baixarImage(vacina, pet));
    }
    isLoading.value = false;
  }

  criarVacina(
      Vacinas novaVacina, File? croppedImage, bool imagemSelecionada) async {
    if (loginController.uID.value != "DEFAULT") {
      await VacinasApi.criarVacina(novaVacina).then((String id) {
        novaVacina.idFirebase = id;
        versaoController.atualizarVersao();
        if (imagemSelecionada) {
          VacinasApi.atualizarImagem(id, 'vacinas/$id.jpg');
        } else {
          VacinasApi.atualizarImagem(id, 'vacinas/vacina.jpg');
        }
      });
    }
    int idVacina = await vacinasDAO.insertVacina(novaVacina);
    novaVacina.id = idVacina;
    await pickAndUploadImage(novaVacina, croppedImage, imagemSelecionada);
    novaVacina.localImagem = localImagePath;
    vacinasDAO.updateVacina(novaVacina);
    vacinas.add(novaVacina);
    vacinasPet.add(novaVacina);
  }

  obterVacinas(int? id) async {
    vacinasPet.clear();
    vacinasPet.addAll(await vacinasDAO.getVacinasByPetId(id!));
  }

  Future<void> deletarVacinas(bool limpar) async {
    isLoading.value = true;
    for (Vacinas vacina in vacinas) {
      if (loginController.uID.value != "DEFAULT" && !limpar) {
        if (vacina.imagem != null && !vacina.imagem!.contains("vacina.jpg")) {
          final storageRef =
              FirebaseStorage.instance.ref().child(vacina.imagem!);
          await storageRef.delete();
        }
        await VacinasApi.deletarVacina(vacina.idFirebase!);
      }
      if (vacina.localImagem != null &&
          File(vacina.localImagem!).existsSync()) {
        File(vacina.localImagem!).deleteSync();
      }
    }

    vacinas.clear();
    isLoading.value = false;
  }
}
