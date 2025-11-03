import 'package:xml_sign_dart/src/entidades/cons_reci_nfe.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';

Future<void> executarConsultaRecibo(OperacaoContexto contexto) async {
  final recibo = contexto.config.requireExtra(
    OperacaoConfiguracao.reciboNumero,
    'numero do recibo de autorizacao',
  );

  final xmlConsReciNFe = ConsReciNFe(
    tpAmb: contexto.tpAmb,
    nRec: recibo,
  ).toXmlString();

  await contexto.executarOperacao(
    'Consulta recibo de autorizacao',
    () => enviarConsultaRecibo(
      xmlConsReciNFe: xmlConsReciNFe,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
