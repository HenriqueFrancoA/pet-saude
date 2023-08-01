import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/controllers/pets_controller.dart';
import 'package:pet_care/controllers/vacinas_controller.dart';
import 'package:pet_care/controllers/vermifugos_controller.dart';
import 'package:pet_care/controllers/versao_controller.dart';
import 'package:pet_care/services/auth_services.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final delete =
      Get.arguments != null ? Get.arguments['delete'] as bool : false;
  final sair = Get.arguments != null ? Get.arguments['sair'] as bool : false;

  final loginController = Get.put(LoginController());
  final vermifugosController = Get.put(VermifugosController());
  final vacinasController = Get.put(VacinasController());
  final petsController = Get.put(PetsController());
  final versaoController = Get.put(VersaoController());

  String _getTextoLoading() {
    if (delete) {
      if (vermifugosController.isLoading.isTrue) {
        return "Deletando vermífugos...";
      } else if (vacinasController.isLoading.isTrue) {
        return "Deletando vacinas...";
      } else if (petsController.isLoading.isTrue) {
        return "Deletando pets...";
      } else {
        return "Carregando...";
      }
    } else {
      if (vermifugosController.isLoading.isTrue) {
        return "Carregando vermífugos...";
      } else if (vacinasController.isLoading.isTrue) {
        return "Carregando vacinas...";
      } else if (petsController.isLoading.isTrue) {
        return "Carregando pets...";
      } else {
        return "Carregando...";
      }
    }
  }

  @override
  void initState() {
    if (delete) {
      Future.delayed(Duration.zero, () {
        deletarControllers();
      });
    } else if (sair) {
      Future.delayed(Duration.zero, () {
        limparControllers();
      });
    } else {
      Future.delayed(Duration.zero, () {
        carregarControllers();
      });
    }
    super.initState();
  }

  carregarControllers() async {
    await versaoController.obterVersao(loginController.uID.value);
    await petsController.carregarPets(loginController.uID.value);
    Get.offAllNamed('/home');
  }

  deletarControllers() async {
    vacinasController.deletarVacinas();
    vermifugosController.deletarVermifugos();
    petsController.deletarPets();
    versaoController.deletarVersao();
    loginController.uID.value = "";
    AuthService().deleteAccount();
    Get.offAllNamed("/login");
  }

  limparControllers() async {
    vacinasController.vacinas.clear();
    vermifugosController.vermifugos.clear();
    petsController.pets.clear();
    versaoController.deletarVersao();
    loginController.uID.value = "";
    AuthService().signOut();
    Get.offAllNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/image/loading.json",
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            Obx(() {
              final texto = _getTextoLoading();
              return Text(
                texto,
                style: Theme.of(context).textTheme.titleMedium,
              );
            }),
          ],
        ),
      ),
    );
  }
}
