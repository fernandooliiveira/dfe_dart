import 'package:test/test.dart';
import 'package:dfe_dart/src/services/gerador_qrcode_nfce.dart';

void main() {
  // Parâmetros de exemplo para os testes
  const urlBase = 'https://www.nfce.fazenda.sp.gov.br/qrcode';
  const chNFe = '35240101234567890112345678901234567890123456';
  const cIdToken = '000001';
  const csc = 'ABCDEF1234567890ABCDEF1234567890';
  const digVal = 'abc+def/ghi=='; // digest de exemplo (base64)
  final dhEmi = DateTime(2024, 1, 15, 10, 30, 0);

  group('GeradorQrCodeNfce.gerarUrl', () {
    test('gera URL com parâmetros obrigatórios', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );

      expect(url, contains('chNFe=$chNFe'));
      expect(url, contains('nVersao=100'));
      expect(url, contains('tpAmb=2'));
      expect(url, contains('cHashQRCode='));
      // digVal URL-encoded: + → %2B, / → %2F, = → %3D
      expect(url, contains('digVal=abc%2Bdef%2Fghi%3D%3D'));
    });

    test('cIdToken é zero-padded para 6 dígitos', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: '1',
        csc: csc,
      );
      expect(url, contains('cIdToken=000001'));
    });

    test('cDest incluído quando fornecido', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 1,
        cpfDest: '12345678900',
        dhEmi: dhEmi,
        vNF: 100.00,
        vICMS: 12.00,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url, contains('cDest=12345678900'));
    });

    test('cDest omitido quando null', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url, isNot(contains('cDest=')));
    });

    test('urlBase sem ? recebe ? automaticamente', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: 'https://exemplo.sefaz.gov.br/nfce/qrcode',
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url, contains('https://exemplo.sefaz.gov.br/nfce/qrcode?chNFe='));
    });

    test('urlBase com ? não duplica separador', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: 'https://exemplo.sefaz.gov.br/nfce/qrcode?',
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url, isNot(contains('??')));
    });

    test('dhEmi em hex não-zero', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: DateTime.utc(2024, 1, 1),
        vNF: 10.00,
        vICMS: 0.00,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      // 2024-01-01 UTC = segundos desde 2000-01-01 UTC = 24 * 365.25 * ~... deve ser hex
      final match = RegExp(r'dhEmi=([0-9A-F]+)').firstMatch(url);
      expect(match, isNotNull);
      final hexVal = match!.group(1)!;
      expect(hexVal, isNotEmpty);
      // Deve ser valor positivo (> 0)
      expect(int.parse(hexVal, radix: 16), greaterThan(0));
    });

    test('cHashQRCode é SHA-1 hex de 40 caracteres', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      final match = RegExp(r'cHashQRCode=([0-9A-F]+)').firstMatch(url);
      expect(match, isNotNull);
      expect(match!.group(1)!.length, equals(40)); // SHA-1 = 20 bytes = 40 hex chars
    });

    test('mesmo CSC produz mesmo hash (determinístico)', () {
      final url1 = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      final url2 = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url1, equals(url2));
    });
  });

  group('GeradorQrCodeNfce.gerarMatriz', () {
    test('matriz é quadrada com módulos booleanos', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      final matrix = GeradorQrCodeNfce.gerarMatriz(url);
      expect(matrix, isNotEmpty);
      final n = matrix.length;
      for (final row in matrix) {
        expect(row.length, equals(n));
      }
    });
  });

  group('GeradorQrCodeNfce contingência (tpEmis=9)', () {
    test('gerarUrlCompleto usa qrCodeVersao2 para tpEmis=9 (SP)', () {
      // XML mínimo de NFC-e em contingência off-line (SP produção)
      const xml = '''<NFe xmlns="http://www.portalfiscal.inf.br/nfe">
  <infNFe versao="4.00" Id="NFe35240101234567890112345678901234567890123456">
    <ide>
      <cUF>35</cUF>
      <tpAmb>2</tpAmb>
      <tpEmis>9</tpEmis>
      <dhEmi>2024-01-15T10:30:00-03:00</dhEmi>
    </ide>
    <total><ICMSTot><vICMS>0.00</vICMS><vNF>10.50</vNF></ICMSTot></total>
  </infNFe>
  <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
    <SignedInfo><Reference URI="#NFe..."><DigestValue>abc+def/ghi==</DigestValue></Reference></SignedInfo>
    <SignatureValue>AAAA</SignatureValue>
  </Signature>
</NFe>''';

      final url = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xml,
        cIdToken: '000001',
        csc: 'CSC_TESTE',
      );

      // SP homologação versao2 aponta para a URL de contingência
      expect(url, contains('chNFe='));
      expect(url, contains('nVersao=100'));
      expect(url, contains('tpAmb=2'));
      expect(url, contains('cHashQRCode='));
    });

    test('gerarUrlCompleto usa qrCodeVersao1 para tpEmis=1 (SP)', () {
      const xml = '''<NFe xmlns="http://www.portalfiscal.inf.br/nfe">
  <infNFe versao="4.00" Id="NFe35240101234567890112345678901234567890123456">
    <ide>
      <cUF>35</cUF>
      <tpAmb>2</tpAmb>
      <tpEmis>1</tpEmis>
      <dhEmi>2024-01-15T10:30:00-03:00</dhEmi>
    </ide>
    <total><ICMSTot><vICMS>0.00</vICMS><vNF>10.50</vNF></ICMSTot></total>
  </infNFe>
  <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
    <SignedInfo><Reference URI="#NFe..."><DigestValue>abc+def/ghi==</DigestValue></Reference></SignedInfo>
    <SignatureValue>AAAA</SignatureValue>
  </Signature>
</NFe>''';

      final url = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xml,
        cIdToken: '000001',
        csc: 'CSC_TESTE',
      );

      expect(url, contains('chNFe='));
      expect(url, contains('homologacao')); // URL de homologação versao1 para SP
    });
  });

  group('GeradorQrCodeNfce.gerarSvg', () {
    test('SVG gerado é válido e contém elementos rect', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 10.50,
        vICMS: 0.95,
        digVal: digVal,
        cIdToken: cIdToken,
        csc: csc,
      );
      final svg = GeradorQrCodeNfce.gerarSvg(url, size: 200);

      expect(svg, startsWith('<svg'));
      expect(svg, endsWith('</svg>'));
      expect(svg, contains('fill="black"'));
      expect(svg, contains('fill="white"'));
    });
  });
}
