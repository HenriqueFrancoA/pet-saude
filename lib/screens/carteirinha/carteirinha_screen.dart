import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/screens/carteirinha/carteirinha_card.dart';
import 'package:pet_care/screens/informacoes/pet_info_screen.dart';

class CarteirinhaScreen extends StatefulWidget {
  final String titulo;
  const CarteirinhaScreen({
    Key? key,
    required this.titulo,
  }) : super(key: key);

  @override
  _CarteirinhaScreenState createState() => _CarteirinhaScreenState();
}

class _CarteirinhaScreenState extends State<CarteirinhaScreen> {
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
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Container(
        width: queryData.size.width,
        height: queryData.size.height,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Container(
              width: queryData.size.width,
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: GestureDetector(
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 35,
                      ),
                      onTap: () {
                        Get.offAll(const PetInfoScreen());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.titulo,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: queryData.size.height - 200,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: 20,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return const CarteirinhaCard(
                          nome: "Antipulgas Simparic",
                          data: "12/02/2022",
                          dataProxima: "12/02/2023",
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 25,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
