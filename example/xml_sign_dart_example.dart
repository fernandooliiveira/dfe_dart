import 'dart:io';

import 'package:xml_sign_dart/xml_sign_dart.dart' as xml_sign;

/// Exemplo de CLI simples usando a biblioteca `xml_sign_dart`.
Future<void> main(List<String> args) async {
  final configuracao = xml_sign.OperacaoConfiguracao.fromEnvironment();
  final numeroDocumento = configuracao.extra(
        xml_sign.OperacaoConfiguracao.numeroDocumento,
      ) ??
      '1';

  final contexto = await xml_sign.OperacaoContexto.carregar(
    configuracao: configuracao,
    numeroDocumento: numeroDocumento,
  );

  print('? Certificado carregado');
  print(
    '   Emitido para: ${contexto.certBundle.certData.tbsCertificate?.subject}',
  );

  final mapaOperacoes = xml_sign.registrarOperacoes();
  final operacoesSelecionadas = _resolverOperacoes(
    args,
    mapaOperacoes.keys.toList(),
  );

  if (operacoesSelecionadas.isEmpty) {
    return;
  }

  for (final nome in operacoesSelecionadas) {
    final executor = mapaOperacoes[nome];
    if (executor == null) {
      stderr.writeln('Operacao desconhecida: $nome');
      continue;
    }
    await executor(contexto);
  }
}

List<String> _resolverOperacoes(
  List<String> args,
  List<String> disponiveis,
) {
  final disponiveisSet = disponiveis.toSet();

  if (args.contains('--list')) {
    print('Operacoes disponiveis:');
    for (final nome in disponiveis) {
      print(' - $nome');
    }
    return [];
  }

  if (args.isEmpty || args.contains('all')) {
    return disponiveis;
  }

  final selecionadas = <String>[];
  for (final arg in args) {
    if (!disponiveisSet.contains(arg)) {
      stderr.writeln('Operacao desconhecida ignorada: $arg');
      continue;
    }
    selecionadas.add(arg);
  }

  if (selecionadas.isEmpty) {
    stderr.writeln(
      'Nenhuma operacao valida informada. Use --list para consultar.',
    );
  }

  return selecionadas;
}
