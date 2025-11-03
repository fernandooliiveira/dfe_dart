import 'package:xml_sign_dart/src/entidades/adm_csc_nfce.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';

Future<void> executarAdministrarCsc(OperacaoContexto contexto) async {
  final xmlAdmCsc = AdmCscNfce(
    tpAmb: contexto.tpAmb,
    xServ: 'CONSULTAR',
    cnpj: contexto.cnpjEmitente,
    idCSC: contexto.idCSC,
    csc: contexto.csc,
  ).toXmlString();

  await contexto.executarOperacao(
    'Administrar CSC NFC-e',
    () => enviarAdministrarCscNFCe(
      xmlAdmCsc: xmlAdmCsc,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      certificado: contexto.certBundle,
    ),
  );
}
