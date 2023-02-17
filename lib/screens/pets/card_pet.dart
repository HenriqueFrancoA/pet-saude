import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/screens/cadastro/Cadastro_pet_screen.dart';
import 'package:pet_care/screens/informacoes/pet_info_screen.dart';

class CardPet extends StatefulWidget {
  final int index;
  const CardPet({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  _CardPetState createState() => _CardPetState();
}

class _CardPetState extends State<CardPet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return widget.index < 1
        ? Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  margin: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/image/cao.jpg",
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Get.offAll(const PetInfoScreen());
                },
              ),
              Text(
                "BILLY",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          )
        : Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_circle,
                      size: 50,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                onTap: () {
                  Get.offAll(
                    const CadastroPetScreen(),
                  );
                },
              ),
              Text(
                "NOVO PET",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          );
  }
}
