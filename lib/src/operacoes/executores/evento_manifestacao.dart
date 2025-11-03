import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoManifestacao(OperacaoContexto contexto) async {
  final justificativa = contexto.config.extra(
    OperacaoConfiguracao.manifestacaoJustificativa,
  );

  final campos = <EventoCampo>[];
  if (justificativa != null && justificativa.isNotEmpty) {
    campos.add(EventoCampo(tag: 'xJust', valor: justificativa));
  }

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '210200',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'Confirmacao da Operacao',
    campos: campos,
  );

  await contexto.executarOperacao(
    'Manifestacao do Destinatario',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
