import 'package:xml_sign_dart/src/entidades/cons_sit_nfe.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';

Future<void> executarConsultaProtocolo(OperacaoContexto contexto) async {
  final xmlConsSitNFe = ConsSitNFe(
    tpAmb: contexto.tpAmb,
    chNFe: contexto.chaveNFe,
  ).toXmlString();

  await contexto.executarOperacao(
    'Consulta protocolo',
    () => enviarConsultaProtocolo(
      xmlConsSitNFe: xmlConsSitNFe,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
