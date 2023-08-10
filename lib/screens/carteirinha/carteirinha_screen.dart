import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_care/components/glassmorphic_component.dart';
import 'package:pet_care/controllers/vacinas_controller.dart';
import 'package:pet_care/controllers/vermifugos_controller.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/models/vacinas.dart';
import 'package:pet_care/models/vermifugos.dart';
import 'package:pet_care/screens/carteirinha/carteirinha_card.dart';
import 'package:sizer/sizer.dart';
import 'package:connectivity/connectivity.dart';

class CarteirinhaScreen extends StatefulWidget {
  const CarteirinhaScreen({
    Key? key,
  }) : super(key: key);

  @override
  CarteirinhaScreenState createState() => CarteirinhaScreenState();
}

class CarteirinhaScreenState extends State<CarteirinhaScreen> {
  final titulo = Get.arguments['titulo'] as String;
  final pet = Get.arguments['pet'] as Pets;

  final vacinasController = Get.put(VacinasController());
  final vermifugosController = Get.put(VermifugosController());
  RxBool anuncio = RxBool(true);
  BannerAd? myBanner;

  @override
  void initState() {
    myBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-4824022930012497/8830162038',
      listener: BannerAdListener(
        onAdClosed: (ad) {
          setState(() {
            ad.dispose();
            myBanner = null;
          });
        },
        onAdOpened: (Ad ad) {
          setState(() {
            ad.dispose();
            myBanner = null;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();

    super.initState();
  }

  Future<bool> hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        titulo,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(
                            "/cadastro/carteira",
                            arguments: {
                              'pet': pet,
                              'titulo': titulo,
                            },
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.background,
                          size: 27,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    height: queryData.size.height * 0.9,
                    child: Obx(
                      () => ListView.separated(
                        itemCount: titulo.contains("VERMÍFUGOS")
                            ? vermifugosController.vermifugosPet.length
                            : vacinasController.vacinasPet.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          Vermifugos? vermifugo;
                          Vacinas? vacina;
                          if (titulo.contains("VERMÍFUGOS")) {
                            vermifugo =
                                vermifugosController.vermifugosPet[index];
                          } else {
                            vacina = vacinasController.vacinasPet[index];
                          }
                          return CarteirinhaCard(
                            vermifugo: vermifugo,
                            vacina: vacina,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 2.h,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomSheet: myBanner != null
            ? Stack(
                children: [
                  Container(
                    width: queryData.size.width,
                    height: 50,
                    color: Colors.black,
                    child: AdWidget(
                      ad: myBanner!,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        myBanner!.dispose();
                        myBanner = null;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
