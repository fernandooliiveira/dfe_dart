import 'package:dfe_dart/dfe_dart.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

// ignore_for_file: lines_longer_than_80_chars

// ── NFC-e completa usada em todos os testes ──────────────────────────────────

Nfe _buildNfe() {
  final enderEmit = EnderecoModel(
    xLgr: 'Rua das Flores',
    nro: '123',
    xBairro: 'Centro',
    cMun: 3550308,
    xMun: 'São Paulo',
    uf: EEstado.sp,
    cep: '01310100',
  );

  final emit = EmitModel(
    cnpj: '12345678000195',
    xNome: 'EMPRESA TESTE LTDA',
    enderEmit: enderEmit,
    crt: ECrt.simplesNacional,
  );

  final prod = ProdModel(
    cProd: '001',
    cEAN: 'SEM GTIN',
    xProd: 'CAMISETA AZUL TAM M',
    ncm: '61091000',
    cfop: '5102',
    uCom: 'UN',
    qCom: 2.0,
    vUnCom: 49.90,
    vProd: 99.80,
    cEANTrib: 'SEM GTIN',
    uTrib: 'UN',
    qTrib: 2.0,
    vUnTrib: 49.90,
    indTot: 1,
  );

  final imposto = ImpostoModel(
    icms: IcmsSn102(orig: '0', csosn: '400'),
    pis: PisSn(),
    cofins: const CofinsSn(),
  );

  final det = DetModel(nItem: 1, prod: prod, imposto: imposto);

  final icmsTot = ICMSTotModel(
    vBC: 0.00,
    vICMS: 0.00,
    vICMSDeson: 0.00,
    vBCST: 0.00,
    vST: 0.00,
    vProd: 99.80,
    vFrete: 0.00,
    vSeg: 0.00,
    vDesc: 0.00,
    vPIS: 0.00,
    vCOFINS: 0.00,
    vOutro: 0.00,
    vNF: 99.80,
  );

  final total = TotalModel(icmsTot: icmsTot);

  final pag = PagModel(
    detPag: [
      DetPagModel(tPag: EFormaPagamento.cartaoCredito, vPag: 99.80),
    ],
  );

  final dhEmi = DateTime(2024, 6, 15, 14, 30, 0);

  final ide = IdeModel(
    cUF: EEstado.sp,
    cNF: '00000042',
    natOp: 'VENDA AO CONSUMIDOR',
    mod: EModeloDocumento.nfCe,
    serie: 1,
    nNF: 42,
    dEmi: dhEmi,
    dSaiEnt: dhEmi,
    dhEmi: dhEmi,
    cMunF: 3550308,
    cDV: 0,
    tpAmb: ETipoAmbiente.homologacao,
    tpNF: ETipoNfe.tnSaida,
    tpEmis: ETipoEmissao.teNormal,
    tpImp: ETipoImpressao.tiNFCe,
    indFinal: EConsumidorFinal.cfConsumidorFinal,
    indPres: EPresencaComprador.pcPresencial,
    finNFe: EFinalidadeNFe.fnNormal,
  );

  final infNfce = InfNfceModel(
    versao: EVersaoServico.versao400,
    ide: ide,
    emit: emit,
    det: [det],
    total: total,
    pag: pag,
  );

  return Nfe(infNfce: infNfce);
}

/// Adiciona um bloco `<Signature>` fictício ao XML para simular um XML assinado.
/// O GeradorQrCodeNfce precisa extrair o `<DigestValue>` da assinatura.
String _injetarAssinatura(String xml, String digVal) {
  const sig = '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
      '<SignedInfo>'
      '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
      '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>'
      '<Reference URI="#infNFe">'
      '<Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/></Transforms>'
      '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>'
      '<DigestValue>PLACEHOLDER</DigestValue>'
      '</Reference>'
      '</SignedInfo>'
      '<SignatureValue>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=</SignatureValue>'
      '</Signature>';

  final comDigVal = sig.replaceFirst('PLACEHOLDER', digVal);

  // Insere antes do </NFe> de fechamento
  return xml.replaceFirst('</NFe>', '$comDigVal</NFe>');
}

