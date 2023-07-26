import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstAcessScreen extends StatefulWidget {
  const FirstAcessScreen({Key? key}) : super(key: key);

  @override
  FirstAcessScreenState createState() => FirstAcessScreenState();
}

class FirstAcessScreenState extends State<FirstAcessScreen> {
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
            padding: const EdgeInsets.all(50),
            width: queryData.size.width,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "QUAL PET",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  "VOCÊ TEM?",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        height: 170,
                        width: queryData.size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "CÃO",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Image.asset(
                            "assets/image/dog.png",
                            height: 170,
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.offAllNamed("/cadastro");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Container(
                      height: 170,
                      width: queryData.size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Image.asset(
                            "assets/image/gato.png",
                            height: 150,
                          ),
                        ),
                        Text(
                          "GATO",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
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
