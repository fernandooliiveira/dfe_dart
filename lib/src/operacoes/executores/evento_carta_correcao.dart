import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoCartaCorrecao(OperacaoContexto contexto) async {
  final textoCorrecao = contexto.config.requireExtra(
    OperacaoConfiguracao.cartaCorrecaoTexto,
    'texto da carta de correcao',
  );
  final condUso = contexto.config.requireExtra(
    OperacaoConfiguracao.cartaCorrecaoCondUso,
    'condicoes de uso da carta de correcao',
  );

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '110110',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'Carta de Correcao',
    campos: [
      EventoCampo(tag: 'xCorrecao', valor: textoCorrecao),
      EventoCampo(tag: 'xCondUso', valor: condUso),
    ],
  );

  await contexto.executarOperacao(
    'Envio de evento (Carta de Correcao)',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
