import 'package:xml_sign_dart/src/entidades/dist_dfe_int.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';

Future<void> executarDistribuicaoDfe(OperacaoContexto contexto) async {
  final ultNsu = contexto.config.requireExtra(
    OperacaoConfiguracao.distribuicaoUltNsu,
    'ultimo NSU processado',
  );

  final xmlDistDFeInt = DistDFeInt(
    tpAmb: contexto.tpAmb,
    cUFAutor: contexto.codigoUf,
    cnpj: contexto.cnpjEmitente,
    distNSU: DistNSU(ultNSU: ultNsu),
  ).toXmlString();

  await contexto.executarOperacao(
    'Distribuicao DF-e',
    () => enviarDistribuicaoDFe(
      xmlDistDFeInt: xmlDistDFeInt,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      certificado: contexto.certBundle,
    ),
  );
}
