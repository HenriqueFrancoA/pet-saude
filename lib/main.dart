import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/screens/cadastros/cadastro_carteirinha_screen.dart';
import 'package:pet_care/screens/cadastros/cadastro_pet_screen.dart';
import 'package:pet_care/screens/carteirinha/carteirinha_screen.dart';
import 'package:pet_care/screens/config/config_screen.dart';
import 'package:pet_care/screens/informacoes/pet_info_screen.dart';
import 'package:pet_care/screens/loading/loading_screen.dart';
import 'package:pet_care/screens/login/login_screen.dart';
import 'package:pet_care/screens/pets/pets_screen.dart';
import 'package:pet_care/shared/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:intl/date_symbol_data_local.dart';

bool salvarAcesso = false;

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          key: UniqueKey(),
          themeMode: ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: salvarAcesso ? const LoadingScreen() : const LoginScreen(),
          getPages: [
            GetPage(
              name: '/carteira',
              page: () => const CarteirinhaScreen(),
            ),
            GetPage(
              name: '/cadastro',
              page: () => const CadastroPetScreen(),
            ),
            GetPage(
              name: '/cadastro/carteira',
              page: () => const CadastroCarteirinhaScreen(),
            ),
            GetPage(
              name: '/login',
              page: () => const LoginScreen(),
            ),
            GetPage(
              name: '/info',
              page: () => const PetInfoScreen(),
            ),
            GetPage(
              name: '/home',
              page: () => const PetsScreen(),
            ),
            GetPage(
              name: '/loading',
              page: () => const LoadingScreen(),
            ),
            GetPage(
              name: '/config',
              page: () => const ConfigScreen(),
            ),
          ],
        );
      },
    );
  }
}

void handleAuthStateChanges(User? firebaseUser) {
  if (firebaseUser != null) {
    Future.delayed(Duration.zero, () async {
      final loginController = Get.put(LoginController());
      loginController.uID.value = firebaseUser.uid;
      Get.offAllNamed("/loading", arguments: {'delete': false, 'sair': false});
    });
  } else {
    Get.offAllNamed(
      '/login',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('pt_BR', null).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    runApp(const Main());
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  salvarAcesso = prefs.getBool("salvarAcesso") ?? false;

  FirebaseAuth.instance.authStateChanges().listen(handleAuthStateChanges);
}
