import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoEconf(OperacaoContexto contexto) async {
  final hashEntrega = contexto.config.requireExtra(
    OperacaoConfiguracao.hashEntregaEconf,
    'hash de entrega para eConf',
  );
  final protocolo = contexto.config.requireExtra(
    OperacaoConfiguracao.protocoloEvento,
    'protocolo vinculado ao eConf',
  );

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '110700',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'Evento eConf',
    campos: [
      EventoCampo(tag: 'hashEntrega', valor: hashEntrega),
      EventoCampo(tag: 'nProt', valor: protocolo),
    ],
  );

  await contexto.executarOperacao(
    'Evento eConf',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
