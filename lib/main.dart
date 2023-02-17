import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:pet_care/screens/login/login_screen.dart';
import 'package:pet_care/screens/pets/pets_screen.dart';
import 'package:pet_care/services/auth_services.dart';
import 'package:pet_care/src/shared/themes/color_schemes.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //NotificationPlugin().init();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('Mensagem: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Mensagem: 2  ${message.data}');

    if (message.notification != null) {
      print('Mensagem: 3 ${message.notification}');
    }
  });

  runApp(
    const Main(),
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  bool logado = false;
  bool isLogado = false;
  AuthService auth = new AuthService();

  @override
  void initState() {
    getLogado();
  }

  void getLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogado = prefs.getBool("logado") ?? false;
    if (isLogado) {
      if (await auth.isLogged()) {
        setState(() {
          logado = isLogado;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: TextTheme(
            headline1: GoogleFonts.montserrat(
              fontSize: 35,
              fontWeight: FontWeight.w800,
              color: const Color.fromRGBO(57, 51, 53, 1),
            ),
            headline2: GoogleFonts.montserrat(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            headline3: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            headline4: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
            headline5: GoogleFonts.montserrat(
              fontSize: 15,
              color: Colors.black,
            ),
            bodyText1: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyText2: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(57, 51, 53, 1),
            ),
            button: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color.fromRGBO(175, 118, 126, 1),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
        debugShowCheckedModeBanner: false,
        home: logado ? const PetsScreen() : const LoginScreen(),
      );
    });
  }
}

class RoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
