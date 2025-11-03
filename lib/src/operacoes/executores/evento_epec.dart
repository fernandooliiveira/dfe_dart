import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoEpec(OperacaoContexto contexto) async {
  final versaoAplic =
      contexto.config.extra(OperacaoConfiguracao.eventoVersaoAplicativo) ??
      '1.0.0';
  final ieEmitente = contexto.nfceModelo65Assinada.infNFe.emit.ie;
  final destUf = contexto.config.requireExtra(
    OperacaoConfiguracao.destinatarioUf,
    'UF do destinatario para EPEC',
  );
  final destCnpj = contexto.config.extra(OperacaoConfiguracao.destinatarioCnpj);
  final destCpf = contexto.config.extra(OperacaoConfiguracao.destinatarioCpf);
  final destIe = contexto.config.extra(OperacaoConfiguracao.destinatarioIe);

  if (destCnpj == null && destCpf == null) {
    throw StateError(
      'Informe CNPJ ou CPF do destinatario (variaveis ${OperacaoConfiguracao.destinatarioCnpj} ou ${OperacaoConfiguracao.destinatarioCpf}).',
    );
  }

  final totals = contexto.nfceModelo65Assinada.infNFe.total.icmsTot;
  final dhEmissao = formatarDataComOffset(contexto.dataReferencia);

  final destFilhos = <EventoCampo>[
    EventoCampo(tag: 'UF', valor: destUf),
    if (destCnpj != null) EventoCampo(tag: 'CNPJ', valor: destCnpj),
    if (destCpf != null) EventoCampo(tag: 'CPF', valor: destCpf),
    if (destIe != null) EventoCampo(tag: 'IE', valor: destIe),
  ];

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '110140',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'EPEC',
    campos: [
      EventoCampo(tag: 'cOrgaoAutor', valor: contexto.codigoUf),
      EventoCampo(tag: 'tpAutor', valor: '1'),
      EventoCampo(tag: 'verAplic', valor: versaoAplic),
      EventoCampo(tag: 'dhEmi', valor: dhEmissao),
      EventoCampo(
        tag: 'tpNF',
        valor: contexto.nfceModelo65Assinada.infNFe.ide.tpNF,
      ),
      EventoCampo(tag: 'IE', valor: ieEmitente),
      EventoCampo(tag: 'dest', filhos: destFilhos),
      EventoCampo(tag: 'vICMS', valor: totals.vICMS),
      EventoCampo(tag: 'vProd', valor: totals.vProd),
      EventoCampo(tag: 'vNF', valor: totals.vNF),
      EventoCampo(tag: 'vICMSST', valor: totals.vST),
      EventoCampo(tag: 'vPIS', valor: totals.vPIS),
      EventoCampo(tag: 'vCOFINS', valor: totals.vCOFINS),
    ],
  );

  await contexto.executarOperacao(
    'Evento EPEC',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
