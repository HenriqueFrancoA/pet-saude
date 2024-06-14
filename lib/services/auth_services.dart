// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_care/components/notification_snack_bar.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/controllers/pets_controller.dart';
import 'package:pet_care/controllers/versao_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

carregarControllers() async {
  final loginController = Get.put(LoginController());
  final versaoController = Get.put(VersaoController());
  final petsController = Get.put(PetsController());

  await versaoController.obterVersao(loginController.uID.value);
  await petsController.carregarPets(loginController.uID.value);
  Get.offAllNamed('/home');
}

void handleAuthStateChanges(User? firebaseUser) async {
  final loginController = Get.put(LoginController());
  bool salvarAcesso = false;
  bool saindo = false;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  saindo = prefs.getBool("saindo") ?? false;
  salvarAcesso = prefs.getBool("salvarAcesso") ?? false;
  if (saindo) {
    Get.offAllNamed("/login");
  } else {
    if (firebaseUser != null) {
      //Future.delayed(Duration.zero, () async {
      loginController.uID.value = firebaseUser.uid;
      carregarControllers();

      Get.offAllNamed("/loading", arguments: {'delete': false, 'sair': false});
      //});
    } else {
      if (salvarAcesso) {
        loginController.logarSemConta();
      } else {
        Get.offAllNamed("/login");
      }
    }
  }
}

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(
    BuildContext context,
  ) async {
    try {
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('saindo', false);
      });

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('salvarAcesso', true);
      });

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('versao', 0);
      });

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      handleAuthStateChanges(userCredential.user);
    } on FirebaseAuthException catch (e) {
      NotificationSnackbar.showError(
          context, "Ocorreu algum erro. ${e.message}");
    }
  }

  Future<bool> isLogged() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    if (gAuth.accessToken != null) {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();

    await FirebaseAuth.instance.signOut();

    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove('salvarAcesso');
      prefs.remove('versao');
      prefs.remove('token');
    });
  }

  Future<void> deleteAccount(
    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();

        final prefs = await SharedPreferences.getInstance();
        prefs.remove('salvarAcesso');
        prefs.remove('versao');
        prefs.remove('token');

        await GoogleSignIn().signOut();

        await FirebaseAuth.instance.signOut();
      } catch (e) {
        NotificationSnackbar.showError(context, "Ocorreu algum erro.");
      }
    }
  }
}
