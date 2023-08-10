import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pet_care/models/pets.dart';

class Vermifugos {
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

  Vermifugos({
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

  factory Vermifugos.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Vermifugos(
      idFirebase: snapshot.id,
      nome: data['NOME'],
      peso: data['PESO'],
      dose: data['DOSE'],
      dataVacinacao: data['DATA_VACINACAO'],
      proximaVacinacao: data['PROXIMA_VACINACAO'],
      imagem: data['IMAGEM'],
      pet: Pets.fromSnapshot(data['PET']),
    );
  }

  Map<String, dynamic> toMap() {
    final intl.DateFormat dateFormat = intl.DateFormat('dd/MM/yyyy', 'pt_BR');
    return {
      'id_vermifugo': id,
      'id_vermifugo_firebase': idFirebase,
      'nome_vermifugo': nome,
      'peso_vermifugo': peso,
      'dose': dose,
      'data_vacinacao': dateFormat.format(dataVacinacao!.toDate()),
      'proxima_vacinacao': dateFormat.format(proximaVacinacao!.toDate()),
      'imagem_vermifugo': imagem,
      'pet_local_id': localPet!.idLocal,
      'local_imagem_vermifugo': localImagem,
    };
  }

  factory Vermifugos.fromMap(Map<String, dynamic> map) {
    DateTime? date;
    final dateFormat = intl.DateFormat('dd/MM/yyyy');
    date = dateFormat.parse(map['data_vacinacao']);
    final timeVacinacao = Timestamp.fromDate(date);
    date = dateFormat.parse(map['proxima_vacinacao']);
    final timeProxima = Timestamp.fromDate(date);
    date = dateFormat.parse(map['nascimento']);
    final nascimento = Timestamp.fromDate(date);
    return Vermifugos(
      id: map['id_vermifugo'],
      idFirebase: map['id_firebase'],
      nome: map['nome_vermifugo'],
      peso: map['peso_vermifugo'],
      dose: map['dose'],
      dataVacinacao: timeVacinacao,
      proximaVacinacao: timeProxima,
      imagem: map['imagem_vermifugo'],
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
      localImagem: map['local_imagem_vermifugo'],
    );
  }

  Vermifugos.fromJson(Map<String, dynamic> json) {
    idFirebase = json['ID'];
    nome = json['NOME'];
    peso = json['PESO'];
    dose = json['DOSE'];
    dataVacinacao = json['DATA_VACINACAO'];
    proximaVacinacao = json['PROXIMA_VACINACAO'];
    imagem = json['IMAGEM'];
    pet = Pets.fromJson(json['PET']);
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
