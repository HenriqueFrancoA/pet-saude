import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:pet_care/screens/carteirinha/carteirinha_screen.dart';
import 'package:pet_care/screens/pets/pets_screen.dart';

class PetInfoScreen extends StatefulWidget {
  const PetInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PetInfoScreenState createState() => _PetInfoScreenState();
}

class _PetInfoScreenState extends State<PetInfoScreen> {
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
        body: Container(
          color: Theme.of(context).colorScheme.secondary,
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/image/cao.jpg",
                    width: queryData.size.width,
                    height: 230,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      color: Colors.white,
                      iconSize: 35,
                      onPressed: () {
                        Get.offAll(const PetsScreen());
                      },
                    ),
                  ),
                ],
              ),
              Container(
                color: Theme.of(context).colorScheme.background,
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "BILLY",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Ionicons.create_outline,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          width: queryData.size.width * 0.28,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: const [
                              Icon(
                                Ionicons.male_female,
                                size: 29,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Macho",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: queryData.size.width * 0.28,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: const [
                              Icon(
                                Icons.balance,
                                size: 29,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "10 KG",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: queryData.size.width * 0.28,
                          child: Column(
                            children: const [
                              Icon(
                                Icons.cake,
                                size: 29,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "2 anos",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(30),
                width: queryData.size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Controle De Saúde",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      width: queryData.size.width,
                      height: 60,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: const BorderSide(color: Colors.transparent),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                        ),
                        onPressed: () async {
                          Get.offAll(
                              const CarteirinhaScreen(titulo: "VERMÍFUGOS"));
                        },
                        child: Text(
                          "VERMÍFUGOS",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: queryData.size.width,
                      height: 60,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        onPressed: () async {
                          Get.offAll(
                              const CarteirinhaScreen(titulo: "VACINAS"));
                        },
                        child: Text(
                          "VACINAS",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
