import 'package:cloud_firestore/cloud_firestore.dart';

class VacinasDTO {
  String? nome;
  double? peso;
  double? dose;
  Timestamp? dataVacinacao;
  Timestamp? proximaVacinacao;
  String? imagem;
  DocumentReference<Map<String, dynamic>>? pet;

  VacinasDTO({
    this.nome,
    this.peso,
    this.dose,
    this.dataVacinacao,
    this.proximaVacinacao,
    this.imagem,
    this.pet,
  });

  VacinasDTO.fromJson(Map<String, dynamic> json) {
    nome = json['NOME'];
    peso = json['PESO'];
    dose = json['DOSE'];
    dataVacinacao = json['DATA_VACINACAO'];
    proximaVacinacao = json['PROXIMA_VACINACAO'];
    imagem = json['IMAGEM'];
    pet = json['PET'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['NOME'] = nome;
    data['PESO'] = peso;
    data['DOSE'] = dose;
    data['DATA_VACINACAO'] = dataVacinacao;
    data['PROXIMA_VACINACAO'] = proximaVacinacao;
    data['IMAGEM'] = imagem;
    data['PET'] = pet;

    return data;
  }
}
