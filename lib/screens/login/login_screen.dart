import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:pet_care/screens/firstAcess/first_acess_screen.dart';
import 'package:pet_care/screens/pets/pets_screen.dart';
import 'package:pet_care/services/auth_services.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            height: queryData.size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "BEM VINDX AO",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  "PET CARE",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Image.asset(
                  "assets/image/auau.jpg",
                  height: 230,
                  width: 230,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "FAÇA LOGIN PARA COMEÇAR",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
                    ),
                    onPressed: () async {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "f",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "ENTRAR COM FACEBOOK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color.fromRGBO(219, 68, 55, 1),
                    ),
                    onPressed: () async {
                      try {
                        AuthService().signInWithGoogle();
                      } catch (e) {
                        null;
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "G",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "ENTRAR COM GOOGLE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
