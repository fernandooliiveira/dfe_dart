import 'package:dfe_dart/src/enum/_init.dart';

class EnderecoConsultaPublicaNfceModel {
  final ETipoAmbiente tipoAmbiente;
  final EEstado estado;
  final ETipoUrlConsultaPublica tipoUrlConsultaPublica;
  final String url;
  final EVersaoServico versaoServico;
  final EVersaoQrCode versaoQrCode;

  EnderecoConsultaPublicaNfceModel({
    required this.tipoAmbiente,
    required this.estado,
    required this.tipoUrlConsultaPublica,
    required this.versaoServico,
    required this.versaoQrCode,
    required this.url,
  });
}
