import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/components/glassmorphic_component.dart';
import 'package:pet_care/models/vacinas.dart';
import 'package:pet_care/models/vermifugos.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CarteirinhaCard extends StatefulWidget {
  Vermifugos? vermifugo;
  Vacinas? vacina;
  CarteirinhaCard({
    Key? key,
    this.vermifugo,
    this.vacina,
  }) : super(key: key);

  @override
  CarteirinhaCardState createState() => CarteirinhaCardState();
}

class CarteirinhaCardState extends State<CarteirinhaCard> {
  late Reference storageRef;
  RxString downloadURL = ''.obs;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return CustomGlassmorphicContainer(
      width: queryData.size.width,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.vermifugo != null &&
                          (widget.vermifugo!.localImagem != null &&
                              widget.vermifugo!.localImagem!.isNotEmpty)
                      ? Image.file(
                          File(widget.vermifugo!.localImagem!),
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        )
                      : widget.vacina != null &&
                              (widget.vacina!.localImagem != null &&
                                  widget.vacina!.localImagem!.isNotEmpty)
                          ? Image.file(
                              File(widget.vacina!.localImagem!),
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            )
                          : widget.vacina != null
                              ? Image.asset(
                                  "assets/image/vacina.jpg",
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/image/vermifugo.jpg",
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                ),
              ],
            ),
            SizedBox(
              width: 2.h,
            ),
            widget.vermifugo != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vermifugo!.nome!.length <= 30
                            ? widget.vermifugo!.nome!
                            : "${widget.vermifugo!.nome!.substring(0, 30)}...",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                      Text(
                        "Peso: ${widget.vermifugo!.peso!.toStringAsFixed(2)} kg",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Dose: ${widget.vermifugo!.dose!.toStringAsFixed(2)} ml",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        DateFormat('\'Data: \' dd \'de\' MMM yyyy', 'pt_BR')
                            .format(widget.vermifugo!.dataVacinacao!.toDate()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        DateFormat('\'Próxima: \' dd \'de\' MMM yyyy', 'pt_BR')
                            .format(
                                widget.vermifugo!.proximaVacinacao!.toDate()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vacina!.nome!.length <= 30
                            ? widget.vacina!.nome!
                            : "${widget.vacina!.nome!.substring(0, 30)}...",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Peso: ${widget.vacina!.peso} kg",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Dose: ${widget.vacina!.dose} ml",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        DateFormat('\'Data: \' dd \'de\' MMM yyyy', 'pt_BR')
                            .format(widget.vacina!.dataVacinacao!.toDate()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        DateFormat('\'Próxima: \' dd \'de\' MMM yyyy', 'pt_BR')
                            .format(widget.vacina!.proximaVacinacao!.toDate()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
