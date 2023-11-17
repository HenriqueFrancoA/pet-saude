import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

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
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e);
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

  Future<void> deleteAccount() async {
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
        print("Erro ao deletar a conta: $e");
      }
    }
  }
}
