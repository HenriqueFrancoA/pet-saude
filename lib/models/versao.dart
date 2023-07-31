import 'package:cloud_firestore/cloud_firestore.dart';

class Versao {
  String? id;
  String? uId;
  int? versao;

  Versao({
    this.id,
    this.uId,
    this.versao,
  });

  factory Versao.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Versao(
      id: snapshot.id,
      uId: data['UID'],
      versao: data['VERSAO'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uId,
      'versao': versao,
    };
  }

  factory Versao.fromMap(Map<String, dynamic> map) {
    return Versao(
      id: map['id'],
      uId: map['uid'],
      versao: map['versao'],
    );
  }

  Versao.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    uId = json['UID'];
    versao = json['VERSAO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['UID'] = uId;
    data['VERSAO'] = versao;

    return data;
  }
}
