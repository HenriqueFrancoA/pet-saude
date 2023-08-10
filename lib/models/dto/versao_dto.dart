import 'package:cloud_firestore/cloud_firestore.dart';

class VersaoDTO {
  String? uId;
  int? versao;
  String? dispositivoToken;

  VersaoDTO({
    this.uId,
    this.versao,
    this.dispositivoToken,
  });

  factory VersaoDTO.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return VersaoDTO(
      uId: data['UID'],
      versao: data['VERSAO'],
      dispositivoToken: data['DISPOSITIVO_TOKEN'],
    );
  }

  VersaoDTO.fromJson(Map<String, dynamic> json) {
    uId = json['UID'];
    versao = json['VERSAO'];
    dispositivoToken = json['DISPOSITIVO_TOKEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UID'] = uId;
    data['VERSAO'] = versao;
    data['DISPOSITIVO_TOKEN'] = dispositivoToken;

    return data;
  }
}
