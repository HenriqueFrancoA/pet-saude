import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('salvarAcesso', true);
    });

    await SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('versao', 0);
    });

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool> isLogged() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    if (gAuth.accessToken != null) {
      return true;
    }
    return false;
  }
}
