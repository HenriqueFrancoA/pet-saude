import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/components/glassmorphic_component.dart';
import 'package:pet_care/models/pets.dart';
import 'package:sizer/sizer.dart';

class CardPet extends StatefulWidget {
  Pets? pet;
  bool ultimo;
  CardPet({
    Key? key,
    this.pet,
    required this.ultimo,
  }) : super(key: key);

  @override
  CardPetState createState() => CardPetState();
}

class CardPetState extends State<CardPet> {
  late Reference storageRef;

  @override
  Widget build(BuildContext context) {
    return !widget.ultimo
        ? Column(
            children: [
              GestureDetector(
                child: CustomGlassmorphicContainer(
                  width: 140,
                  height: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: widget.pet!.localImagem != null &&
                            widget.pet!.localImagem!.isNotEmpty
                        ? Image.file(
                            File(widget.pet!.localImagem!),
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/image/pet.png",
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                onTap: () {
                  Get.toNamed("/info", arguments: {'pet': widget.pet});
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                widget.pet!.nome!.length <= 10
                    ? widget.pet!.nome!.toUpperCase()
                    : "${widget.pet!.nome!.substring(0, 10).toUpperCase()}...",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          )
        : Column(
            children: [
              GestureDetector(
                child: const CustomGlassmorphicContainer(
                  width: 140,
                  height: 140,
                  child: Center(
                    child: Icon(
                      Icons.add_circle,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Get.toNamed("/cadastro", arguments: {'pet': null});
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "NOVO PET",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          );
  }
}
