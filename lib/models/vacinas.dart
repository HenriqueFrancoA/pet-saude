import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pet_care/models/pets.dart';

class Vacinas {
  String? idFirebase;
  int? id;
  String? nome;
  double? peso;
  double? dose;
  Timestamp? dataVacinacao;
  Timestamp? proximaVacinacao;
  String? imagem;
  Pets? pet;
  Pets? localPet;
  String? localImagem;

  Vacinas({
    this.idFirebase,
    this.id,
    this.nome,
    this.peso,
    this.dose,
    this.dataVacinacao,
    this.proximaVacinacao,
    this.imagem,
    this.pet,
    this.localPet,
    this.localImagem,
  });

  factory Vacinas.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Vacinas(
        idFirebase: snapshot.id,
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
      'id_vacina': id,
      'id_vacina_firebase': idFirebase,
      'nome_vacina': nome,
      'peso_vacina': peso,
      'dose': dose,
      'data_vacinacao': dateFormat.format(dataVacinacao!.toDate()),
      'proxima_vacinacao': dateFormat.format(proximaVacinacao!.toDate()),
      'pet_local_id': localPet!.idLocal,
      'imagem_vacina': imagem,
      'local_imagem_vacina': localImagem,
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
      id: map['id_vacina'],
      idFirebase: map['id_vacina_firebase'],
      nome: map['nome_vacina'],
      peso: map['peso_vacina'],
      dose: map['dose'],
      dataVacinacao: timeVacinacao,
      proximaVacinacao: timeProxima,
      imagem: map['imagem_vacina'],
      localPet: Pets(
        idLocal: map['id'],
        id: map['id_firebase'],
        nome: map['nome'],
        raca: map['raca'],
        sexo: map['sexo'],
        nascimento: nascimento,
        peso: map['peso'],
        imagem: map['imagem'],
        tutor: map['tutor'],
        localImagem: map['local_imagem'],
      ),
      localImagem: map['local_imagem_vacina'],
    );
  }

  Vacinas.fromJson(Map<String, dynamic> json) {
    idFirebase = json['ID'];
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
    data['ID'] = idFirebase;
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
