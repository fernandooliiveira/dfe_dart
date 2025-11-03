import 'package:test/test.dart';
import 'package:xml/xml.dart';
import 'package:xml_sign_dart/xml_sign_dart.dart';

void main() {
  group('montarEventoXml', () {
    test('gera XML valido para CNPJ', () {
      final xmlString = montarEventoXml(
        tpEvento: '110110',
        cOrgao: '31',
        tpAmb: '2',
        cnpjOuCpf: '12.345.678/0001-95',
        chaveNFe: '35150312345678000190550010000000011000000011',
        descEvento: 'Carta de Correcao',
        campos: const [
          EventoCampo(tag: 'xCorrecao', valor: 'Descricao corrigida'),
        ],
      );

      final document = XmlDocument.parse(xmlString);
      final infEvento = document.findAllElements('infEvento').first;
      expect(
        infEvento.getAttribute('Id'),
        equals('ID1101103515031234567800019055001000000001100000001101'),
      );
      expect(
        infEvento.findElements('CNPJ').first.innerText,
        equals('12345678000195'),
      );
      final detEvento = infEvento
          .findElements('detEvento')
          .first
          .findElements('descEvento');
      expect(detEvento.first.innerText, equals('Carta de Correcao'));
    });

    test('lanca erro para documento invalido', () {
      expect(
        () => montarEventoXml(
          tpEvento: '110110',
          cOrgao: '31',
          tpAmb: '2',
          cnpjOuCpf: '1234',
          chaveNFe: '35150312345678000190550010000000011000000011',
          descEvento: 'Carta de Correcao',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('codigoUfNumerico', () {
    test('retorna codigo conhecido', () {
      expect(codigoUfNumerico('MG'), equals('31'));
    });

    test('lanca erro para UF desconhecida', () {
      expect(() => codigoUfNumerico('ZZ'), throwsA(isA<ArgumentError>()));
    });
  });

  group('OperacaoConfiguracao', () {
    test('carrega configuracao minima do ambiente', () {
      final config = OperacaoConfiguracao.fromEnvironment(
        env: {
          'CERT_PATH': '/tmp/dummy.pfx',
          'CERT_PASSWORD': 'senha',
          'NFE_AMBIENTE': 'homologacao',
          'NFE_UF': 'MG',
          'NFE_EMIT_CNPJ': '12345678000195',
          'NFE_CSC_ID': '000001',
          'NFE_CSC_TOKEN': 'TOKEN123',
          OperacaoConfiguracao.cartaCorrecaoTexto: 'Descricao corrigida',
          OperacaoConfiguracao.cartaCorrecaoCondUso:
              'Uso exclusivo em ambiente de homologacao.',
        },
      );

      expect(config.uf, equals('MG'));
      expect(config.ambiente.name, equals('homologacao'));
      expect(
        config.requireExtra(
          OperacaoConfiguracao.cartaCorrecaoTexto,
          'texto carta',
        ),
        equals('Descricao corrigida'),
      );
    });
  });
}
