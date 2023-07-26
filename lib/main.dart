import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/controllers/pets_controller.dart';
import 'package:pet_care/screens/cadastros/cadastro_carteirinha_screen.dart';
import 'package:pet_care/screens/cadastros/cadastro_pet_screen.dart';
import 'package:pet_care/screens/carteirinha/carteirinha_screen.dart';
import 'package:pet_care/screens/informacoes/pet_info_screen.dart';
import 'package:pet_care/screens/login/login_screen.dart';
import 'package:pet_care/screens/pets/pets_screen.dart';
import 'package:pet_care/shared/themes/themes.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:intl/date_symbol_data_local.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          themeMode: ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
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
      final petsController = Get.put(PetsController());
      await petsController.carregarPets(loginController.uID.value);
      Get.offAllNamed('/home');
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('pt_BR', null).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    runApp(const Main());
  });

  FirebaseAuth.instance.authStateChanges().listen(handleAuthStateChanges);
}
