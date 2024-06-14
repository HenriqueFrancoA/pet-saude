// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/apis/vermifugos_api.dart';
import 'package:pet_care/components/notification_snack_bar.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/controllers/versao_controller.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/models/vermifugos.dart';
import 'package:pet_care/utils/vermifugosDAO.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VermifugosController extends GetxController {
  RxList vermifugos = RxList();
  RxList vermifugosPet = RxList();
  RxBool isLoading = false.obs;
  String localImagePath = '';

  final VermifugosDAO vermifugosDAO = VermifugosDAO();
  late Reference storageRef;

  final loginController = Get.put(LoginController());
  final versaoController = Get.put(VersaoController());

  Future<Vermifugos> baixarImage(Vermifugos vermifugo, Pets pet) async {
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

      String localImagePath =
          "${directoryPath.path}/${vermifugo.idFirebase}.jpg";
      File localImageFile = File(localImagePath);
      bool exists = await localImageFile.exists();

      if (!exists) {
        await localImageFile.writeAsBytes(response.bodyBytes);
      }

      vermifugo.localImagem = localImagePath;
    }
    vermifugo.localPet = pet;
    await vermifugosDAO.insertVermifugo(vermifugo);

    return vermifugo;
  }

  Future<UploadTask?> upload(String path, String id) async {
    File file = File(path);
    try {
      String ref = 'vermifugos/$id.jpg';
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
    File? imageFile,
    Vermifugos vermifugo,
    bool imagemSelecionada,
    BuildContext context,
  ) async {
    Directory? appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final directoryPath = Directory("${appDocumentsDirectory.path}/vermifugos");
    await directoryPath.create(recursive: true);

    if (vermifugo.idFirebase != null) {
      localImagePath =
          "${appDocumentsDirectory.path}/vermifugos/${vermifugo.idFirebase}.jpg";
    } else {
      localImagePath =
          "${appDocumentsDirectory.path}/vermifugos/${vermifugo.id}.jpg";
    }

    try {
      if (imageFile != null) {
        await imageFile.copy(localImagePath);
        vermifugo.localImagem = localImagePath;
      } else {
        localImagePath = '';
      }
    } catch (e) {
      NotificationSnackbar.showError(context, "Ocorreu algum erro.");
    }

    return localImagePath;
  }

  pickAndUploadImage(
    Vermifugos vermifugo,
    File? croppedImage,
    bool imagemSelecionada,
    BuildContext context,
  ) async {
    File? file = croppedImage;
    if (file != null && vermifugo.idFirebase != null) {
      await upload(file.path, vermifugo.idFirebase!);
    }
    await saveToLocalFile(
      file,
      vermifugo,
      imagemSelecionada,
      context,
    );
  }

  carregarVermifugos(Pets pet) async {
    isLoading.value = true;
    RxList vermifugosAux = RxList();

    vermifugosAux.addAll(await VermifugosApi.obterVermifugos(pet.id!));
    for (Vermifugos vermifugo in vermifugosAux) {
      vermifugos.add(await baixarImage(vermifugo, pet));
    }
    isLoading.value = false;
  }

  criarVermifugo(
    Vermifugos novoVermifugo,
    File? croppedImage,
    bool imagemSelecionada,
    BuildContext context,
  ) async {
    if (loginController.uID.value != "DEFAULT") {
      await VermifugosApi.criarVermifugo(novoVermifugo).then((String id) {
        novoVermifugo.idFirebase = id;
        versaoController.atualizarVersao();
        if (imagemSelecionada) {
          VermifugosApi.atualizarImagem(id, 'vermifugos/$id.jpg');
        } else {
          VermifugosApi.atualizarImagem(id, 'vermifugos/vermifugo.jpg');
        }
      });
    }
    int idVermifugo = await vermifugosDAO.insertVermifugo(novoVermifugo);
    novoVermifugo.id = idVermifugo;
    await pickAndUploadImage(
        novoVermifugo, croppedImage, imagemSelecionada, context);
    novoVermifugo.localImagem = localImagePath;
    vermifugosDAO.updateVermifugo(novoVermifugo);
    vermifugos.add(novoVermifugo);
    vermifugosPet.add(novoVermifugo);
  }

  obterVermifugo(int? id) async {
    vermifugosPet.clear();
    vermifugosPet.addAll(await vermifugosDAO.getVermifugosByPetId(id!));
  }

  Future<void> deletarVermifugos(bool limpar) async {
    isLoading.value = true;
    for (Vermifugos vermifugo in vermifugos) {
      if (loginController.uID.value != "DEFAULT" && !limpar) {
        if (vermifugo.imagem != null &&
            !vermifugo.imagem!.contains("vermifugo.jpg")) {
          final storageRef =
              FirebaseStorage.instance.ref().child(vermifugo.imagem!);
          await storageRef.delete();
        }
        await VermifugosApi.deletarVermifugo(vermifugo.idFirebase!);
      }
      if (vermifugo.localImagem != null &&
          File(vermifugo.localImagem!).existsSync()) {
        File(vermifugo.localImagem!).deleteSync();
      }
    }
    vermifugos.clear();
    isLoading.value = false;
  }
}
