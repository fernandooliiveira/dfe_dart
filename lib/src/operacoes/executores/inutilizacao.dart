import 'package:xml_sign_dart/src/assinar.dart';
import 'package:xml_sign_dart/src/entidades/inut_nfe.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarInutilizacao(OperacaoContexto contexto) async {
  final serie = contexto.config.requireExtra(
    OperacaoConfiguracao.inutilizacaoSerie,
    'serie da inutilizacao',
  );
  final numeroInicial = contexto.config.requireExtra(
    OperacaoConfiguracao.inutilizacaoNumeroInicial,
    'numero inicial da inutilizacao',
  );
  final numeroFinal =
      contexto.config.extra(OperacaoConfiguracao.inutilizacaoNumeroFinal) ??
      numeroInicial;
  final justificativa = contexto.config.requireExtra(
    OperacaoConfiguracao.inutilizacaoJustificativa,
    'justificativa da inutilizacao',
  );

  final idInutilizacao = montarIdInutilizacao(
    cUf: contexto.codigoUf,
    ano: contexto.anoFiscal,
    cnpj: contexto.cnpjEmitente,
    modelo: '65',
    serie: serie,
    numeroInicial: numeroInicial,
    numeroFinal: numeroFinal,
  );

  final xmlInutNFeAssinado = assinarXml(
    xmlOriginal: InutNFe(
      infInut: InfInut(
        id: idInutilizacao,
        tpAmb: contexto.tpAmb,
        cUF: contexto.codigoUf,
        ano: contexto.anoFiscal,
        cnpj: contexto.cnpjEmitente,
        mod: '65',
        serie: serie,
        nNFIni: numeroInicial,
        nNFFin: numeroFinal,
        xJust: justificativa,
      ),
    ).toXmlString(),
    cert: contexto.certBundle,
    tipo: TipoAssinatura.inutilizacao,
  );

  await contexto.executarOperacao(
    'Inutilizacao de numeracao',
    () => enviarInutilizacao(
      xmlInutNFe: xmlInutNFeAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
