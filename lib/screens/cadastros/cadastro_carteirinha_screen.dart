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
import 'package:pet_care/controllers/vacinas_controller.dart';
import 'package:pet_care/controllers/vermifugos_controller.dart';
import 'package:pet_care/controllers/versao_controller.dart';
import 'package:pet_care/models/pets.dart';
import 'package:pet_care/models/vacinas.dart';
import 'package:pet_care/models/vermifugos.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CadastroCarteirinhaScreen extends StatefulWidget {
  const CadastroCarteirinhaScreen({Key? key}) : super(key: key);

  @override
  CadastroCarteirinhaScreenState createState() =>
      CadastroCarteirinhaScreenState();
}

class CadastroCarteirinhaScreenState extends State<CadastroCarteirinhaScreen> {
  final pet = Get.arguments['pet'] as Pets?;
  final titulo = Get.arguments['titulo'] as String;

  late Reference storageRef;

  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();
  final _proximaDataController = TextEditingController();
  final _pesoController = TextEditingController();
  final _doseController = TextEditingController();

  final loginController = Get.put(LoginController());
  final vacinasController = Get.put(VacinasController());
  final vermifugosController = Get.put(VermifugosController());
  final versaoController = Get.put(VersaoController());

  String ref = '';
  XFile? image;
  File? croppedImage;
  bool imagemSelecionada = false;
  final dateFormat = DateFormat('dd/MM/yyyy');
  DateTime? _selectedDate;
  DateTime? _selectedProxDate;

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
        CropAspectRatioPreset.square,
      ],
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 405,
      maxWidth: 405,
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Recortar Imagem',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
    );
    return croppedImage;
  }

  @override
  void initState() {
    _nomeController.text = '';
    _doseController.text = '';
    _dataController.text = '';
    _pesoController.text = '';
    _proximaDataController.text = '';
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
                        onPressed: () {},
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.background,
                          size: 0,
                        ),
                      ),
                    ],
                  ),
                  !isKeyboard
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "ADICIONAR FOTO",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: getImage,
                                  child: CustomGlassmorphicContainer(
                                    width: 120,
                                    height: 120,
                                    borderRadius: 90,
                                    child: imagemSelecionada
                                        ? const Center(
                                            child: Icon(
                                              Icons.check,
                                              size: 45,
                                              color: Colors.green,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              color: Colors.white,
                                              size: 45,
                                            ),
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
                              hintText: "Digite o nome",
                              keyboardType: TextInputType.name,
                            ),
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
                              controller: _doseController,
                              labelText: "Dose",
                              hintText: "Digite a dose",
                              keyboardType: TextInputType.number,
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
                                  maxTime: DateTime(
                                      DateTime.now().year + 10, 12, 31),
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
                                labelText: 'Data da aplicação',
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
                                  maxTime: DateTime(
                                      DateTime.now().year + 10, 12, 31),
                                  onConfirm: (date) {
                                    setState(() {
                                      _selectedProxDate = date;
                                      _proximaDataController.text =
                                          dateFormat.format(date);
                                    });
                                  },
                                  currentTime:
                                      _selectedProxDate ?? DateTime.now(),
                                  locale: LocaleType.pt,
                                );
                              },
                              controller: _proximaDataController,
                              decoration: InputDecoration(
                                labelText: 'Proxima data',
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
                          SizedBox(
                            width: queryData.size.width,
                            height: 50,
                            child: CustomButton(
                              onPressed: () {
                                if (_nomeController.text == '' ||
                                    _dataController.text == '' ||
                                    _pesoController.text == '' ||
                                    _doseController.text == '') {
                                  showTopSnackBar(
                                      Overlay.of(context),
                                      CustomSnackBar.error(
                                        message:
                                            "Erro ao tentar atualizar o pet. Por favor, verifique as informações fornecidas.",
                                        backgroundColor: Colors.red,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                      ));
                                } else if (titulo.contains("VERMÍFUGOS")) {
                                  DateTime? date;
                                  try {
                                    date =
                                        dateFormat.parse(_dataController.text);
                                    final timeData = Timestamp.fromDate(date);
                                    date = dateFormat
                                        .parse(_proximaDataController.text);
                                    final timeProxima =
                                        Timestamp.fromDate(date);
                                    Vermifugos novoVermifugo;
                                    novoVermifugo = Vermifugos(
                                      nome: _nomeController.text,
                                      peso: double.parse(_pesoController.text),
                                      dose: double.parse(_doseController.text),
                                      dataVacinacao: timeData,
                                      proximaVacinacao: timeProxima,
                                      pet: pet,
                                      localPet: pet,
                                    );

                                    vermifugosController.criarVermifugo(
                                        novoVermifugo,
                                        croppedImage,
                                        imagemSelecionada);

                                    Get.back();
                                    Get.offNamed(
                                      "carteira",
                                      arguments: {
                                        'titulo': "VERMIFUGOS",
                                        'pet': pet,
                                      },
                                    );
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    );
                                  }
                                } else {
                                  DateTime? date;
                                  try {
                                    date =
                                        dateFormat.parse(_dataController.text);
                                    final timeData = Timestamp.fromDate(date);
                                    date = dateFormat
                                        .parse(_proximaDataController.text);
                                    final timeProxima =
                                        Timestamp.fromDate(date);
                                    //  FirebaseApi().scheduleNotification(date);
                                    Vacinas novaVacina;
                                    novaVacina = Vacinas(
                                      nome: _nomeController.text,
                                      peso: double.parse(_pesoController.text),
                                      dose: double.parse(_doseController.text),
                                      dataVacinacao: timeData,
                                      proximaVacinacao: timeProxima,
                                      pet: pet,
                                      localPet: pet,
                                    );
                                    vacinasController.criarVacina(novaVacina,
                                        croppedImage, imagemSelecionada);

                                    Get.back();
                                    Get.offNamed(
                                      "carteira",
                                      arguments: {
                                        'titulo': "VACINAS",
                                        'pet': pet,
                                      },
                                    );
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    );
                                  }
                                }
                              },
                              text: "Adicionar",
                              color: Colors.white,
                              textColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
