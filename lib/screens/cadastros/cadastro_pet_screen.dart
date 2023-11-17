import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_care/components/button_components.dart';
import 'package:pet_care/components/glassmorphic_component.dart';
import 'package:pet_care/components/input_component.dart';
import 'package:pet_care/controllers/login_controller.dart';
import 'package:pet_care/controllers/pets_controller.dart';
import 'package:pet_care/controllers/versao_controller.dart';
import 'package:pet_care/models/pets.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CadastroPetScreen extends StatefulWidget {
  const CadastroPetScreen({Key? key}) : super(key: key);

  @override
  CadastroPetScreenState createState() => CadastroPetScreenState();
}

class CadastroPetScreenState extends State<CadastroPetScreen> {
  final pet = Get.arguments['pet'] as Pets?;

  late Reference storageRef;
  RxString downloadURL = ''.obs;
  final dateFormat = DateFormat('dd/MM/yyyy');

  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();
  final _pesoController = TextEditingController();
  final _racaController = TextEditingController();

  final loginController = Get.put(LoginController());
  final petsController = Get.put(PetsController());
  final versaoController = Get.put(VersaoController());

  String ref = '';
  XFile? image;
  File? croppedImage;
  bool imagemSelecionada = false;

  DateTime? _selectedDate;

  final RxString sexoPet = "Macho".obs;
  List<String> mascFem = ["Macho", "Fêmea"];

  getImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      croppedImage = await cropImage(XFile(image!.path));
      if (croppedImage != null) {
        setState(() {
          imagemSelecionada = true;
        });
      }
      return croppedImage;
    }
  }

  Future<File?> cropImage(XFile imagePath) async {
    final imageCropper = ImageCropper();
    croppedImage = await imageCropper.cropImage(
      sourcePath: imagePath.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
      ],
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      compressQuality: 100,
      maxHeight: 405,
      maxWidth: 720,
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Recortar Imagem',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.ratio16x9,
        lockAspectRatio: true,
      ),
    );
    return croppedImage;
  }

  @override
  initState() {
    if (pet != null) {
      var date =
          DateFormat('dd/MM/yyyy', 'pt_BR').format(pet!.nascimento!.toDate());
      _nomeController.text = pet!.nome!;
      _dataController.text = date;
      _pesoController.text = pet!.peso.toString();
      _racaController.text = pet!.raca!;
    } else {
      _nomeController.text = '';
      _racaController.text = '';
      _dataController.text = '';
      _pesoController.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final isKeyboard = queryData.viewInsets.bottom != 0;

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
                  repeat: false,
                  width: queryData.size.width,
                  height: queryData.size.height,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  !isKeyboard
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "ADICIONAR FOTO",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              GestureDetector(
                                onTap: getImage,
                                child: CustomGlassmorphicContainer(
                                  width: 120,
                                  height: 120,
                                  borderRadius: 90,
                                  child: pet != null &&
                                          pet!.localImagem != null &&
                                          pet!.localImagem!.isNotEmpty &&
                                          !imagemSelecionada
                                      ? Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                            child: Image.file(
                                              File(pet!.localImagem!),
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : pet != null &&
                                                  pet!.localImagem == null ||
                                              (pet != null &&
                                                      pet!.localImagem !=
                                                          null &&
                                                      pet!.localImagem!
                                                          .isEmpty) &&
                                                  !imagemSelecionada
                                          ? Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                                child: Image.asset(
                                                  "assets/image/pet.png",
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : imagemSelecionada
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 55,
                                                    color: Colors.green,
                                                  ),
                                                )
                                              : const Center(
                                                  child: Icon(
                                                    Icons
                                                        .add_photo_alternate_outlined,
                                                    color: Colors.white,
                                                    size: 55,
                                                  ),
                                                ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            child: CustomTextField(
                              controller: _nomeController,
                              labelText: "Nome",
                              hintText: "Digite o nome do seu Pet",
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(125, 245, 245, 245),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              readOnly: true,
                              onTap: () {
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime:
                                      DateTime(DateTime.now().year - 20, 1, 1),
                                  maxTime: DateTime.now(),
                                  onConfirm: (date) {
                                    setState(() {
                                      _selectedDate = date;
                                      _dataController.text =
                                          dateFormat.format(date);
                                    });
                                  },
                                  currentTime: _selectedDate ?? DateTime.now(),
                                  locale: LocaleType.pt,
                                );
                              },
                              controller: _dataController,
                              decoration: InputDecoration(
                                labelText: 'Data de nascimento',
                                hintText: 'Selecione uma data',
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  decorationColor: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Obx(
                            () {
                              return Container(
                                width: queryData.size.width,
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(125, 245, 245, 245),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: sexoPet.value,
                                  dropdownColor:
                                      const Color.fromARGB(207, 245, 245, 245),
                                  onChanged: (String? value) {
                                    sexoPet.value = value!;
                                  },
                                  items: mascFem.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            height: 50,
                            child: CustomTextField(
                              controller: _pesoController,
                              labelText: "Peso",
                              hintText: "Digite o peso (Kg)",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            height: 50,
                            child: CustomTextField(
                              controller: _racaController,
                              labelText: "Raça",
                              hintText: "Digite a raça",
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          pet != null
                              ? SizedBox(
                                  width: queryData.size.width,
                                  height: 50,
                                  child: CustomButton(
                                    onPressed: () {
                                      if (_nomeController.text == '' ||
                                          _dataController.text == '' ||
                                          _pesoController.text == '' ||
                                          _racaController.text == '') {
                                        showTopSnackBar(
                                            Overlay.of(context),
                                            CustomSnackBar.error(
                                              message:
                                                  "Erro ao tentar atualizar o pet. Por favor, verifique as informações fornecidas.",
                                              backgroundColor: Colors.red,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                            ));
                                      } else {
                                        DateTime? date;
                                        try {
                                          date = dateFormat
                                              .parse(_dataController.text);
                                          final timestamp =
                                              Timestamp.fromDate(date);
                                          Pets petAtualizado;
                                          petAtualizado = Pets(
                                            id: pet!.id,
                                            idLocal: pet!.idLocal,
                                            nome: _nomeController.text,
                                            raca: _racaController.text,
                                            sexo: sexoPet.value,
                                            nascimento: timestamp,
                                            peso: double.parse(
                                                _pesoController.text),
                                            imagem: pet!.imagem,
                                            tutor: pet!.tutor,
                                            localImagem: pet!.localImagem,
                                          );

                                          petsController.atualizarPet(
                                              petAtualizado,
                                              imagemSelecionada,
                                              croppedImage);
                                          Get.offNamed('/home');
                                        } catch (e) {
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            CustomSnackBar.error(
                                              message:
                                                  "Erro ao tentar cadastrar o pet. Por favor, verifique as informações fornecidas.",
                                              backgroundColor: Colors.red,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    text: "Atualizar",
                                    color: Colors.white,
                                    textColor: Colors.black,
                                  ),
                                )
                              : SizedBox(
                                  width: queryData.size.width,
                                  height: 50,
                                  child: CustomButton(
                                    onPressed: () {
                                      if (_nomeController.text == '' ||
                                          _dataController.text == '' ||
                                          _pesoController.text == '' ||
                                          _racaController.text == '') {
                                        showTopSnackBar(
                                            Overlay.of(context),
                                            CustomSnackBar.error(
                                              message:
                                                  "Erro ao tentar cadastrar o pet. Por favor, verifique as informações fornecidas.",
                                              backgroundColor: Colors.red,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                            ));
                                      } else {
                                        DateTime? date;
                                        try {
                                          date = dateFormat
                                              .parse(_dataController.text);
                                          final timestamp =
                                              Timestamp.fromDate(date);
                                          Pets novoPet;
                                          novoPet = Pets(
                                            nome: _nomeController.text,
                                            raca: _racaController.text,
                                            sexo: sexoPet.value,
                                            nascimento: timestamp,
                                            peso: double.parse(
                                                _pesoController.text),
                                            tutor: loginController.uID.value,
                                          );
                                          petsController.criarPet(novoPet,
                                              imagemSelecionada, croppedImage);

                                          Get.offNamed('/home');
                                        } catch (e) {
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            CustomSnackBar.error(
                                              message:
                                                  "Erro ao tentar cadastrar o pet. Por favor, verifique as informações fornecidas.",
                                              backgroundColor: Colors.red,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    text: "Cadastre",
                                    color: Colors.white,
                                    textColor: Colors.black,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
