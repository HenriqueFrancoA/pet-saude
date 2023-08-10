import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  RxString uID = RxString('');

  logarSemConta() async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('salvarAcesso', true);
    });

    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('saindo', false);
    });

    uID.value = "DEFAULT";
    Get.offAllNamed(
      "/loading",
      arguments: {
        'delete': false,
        'sair': false,
      },
    );
  }
}