void main() {
  const digValExemplo = 'abc+def/ghi==';
  const cIdToken = '000001';
  const csc = 'CSC_TESTE_HOMOLOGACAO_32CHARS_00';

  late Nfe nfe;
  late String xmlBase;
  late String xmlAssinado;
  late String chNFe;

  setUpAll(() {
    nfe = _buildNfe();
    xmlBase = nfe.toXmlString();
    xmlAssinado = _injetarAssinatura(xmlBase, digValExemplo);

    // Extrai chNFe do atributo Id do infNFe
    final doc = XmlDocument.parse(xmlAssinado);
    final id = doc.findAllElements('infNFe').first.getAttribute('Id') ?? '';
    chNFe = id.startsWith('NFe') ? id.substring(3) : id;
  });

  // ── Validação do XML gerado ─────────────────────────────────────────────────

  group('NFC-e XML gerado', () {
    test('XML é parseável e raiz é <NFe>', () {
      final doc = XmlDocument.parse(xmlBase);
      expect(doc.rootElement.name.local, equals('NFe'));
    });

    test('XML assinado contém <DigestValue>', () {
      expect(xmlAssinado, contains('<DigestValue>'));
      expect(xmlAssinado, contains(digValExemplo));
    });

    test('chNFe tem 46 dígitos', () {
      expect(chNFe.length, equals(46));
      expect(chNFe, matches(RegExp(r'^\d{46}$')));
    });

    test('chNFe começa com código SP (35)', () {
      expect(chNFe.substring(0, 2), equals('35'));
    });

    test('tpAmb no XML é 2 (homologação)', () {
      final doc = XmlDocument.parse(xmlAssinado);
      final tpAmb = doc.findAllElements('tpAmb').first.innerText;
      expect(tpAmb, equals('2'));
    });

    test('vNF no XML corresponde ao total configurado', () {
      final doc = XmlDocument.parse(xmlAssinado);
      final vNF = double.parse(doc.findAllElements('vNF').first.innerText);
      expect(vNF, closeTo(99.80, 0.001));
    });

    test('XML contém dados do emitente', () {
      expect(xmlBase, contains('12345678000195'));
      expect(xmlBase, contains('EMPRESA TESTE LTDA'));
    });

    test('XML contém produto e valores', () {
      expect(xmlBase, contains('CAMISETA AZUL TAM M'));
      expect(xmlBase, contains('99.80'));
    });
  });

  // ── gerarUrl com parâmetros explícitos ──────────────────────────────────────

  group('GeradorQrCodeNfce.gerarUrl (parâmetros explícitos)', () {
    late String url;
    const urlBase = 'https://www.homologacao.nfce.fazenda.sp.gov.br/qrcode';
    final dhEmi = DateTime(2024, 6, 15, 14, 30, 0);

    setUp(() {
      url = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 99.80,
        vICMS: 0.00,
        digVal: digValExemplo,
        cIdToken: cIdToken,
        csc: csc,
      );
    });

    test('contém chNFe correto', () {
      expect(url, contains('chNFe=$chNFe'));
    });

    test('contém nVersao=100', () {
      expect(url, contains('nVersao=100'));
    });

    test('contém tpAmb=2', () {
      expect(url, contains('tpAmb=2'));
    });

    test('digVal é URL-encoded corretamente', () {
      // abc+def/ghi== → abc%2Bdef%2Fghi%3D%3D
      expect(url, contains('digVal=abc%2Bdef%2Fghi%3D%3D'));
    });

    test('dhEmi em hex é positivo e não-zero', () {
      final match = RegExp(r'dhEmi=([0-9A-F]+)').firstMatch(url);
      expect(match, isNotNull);
      expect(int.parse(match!.group(1)!, radix: 16), greaterThan(0));
    });

    test('vNF de 99.80 → centavos 9980 → hex 26FC', () {
      // 99.80 * 100 = 9980 → hex = 26FC
      expect(url, contains('vNF=26FC'));
    });

    test('vICMS de 0.00 → centavos 0 → hex 0', () {
      expect(url, contains('vICMS=0'));
    });

    test('cIdToken com 6 dígitos', () {
      expect(url, contains('cIdToken=000001'));
    });

    test('cHashQRCode tem 40 caracteres hex (SHA-1)', () {
      final match = RegExp(r'cHashQRCode=([0-9A-F]+)').firstMatch(url);
      expect(match, isNotNull);
      expect(match!.group(1)!.length, equals(40));
    });

    test('URL não contém cDest quando não fornecido', () {
      expect(url, isNot(contains('cDest=')));
    });

    test('URL com CPF do destinatário inclui cDest', () {
      final urlComDest = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 99.80,
        vICMS: 0.00,
        digVal: digValExemplo,
        cIdToken: cIdToken,
        csc: csc,
        cpfDest: '12345678901',
      );
      expect(urlComDest, contains('cDest=12345678901'));
    });

    test('mesmos parâmetros produzem URL determinística', () {
      final url2 = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmi,
        vNF: 99.80,
        vICMS: 0.00,
        digVal: digValExemplo,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url, equals(url2));
    });
  });

  // ── gerarUrlDaNfe lendo do XML ──────────────────────────────────────────────

  group('GeradorQrCodeNfce.gerarUrlDaNfe (lendo do XML)', () {
    const urlBase = 'https://www.homologacao.nfce.fazenda.sp.gov.br/qrcode';
    late String url;

    setUp(() {
      url = GeradorQrCodeNfce.gerarUrlDaNfe(
        xmlAssinado: xmlAssinado,
        urlBase: urlBase,
        cIdToken: cIdToken,
        csc: csc,
      );
    });

    test('extrai chNFe correto do XML', () {
      expect(url, contains('chNFe=$chNFe'));
    });

    test('extrai tpAmb=2 do XML', () {
      expect(url, contains('tpAmb=2'));
    });

    test('resultado é idêntico ao gerarUrl com mesmos parâmetros', () {
      final dhEmiFromXml = DateTime(2024, 6, 15, 14, 30, 0);
      final urlManual = GeradorQrCodeNfce.gerarUrl(
        urlBase: urlBase,
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: dhEmiFromXml,
        vNF: 99.80,
        vICMS: 0.00,
        digVal: digValExemplo,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url, equals(urlManual));
    });

    test('contém cHashQRCode de 40 chars', () {
      final match = RegExp(r'cHashQRCode=([0-9A-F]+)').firstMatch(url);
      expect(match, isNotNull);
      expect(match!.group(1)!.length, equals(40));
    });
  });

  // ── gerarUrlCompleto (auto-detecta estado e versão) ─────────────────────────

  group('GeradorQrCodeNfce.gerarUrlCompleto (auto SP homologação)', () {
    late String url;

    setUp(() {
      url = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xmlAssinado,
        cIdToken: cIdToken,
        csc: csc,
      );
    });

    test('URL gerada não está vazia', () {
      expect(url, isNotEmpty);
    });

    test('contém chNFe de 44 dígitos', () {
      expect(url, contains('chNFe=$chNFe'));
    });

    test('contém nVersao=100', () {
      expect(url, contains('nVersao=100'));
    });

    test('URL base é de homologação (SP, tpEmis=1 → versao1)', () {
      // tpEmis=1 (teNormal) → qrCodeVersao1 → URL contém "homologacao"
      expect(url, contains('homologacao'));
    });

    test('contém tpAmb=2', () {
      expect(url, contains('tpAmb=2'));
    });

    test('contém cHashQRCode de 40 chars hex', () {
      final match = RegExp(r'cHashQRCode=([0-9A-F]+)').firstMatch(url);
      expect(match, isNotNull);
      expect(match!.group(1)!.length, equals(40));
    });

    test('URL completa começa com https://', () {
      expect(url, startsWith('https://'));
    });
  });

  // ── gerarUrlCompleto — contingência offline (tpEmis=9) ────────────────────

  group('GeradorQrCodeNfce.gerarUrlCompleto (contingência tpEmis=9)', () {
    // XML mínimo em contingência — tpEmis=9
    const xmlContingencia = '''<NFe xmlns="http://www.portalfiscal.inf.br/nfe">
  <infNFe versao="4.00" Id="NFe35240101234567890112345678901234567890123456">
    <ide>
      <cUF>35</cUF>
      <tpAmb>2</tpAmb>
      <tpEmis>9</tpEmis>
      <dhEmi>2024-06-15T14:30:00-03:00</dhEmi>
    </ide>
    <total><ICMSTot><vICMS>0.00</vICMS><vNF>99.80</vNF></ICMSTot></total>
  </infNFe>
  <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
    <SignedInfo><Reference URI="#NFe">
      <DigestValue>abc+def/ghi==</DigestValue>
    </Reference></SignedInfo>
    <SignatureValue>AAAA=</SignatureValue>
  </Signature>
</NFe>''';

    test('usa qrCodeVersao2 (URL diferente da versao1)', () {
      final urlV2 = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xmlContingencia,
        cIdToken: cIdToken,
        csc: csc,
      );
      final urlV1Normal = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xmlAssinado, // tpEmis=1
        cIdToken: cIdToken,
        csc: csc,
      );
      // Bases devem ser diferentes (versao2 vs versao1)
      final baseV2 = urlV2.split('?').first;
      final baseV1 = urlV1Normal.split('?').first;
      expect(baseV2, isNot(equals(baseV1)));
    });

    test('URL de contingência contém chNFe e cHashQRCode', () {
      final url = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xmlContingencia,
        cIdToken: cIdToken,
        csc: csc,
      );
      expect(url, contains('chNFe='));
      expect(url, contains('cHashQRCode='));
    });
  });

  // ── gerarMatriz ────────────────────────────────────────────────────────────

  group('GeradorQrCodeNfce.gerarMatriz', () {
    late List<List<bool>> matrix;

    setUpAll(() {
      final url = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xmlAssinado,
        cIdToken: cIdToken,
        csc: csc,
      );
      matrix = GeradorQrCodeNfce.gerarMatriz(url);
    });

    test('matriz não está vazia', () {
      expect(matrix, isNotEmpty);
    });

    test('matriz é quadrada (N×N)', () {
      final n = matrix.length;
      for (final row in matrix) {
        expect(row.length, equals(n));
      }
    });

    test('matriz contém módulos escuros e claros', () {
      final dark = matrix.expand((r) => r).where((v) => v).length;
      final light = matrix.expand((r) => r).where((v) => !v).length;
      expect(dark, greaterThan(0));
      expect(light, greaterThan(0));
    });

    test('dimensão QR Code é compatível com nível M (mínimo 21×21)', () {
      expect(matrix.length, greaterThanOrEqualTo(21));
    });
  });

  // ── gerarSvg ───────────────────────────────────────────────────────────────

  group('GeradorQrCodeNfce.gerarSvg', () {
    late String svg;

    setUpAll(() {
      final url = GeradorQrCodeNfce.gerarUrlCompleto(
        xmlAssinado: xmlAssinado,
        cIdToken: cIdToken,
        csc: csc,
      );
      svg = GeradorQrCodeNfce.gerarSvg(url, size: 300);
    });

    test('SVG começa e termina corretamente', () {
      expect(svg, startsWith('<svg'));
      expect(svg, endsWith('</svg>'));
    });

    test('SVG tem width e height de 300', () {
      expect(svg, contains('width="300"'));
      expect(svg, contains('height="300"'));
    });

    test('SVG contém fundo branco', () {
      expect(svg, contains('fill="white"'));
    });

    test('SVG contém módulos pretos', () {
      expect(svg, contains('fill="black"'));
    });

    test('SVG é parseável como XML válido', () {
      expect(() => XmlDocument.parse(svg), returnsNormally);
    });

    test('SVG contém múltiplos elementos rect (módulos do QR)', () {
      final rects = RegExp(r'<rect ').allMatches(svg).length;
      expect(rects, greaterThan(10));
    });

    test('tamanho padrão é 200 quando não especificado', () {
      final url = GeradorQrCodeNfce.gerarUrl(
        urlBase: 'https://homologacao.nfce.sp.gov.br/qrcode',
        chNFe: chNFe,
        tpAmb: 2,
        dhEmi: DateTime(2024, 6, 15, 14, 30, 0),
        vNF: 99.80,
        vICMS: 0.00,
        digVal: digValExemplo,
        cIdToken: cIdToken,
        csc: csc,
      );
      final svgDefault = GeradorQrCodeNfce.gerarSvg(url);
      expect(svgDefault, contains('width="200"'));
      expect(svgDefault, contains('height="200"'));
    });
  });
}
