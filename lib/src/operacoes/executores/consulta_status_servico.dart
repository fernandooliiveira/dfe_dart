import 'package:xml_sign_dart/src/entidades/cons_stat_serv.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';

Future<void> executarConsultaStatusServico(OperacaoContexto contexto) async {
  final xmlConsStatServ = ConsStatServ(
    tpAmb: contexto.tpAmb,
    cUF: contexto.codigoUf,
  ).toXmlString();

  await contexto.executarOperacao(
    'Consulta status de servico',
    () => enviarConsultaStatusServico(
      xmlConsStatServ: xmlConsStatServ,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
