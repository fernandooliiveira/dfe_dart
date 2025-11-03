import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoAtorInteressado(OperacaoContexto contexto) async {
  final versaoAplic =
      contexto.config.extra(OperacaoConfiguracao.eventoVersaoAplicativo) ??
      '1.0.0';
  final cnpjInteressado = contexto.config.requireExtra(
    OperacaoConfiguracao.interessadoCnpj,
    'CNPJ do ator interessado',
  );
  final emailInteressado = contexto.config.requireExtra(
    OperacaoConfiguracao.interessadoEmail,
    'email do ator interessado',
  );
  final foneInteressado = contexto.config.requireExtra(
    OperacaoConfiguracao.interessadoFone,
    'telefone do ator interessado',
  );

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '110150',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'Registro de Evento do Ator Interessado',
    campos: [
      EventoCampo(tag: 'tpAutor', valor: '1'),
      EventoCampo(tag: 'verAplic', valor: versaoAplic),
      EventoCampo(tag: 'CNPJInteressado', valor: cnpjInteressado),
      EventoCampo(tag: 'emailInteressado', valor: emailInteressado),
      EventoCampo(tag: 'foneInteressado', valor: foneInteressado),
    ],
  );

  await contexto.executarOperacao(
    'Evento Ator Interessado',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
