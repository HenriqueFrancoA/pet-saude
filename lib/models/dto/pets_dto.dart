import 'package:cloud_firestore/cloud_firestore.dart';

class PetsDTO {
  String? nome;
  String? raca;
  String? sexo;
  Timestamp? nascimento;
  double? peso;
  String? imagem;
  String? tutor;

  PetsDTO(
      {this.nome,
      this.raca,
      this.sexo,
      this.nascimento,
      this.peso,
      this.imagem,
      this.tutor});

  PetsDTO.fromJson(Map<String, dynamic> json) {
    nome = json['NOME'];
    raca = json['RACA'];
    sexo = json['SEXO'];
    nascimento = json['NASCIMENTO'];
    peso = json['PESO'];
    imagem = json['IMAGEM'];
    tutor = json['TUTOR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['NOME'] = nome;
    data['RACA'] = raca;
    data['SEXO'] = sexo;
    data['NASCIMENTO'] = nascimento;
    data['PESO'] = peso;
    data['IMAGEM'] = imagem;
    data['TUTOR'] = tutor;

    return data;
  }
}
