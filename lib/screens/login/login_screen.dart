import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_care/components/dialog_components.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/services/auth_services.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    final loginController = Get.put(LoginController());

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Container(
            height: queryData.size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/image/background-image.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color.fromARGB(125, 0, 0, 0),
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Ionicons.paw,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "PET SAÚDE",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      shadows: const [
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          color: Color.fromARGB(255, 109, 65, 29),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "Faça login para começar",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  SizedBox(
                    width: queryData.size.width,
                    child: MaterialButton(
                      onPressed: () {
                        try {
                          AuthService().signInWithGoogle(context);
                        } catch (e) {
                          null;
                        }
                      },
                      color: Colors.red,
                      child: Row(
                        children: [
                          Text(
                            "g\t\t",
                            style: GoogleFonts.abhayaLibre(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.black38,
                          ),
                          SizedBox(
                            width: 4.h,
                          ),
                          Text(
                            "\t\t ENTRAR COM GMAIL",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 16,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "Ou",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      loginController.logarSemConta();
                    },
                    child: Text(
                      "CONTINUE SEM FAZER LOGIN",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialog(
                            mdFileName: 'privacy_policy.md',
                          );
                        },
                      );
                    },
                    child: Text(
                      "Política de Privacidade",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
