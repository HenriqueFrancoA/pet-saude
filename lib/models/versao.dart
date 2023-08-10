import 'package:cloud_firestore/cloud_firestore.dart';

class Versao {
  String? id;
  String? uId;
  int? versao;
  String? dispositivoToken;

  Versao({
    this.id,
    this.uId,
    this.versao,
    this.dispositivoToken,
  });

  factory Versao.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Versao(
      id: snapshot.id,
      uId: data['UID'],
      versao: data['VERSAO'],
      dispositivoToken: data['DISPOSITIVO_TOKEN'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uId,
      'versao': versao,
      'dispositivoToken': dispositivoToken,
    };
  }

  factory Versao.fromMap(Map<String, dynamic> map) {
    return Versao(
      id: map['id'],
      uId: map['uid'],
      versao: map['versao'],
      dispositivoToken: map['dispositivoToken'],
    );
  }

  Versao.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    uId = json['UID'];
    versao = json['VERSAO'];
    dispositivoToken = json['DISPOSITIVO_TOKEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['UID'] = uId;
    data['VERSAO'] = versao;
    data['DISPOSITIVO_TOKEN'] = dispositivoToken;

    return data;
  }
}
