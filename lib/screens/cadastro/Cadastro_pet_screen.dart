import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:pet_care/screens/pets/pets_screen.dart';

class CadastroPetScreen extends StatefulWidget {
  const CadastroPetScreen({Key? key}) : super(key: key);

  @override
  _CadastroPetScreenState createState() => _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen> {
  String _selectedValue = "macho";

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
        body: SingleChildScrollView(
          child: Container(
            width: queryData.size.width,
            color: Theme.of(context).colorScheme.onSecondary,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: queryData.size.width,
                      height: 170,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Container(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Text(
                              "ADICIONAR FOTO",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 145,
                              height: 145,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.white,
                                size: 55,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "NOME",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "DATA DE NASCIMENTO",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: queryData.size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            alignment: AlignmentDirectional.centerStart,
                            child: DropdownButton<String>(
                              value: _selectedValue,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              underline: Container(
                                height: 0,
                              ),
                              icon: Icon(
                                Ionicons.caret_down_outline,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedValue = newValue.toString();
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: "macho",
                                  child: Text(
                                    "MACHO ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "femea",
                                  child: Text(
                                    "FEMÊA ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "PESO",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 60,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "RAÇA",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: queryData.size.width,
                            height: 60,
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                side:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              onPressed: () async {
                                Get.offAll(const PetsScreen());
                              },
                              child: const Text(
                                "CADASTRE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
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
        ),
      ),
    );
  }
}
