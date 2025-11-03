# xml_sign_dart

Biblioteca para assinar XMLs de NF-e/NFC-e e consumir os servicos da SEFAZ a partir de aplicacoes Dart.

## Instalacao

Adicione a dependencia ao seu projeto:

```sh
dart pub add xml_sign_dart
```

## Guia rapido

```dart
import 'package:xml_sign_dart/xml_sign_dart.dart';

Future<void> main() async {
  final config = OperacaoConfiguracao(
    certificadoPath: 'certificados/meu_certificado.pfx',
    certificadoSenha: 'minha-senha',
    ambiente: Ambiente.homologacao,
    uf: 'MG',
    emitenteCnpj: '12345678000195',
    idCsc: '000001',
    csc: 'TOKEN123',
  );

  final contexto = await OperacaoContexto.carregar(
    configuracao: config,
    numeroDocumento: '1',
  );
  final operacoes = registrarOperacoes();

  await operacoes['status-servico']?.call(contexto);
}
```

### Variaveis de ambiente

`OperacaoConfiguracao.fromEnvironment` permite carregar a configuracao diretamente das variaveis de ambiente utilizadas pelos executores. Confira o arquivo `example/xml_sign_dart_example.dart` para um fluxo completo.

Para informar o numero do documento (NF-e/NFC-e) utilize a variavel `NFE_NUMERO_DOC` e repasse o valor ao carregar o contexto:

```dart
final numero = config.extra(OperacaoConfiguracao.numeroDocumento) ?? '1';
final contexto = await OperacaoContexto.carregar(
  configuracao: config,
  numeroDocumento: numero,
);
```

## Exemplos

O diretorio `example/` contem um exemplo de CLI que demonstra como carregar o certificado, assinar uma NFC-e de exemplo e executar multiplas operacoes SEFAZ.

## Testes

```sh
dart test
```

## Publicacao

Antes de publicar, execute:

```sh
dart pub publish --dry-run
```

Isso garante que todas as etapas de validacao da pub.dev sejam cumpridas.
