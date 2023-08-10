import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Pets {
  String? id;
  int? idLocal;
  String? nome;
  String? raca;
  String? sexo;
  Timestamp? nascimento;
  double? peso;
  String? imagem;
  String? tutor;
  String? localImagem;

  Pets({
    this.id,
    this.idLocal,
    this.nome,
    this.raca,
    this.sexo,
    this.nascimento,
    this.peso,
    this.imagem,
    this.tutor,
    this.localImagem,
  });

  factory Pets.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Pets(
        id: snapshot.id,
        nome: data['NOME'],
        raca: data['RACA'],
        sexo: data['SEXO'],
        nascimento: data['NASCIMENTO'],
        peso: data['PESO'],
        imagem: data['IMAGEM'],
        tutor: data['TUTOR']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': idLocal,
      'id_firebase': id,
      'nome': nome,
      'raca': raca,
      'sexo': sexo,
      'nascimento':
          DateFormat('dd/MM/yyyy', 'pt_BR').format(nascimento!.toDate()),
      'peso': peso,
      'imagem': imagem,
      'tutor': tutor,
      'local_imagem': localImagem,
    };
  }

  factory Pets.fromMap(Map<String, dynamic> map) {
    DateTime? date;
    final dateFormat = DateFormat('dd/MM/yyyy');
    date = dateFormat.parse(map['nascimento']);
    final timeNascimento = Timestamp.fromDate(date);
    return Pets(
      idLocal: map['id'],
      id: map['id_firebase'],
      nome: map['nome'],
      raca: map['raca'],
      sexo: map['sexo'],
      nascimento: timeNascimento,
      peso: map['peso'],
      imagem: map['imagem'],
      tutor: map['tutor'],
      localImagem: map['local_imagem'],
    );
  }

  Pets.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
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
    data['ID'] = id;
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
