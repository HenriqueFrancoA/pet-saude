import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_care/components/glassmorphic_component.dart';
import 'package:pet_care/models/pets.dart';
import 'package:sizer/sizer.dart';

class PetInfoScreen extends StatefulWidget {
  const PetInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  PetInfoScreenState createState() => PetInfoScreenState();
}

class PetInfoScreenState extends State<PetInfoScreen> {
  final pet = Get.arguments['pet'] as Pets;

  RxBool anuncio = RxBool(true);
  late final BannerAd myBanner;

  @override
  void initState() {
    myBanner = BannerAd(
      size: AdSize.fluid,
      adUnitId: 'ca-app-pub-4824022930012497/6424498738',
      listener: BannerAdListener(
        onAdClosed: (ad) {
          setState(() {
            anuncio.value = false;
          });
        },
      ),
      request: const AdRequest(),
    );

    myBanner.load();
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
        backgroundColor: Colors.black,
        body: CustomGlassmorphicContainer(
          width: queryData.size.width,
          height: queryData.size.height,
          borderRadius: 10,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: LottieBuilder.asset(
                  "assets/image/wpp.json",
                  width: queryData.size.width,
                  height: queryData.size.height,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    child: Stack(
                      children: [
                        pet.localImagem != null && pet.localImagem!.isNotEmpty
                            ? Image.file(
                                File(pet.localImagem!),
                                fit: BoxFit.cover,
                                width: queryData.size.width,
                              )
                            : Image.asset(
                                "assets/image/pet.png",
                                width: queryData.size.width,
                                fit: BoxFit.cover,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            color: Colors.white,
                            iconSize: 35,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
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
                              pet.nome!.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: Card(
                                elevation: 4,
                                child: IconButton(
                                  onPressed: () {
                                    Get.toNamed("/cadastro",
                                        arguments: {'pet': pet});
                                  },
                                  icon: const Icon(
                                    Ionicons.create_outline,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: queryData.size.width * 0.25,
                              child: Column(
                                children: [
                                  pet.sexo! == "Macho"
                                      ? const Icon(
                                          Ionicons.male,
                                          size: 29,
                                        )
                                      : const Icon(
                                          Ionicons.female,
                                          size: 29,
                                        ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    pet.sexo!,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: queryData.size.width * 0.25,
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.balance,
                                    size: 29,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    "${pet.peso!.toStringAsFixed(2)}Kg",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: queryData.size.width * 0.25,
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.cake,
                                    size: 29,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    DateFormat('dd \'de\' MMM', 'pt_BR')
                                        .format(pet.nascimento!.toDate()),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
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
                              Get.toNamed(
                                "carteira",
                                arguments: {
                                  'titulo': "VERMÍFUGOS",
                                  'pet': pet,
                                },
                              );
                            },
                            child: Text(
                              "VERMÍFUGOS",
                              style: Theme.of(context).textTheme.labelSmall,
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
                              Get.toNamed(
                                "carteira",
                                arguments: {
                                  'titulo': "VACINAS",
                                  'pet': pet,
                                },
                              );
                            },
                            child: Text(
                              "VACINAS",
                              style: Theme.of(context).textTheme.labelSmall,
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
        bottomSheet: anuncio.isTrue
            ? Container(
                width: queryData.size.width,
                height: 50,
                color: Colors.black,
                child: AdWidget(
                  ad: myBanner,
                ),
              )
            : null,
      ),
    );
  }
}
