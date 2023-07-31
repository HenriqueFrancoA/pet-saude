import 'package:get/get.dart';
import 'package:pet_care/apis/versao_api.dart';
import 'package:pet_care/models/versao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersaoController extends GetxController {
  Versao? versao = Versao();

  obterVersao(String uId) async {
    versao = await VersaoApi.obterVersao(uId);
  }

  atualizarVersao() async {
    versao!.versao = versao!.versao! + 1;
    VersaoApi.atualizarVersao(
      versao!.id!,
      versao!.uId!,
      versao!.versao!,
    );
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('versao', versao!.versao!);
    });
  }
}
