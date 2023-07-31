import 'package:cloud_firestore/cloud_firestore.dart';

class VersaoDTO {
  String? uId;
  int? versao;

  VersaoDTO({
    this.uId,
    this.versao,
  });

  factory VersaoDTO.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return VersaoDTO(
      uId: data['UID'],
      versao: data['VERSAO'],
    );
  }

  VersaoDTO.fromJson(Map<String, dynamic> json) {
    uId = json['UID'];
    versao = json['VERSAO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UID'] = uId;
    data['VERSAO'] = versao;

    return data;
  }
}
