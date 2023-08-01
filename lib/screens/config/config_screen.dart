import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_care/components/button_components.dart';
import 'package:pet_care/components/glassmorphic_component.dart';
import 'package:sizer/sizer.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
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
                          "CONFIGURAÇÕES",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: 5.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      width: queryData.size.width,
                      child: CustomButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Tem certeza que deseja excluir esta conta?",
                            titleStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                ),
                            backgroundColor: Colors.white30,
                            content: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Está ação irá deletar todos os seus dados, incluindo imagens e é irreversível.",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                            cancel: CustomButton(
                              onPressed: () {
                                Get.back();
                              },
                              text: "Cancelar",
                              color: Colors.red,
                            ),
                            confirm: CustomButton(
                              onPressed: () {
                                Get.offAllNamed("/loading",
                                    arguments: {'delete': true, 'sair': false});
                              },
                              text: "Confirmar",
                            ),
                          );
                        },
                        text: "DELETAR CONTA",
                        color: Colors.white30,
                      ),
                    ),
                    SizedBox(
                      width: queryData.size.width,
                      child: CustomButton(
                        onPressed: () {
                          Get.offAllNamed("/loading",
                              arguments: {'delete': false, 'sair': true});
                        },
                        text: "SAIR",
                        color: Colors.white30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
