import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pet_care/models/pets.dart';

class Vacinas {
  String? id;
  String? nome;
  double? peso;
  double? dose;
  Timestamp? dataVacinacao;
  Timestamp? proximaVacinacao;
  String? imagem;
  Pets? pet;
  String? localImagem;

  Vacinas({
    this.id,
    this.nome,
    this.peso,
    this.dose,
    this.dataVacinacao,
    this.proximaVacinacao,
    this.imagem,
    this.pet,
    this.localImagem,
  });

  factory Vacinas.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Vacinas(
        id: snapshot.id,
        nome: data['NOME'],
        peso: data['PESO'],
        dose: data['DOSE'],
        dataVacinacao: data['DATA_VACINACAO'],
        proximaVacinacao: data['PROXIMA_VACINACAO'],
        imagem: data['IMAGEM'],
        pet: data['PET']);
  }

  Map<String, dynamic> toMap() {
    final intl.DateFormat dateFormat = intl.DateFormat('dd/MM/yyyy', 'pt_BR');
    return {
      'id': id,
      'nome': nome,
      'peso': peso,
      'dose': dose,
      'data_vacinacao': dateFormat.format(dataVacinacao!.toDate()),
      'proxima_vacinacao': dateFormat.format(proximaVacinacao!.toDate()),
      'imagem': imagem,
      'pet_id': pet!.id,
      'local_imagem': localImagem,
    };
  }

  factory Vacinas.fromMap(Map<String, dynamic> map) {
    DateTime? date;
    final dateFormat = intl.DateFormat('dd/MM/yyyy');
    date = dateFormat.parse(map['data_vacinacao']);
    final timeVacinacao = Timestamp.fromDate(date);
    date = dateFormat.parse(map['proxima_vacinacao']);
    final timeProxima = Timestamp.fromDate(date);
    date = dateFormat.parse(map['nascimento']);
    final nascimento = Timestamp.fromDate(date);
    return Vacinas(
      id: map['id'],
      nome: map['nome'],
      peso: map['peso'],
      dose: map['dose'],
      dataVacinacao: timeVacinacao,
      proximaVacinacao: timeProxima,
      imagem: map['imagem'],
      pet: Pets(
        id: map['id:1'],
        nome: map['nome:1'],
        raca: map['raca'],
        sexo: map['sexo'],
        nascimento: nascimento,
        peso: map['peso:1'],
        imagem: map['imagem:1'],
        tutor: map['tutor'],
        localImagem: map['local_imagem'],
      ),
      localImagem: map['localImagem'],
    );
  }

  Vacinas.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
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
    data['ID'] = id;
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
