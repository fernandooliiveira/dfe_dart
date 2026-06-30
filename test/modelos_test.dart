import 'package:dfe_dart/dfe_dart.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

// ─── fixture helpers ──────────────────────────────────────────────────────────

EnderecoModel get enderecoSp => const EnderecoModel(
      xLgr: 'Rua das Flores',
      nro: '123',
      xBairro: 'Centro',
      cMun: 3550308,
      xMun: 'Sao Paulo',
      uf: EEstado.sp,
      cep: '01310100',
    );

EmitModel get emitCnpj => EmitModel(
      cnpj: '12345678000195',
      xNome: 'Empresa Teste Ltda',
      xFant: 'Loja Teste',
      enderEmit: enderecoSp,
      ie: '111111111111',
      crt: ECrt.simplesNacional,
    );

void main() {
  // ─── EnderecoModel ─────────────────────────────────────────────────────────

  group('EnderecoModel', () {
    test('writeXml gera tag com nome correto', () {
      final el = enderecoSp.writeXml('enderEmit');
      expect(el.name.local, equals('enderEmit'));
    });

    test('writeXml inclui todos os campos obrigatórios', () {
      final xml = enderecoSp.writeXml('enderEmit').toXmlString();
      expect(xml, contains('<xLgr>Rua das Flores</xLgr>'));
      expect(xml, contains('<nro>123</nro>'));
      expect(xml, contains('<xBairro>Centro</xBairro>'));
      expect(xml, contains('<cMun>3550308</cMun>'));
      expect(xml, contains('<xMun>Sao Paulo</xMun>'));
      expect(xml, contains('<UF>SP</UF>'));
      expect(xml, contains('<CEP>01310100</CEP>'));
    });

    test('writeXml inclui xCpl quando fornecido', () {
      const end = EnderecoModel(
        xLgr: 'Av Brasil',
        nro: '1',
        xCpl: 'Apto 42',
        xBairro: 'Bairro',
        cMun: 3550308,
        xMun: 'Sao Paulo',
        uf: EEstado.sp,
        cep: '01000000',
      );
      expect(end.writeXml('end').toXmlString(), contains('<xCpl>Apto 42</xCpl>'));
    });

    test('writeXml omite xCpl quando null', () {
      expect(enderecoSp.writeXml('end').toXmlString(), isNot(contains('xCpl')));
    });

    test('writeXml inclui cPais e xPais por padrão', () {
      final xml = enderecoSp.writeXml('end').toXmlString();
      expect(xml, contains('<cPais>1058</cPais>'));
      expect(xml, contains('<xPais>Brasil</xPais>'));
    });

    test('fromXml reconstrói o modelo', () {
      final xml = enderecoSp.writeXml('enderEmit');
      final restored = EnderecoModel.fromXml(xml);
      expect(restored.xLgr, equals('Rua das Flores'));
      expect(restored.uf, equals(EEstado.sp));
      expect(restored.cMun, equals(3550308));
      expect(restored.cep, equals('01310100'));
    });

    test('fromXml reconstrói xCpl opcional', () {
      const end = EnderecoModel(
        xLgr: 'Rua A',
        nro: '1',
        xCpl: 'Bloco B',
        xBairro: 'Bairro',
        cMun: 3550308,
        xMun: 'Sao Paulo',
        uf: EEstado.sp,
        cep: '01000000',
      );
      final restored = EnderecoModel.fromXml(end.writeXml('end'));
      expect(restored.xCpl, equals('Bloco B'));
    });

    test('fromXml retorna xCpl null quando ausente', () {
      final restored = EnderecoModel.fromXml(enderecoSp.writeXml('end'));
      expect(restored.xCpl, isNull);
    });
  });

  // ─── EmitModel ─────────────────────────────────────────────────────────────

  group('EmitModel', () {
    test('writeXml gera <emit> com CNPJ e CRT', () {
      final xml = emitCnpj.writeXml().toXmlString();
      expect(xml, contains('<CNPJ>12345678000195</CNPJ>'));
      expect(xml, contains('<CRT>1</CRT>'));
      expect(xml, contains('<xNome>Empresa Teste Ltda</xNome>'));
      expect(xml, contains('<xFant>Loja Teste</xFant>'));
      expect(xml, contains('<IE>111111111111</IE>'));
    });

    test('writeXml com CPF (pessoa física)', () {
      final emit = EmitModel(
        cpf: '12345678900',
        xNome: 'Joao Silva',
        enderEmit: enderecoSp,
        crt: ECrt.mei,
      );
      final xml = emit.writeXml().toXmlString();
      expect(xml, contains('<CPF>12345678900</CPF>'));
      expect(xml, isNot(contains('<CNPJ>')));
      expect(xml, contains('<CRT>4</CRT>'));
    });

    test('assert falha quando nem cnpj nem cpf fornecido', () {
      expect(
        () => EmitModel(
          xNome: 'Sem documento',
          enderEmit: enderecoSp,
          crt: ECrt.simplesNacional,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('fromXml reconstrói EmitModel com CNPJ', () {
      final xml = emitCnpj.writeXml();
      final restored = EmitModel.fromXml(xml);
      expect(restored.cnpj, equals('12345678000195'));
      expect(restored.cpf, isNull);
      expect(restored.crt, equals(ECrt.simplesNacional));
      expect(restored.xFant, equals('Loja Teste'));
    });

    test('fromXml reconstrói campos opcionais como null', () {
      final emit = EmitModel(
        cnpj: '12345678000195',
        xNome: 'Empresa',
        enderEmit: enderecoSp,
        crt: ECrt.regimeNormal,
      );
      final restored = EmitModel.fromXml(emit.writeXml());
      expect(restored.xFant, isNull);
      expect(restored.ie, isNull);
      expect(restored.iest, isNull);
      expect(restored.im, isNull);
    });
  });

  // ─── DestModel ─────────────────────────────────────────────────────────────

  group('DestModel', () {
    test('writeXml com CPF e endereço', () {
      final dest = DestModel(
        cpf: '98765432100',
        xNome: 'Cliente Final',
        enderDest: enderecoSp,
        indIEDest: EIndicadorIEDest.contribuinteIsento,
      );
      final xml = dest.writeXml().toXmlString();
      expect(xml, contains('<CPF>98765432100</CPF>'));
      expect(xml, contains('<xNome>Cliente Final</xNome>'));
      expect(xml, contains('<indIEDest>2</indIEDest>'));
    });

    test('writeXml consumidor final sem identificação', () {
      final dest = DestModel(
        indIEDest: EIndicadorIEDest.naoContribuinte,
      );
      final xml = dest.writeXml().toXmlString();
      expect(xml, isNot(contains('<CPF>')));
      expect(xml, isNot(contains('<CNPJ>')));
    });

    test('fromXml reconstrói DestModel com endereço', () {
      final dest = DestModel(
        cnpj: '12345678000195',
        xNome: 'Destino',
        enderDest: enderecoSp,
        indIEDest: EIndicadorIEDest.contribuinteICMS,
        ie: '999999999999',
      );
      final restored = DestModel.fromXml(dest.writeXml());
      expect(restored.cnpj, equals('12345678000195'));
      expect(restored.ie, equals('999999999999'));
      expect(restored.indIEDest, equals(EIndicadorIEDest.contribuinteICMS));
      expect(restored.enderDest, isNotNull);
    });

    test('fromXml sem endereço retorna enderDest null', () {
      final dest = DestModel(indIEDest: EIndicadorIEDest.naoContribuinte);
      final restored = DestModel.fromXml(dest.writeXml());
      expect(restored.enderDest, isNull);
    });
  });

  // ─── ProdModel ─────────────────────────────────────────────────────────────

  group('ProdModel', () {
    ProdModel prodBase() => const ProdModel(
          cProd: 'P001',
          cEAN: 'SEM GTIN',
          xProd: 'Produto Teste',
          ncm: '22030000',
          cfop: '5102',
          uCom: 'UN',
          qCom: 2.0,
          vUnCom: 10.50,
          vProd: 21.00,
          cEANTrib: 'SEM GTIN',
          uTrib: 'UN',
          qTrib: 2.0,
          vUnTrib: 10.50,
          indTot: 1,
        );

    test('writeXml formata valores monetários com 2 casas', () {
      final builder = XmlBuilder();
      prodBase().writeXml(builder);
      final xml = builder.buildDocument().toXmlString();
      expect(xml, contains('<vProd>21.00</vProd>'));
    });

    test('writeXml formata quantidades com 10 casas decimais', () {
      final builder = XmlBuilder();
      prodBase().writeXml(builder);
      final xml = builder.buildDocument().toXmlString();
      expect(xml, contains('<qCom>2.0000000000</qCom>'));
      expect(xml, contains('<vUnCom>10.5000000000</vUnCom>'));
    });

    test('writeXml inclui vDesc quando fornecido', () {
      const prod = ProdModel(
        cProd: 'P001',
        cEAN: 'SEM GTIN',
        xProd: 'Produto',
        ncm: '22030000',
        cfop: '5102',
        uCom: 'UN',
        qCom: 1.0,
        vUnCom: 10.00,
        vProd: 9.00,
        cEANTrib: 'SEM GTIN',
        uTrib: 'UN',
        qTrib: 1.0,
        vUnTrib: 10.00,
        indTot: 1,
        vDesc: 1.00,
      );
      final builder = XmlBuilder();
      prod.writeXml(builder);
      expect(builder.buildDocument().toXmlString(), contains('<vDesc>1.00</vDesc>'));
    });

    test('fromXml reconstrói ProdModel', () {
      final builder = XmlBuilder();
      prodBase().writeXml(builder);
      final prodEl = builder.buildDocument().rootElement;
      final restored = ProdModel.fromXml(prodEl);
      expect(restored.cProd, equals('P001'));
      expect(restored.xProd, equals('Produto Teste'));
      expect(restored.vProd, closeTo(21.0, 0.001));
      expect(restored.qCom, closeTo(2.0, 0.001));
      expect(restored.vDesc, isNull);
    });

    test('fromXml reconstrói vDesc quando presente', () {
      const prod = ProdModel(
        cProd: 'P', cEAN: 'SEM GTIN', xProd: 'X', ncm: '22030000',
        cfop: '5102', uCom: 'UN', qCom: 1, vUnCom: 5, vProd: 4,
        cEANTrib: 'SEM GTIN', uTrib: 'UN', qTrib: 1, vUnTrib: 5,
        indTot: 1, vDesc: 1.00,
      );
      final builder = XmlBuilder();
      prod.writeXml(builder);
      final restored = ProdModel.fromXml(builder.buildDocument().rootElement);
      expect(restored.vDesc, closeTo(1.0, 0.001));
    });
  });

  // ─── DetPagModel / PagModel ────────────────────────────────────────────────

  group('PagModel', () {
    test('writeXml com pagamento único em dinheiro', () {
      final pag = PagModel(
        detPag: [DetPagModel(tPag: EFormaPagamento.dinheiro, vPag: 25.90)],
      );
      final xml = pag.writeXml().toXmlString();
      expect(xml, contains('<tPag>01</tPag>'));
      expect(xml, contains('<vPag>25.90</vPag>'));
    });

    test('writeXml com múltiplos meios de pagamento', () {
      final pag = PagModel(
        detPag: [
          DetPagModel(tPag: EFormaPagamento.cartaoDebito, vPag: 20.00),
          DetPagModel(tPag: EFormaPagamento.dinheiro, vPag: 5.90),
        ],
      );
      final xml = pag.writeXml().toXmlString();
      expect(xml, contains('<tPag>04</tPag>'));
      expect(xml, contains('<tPag>01</tPag>'));
    });

    test('writeXml inclui vTroco quando fornecido', () {
      final pag = PagModel(
        detPag: [DetPagModel(tPag: EFormaPagamento.dinheiro, vPag: 30.00)],
        vTroco: 4.10,
      );
      expect(pag.writeXml().toXmlString(), contains('<vTroco>4.10</vTroco>'));
    });

    test('assert falha com lista vazia de detPag', () {
      expect(() => PagModel(detPag: []), throwsA(isA<AssertionError>()));
    });

    test('fromXml reconstrói PagModel', () {
      final pag = PagModel(
        detPag: [
          DetPagModel(tPag: EFormaPagamento.pix, vPag: 50.00),
        ],
        vTroco: null,
      );
      final restored = PagModel.fromXml(pag.writeXml());
      expect(restored.detPag, hasLength(1));
      expect(restored.detPag.first.tPag, equals(EFormaPagamento.pix));
      expect(restored.detPag.first.vPag, closeTo(50.0, 0.001));
      expect(restored.vTroco, isNull);
    });

    test('fromXml reconstrói vTroco', () {
      final pag = PagModel(
        detPag: [DetPagModel(tPag: EFormaPagamento.dinheiro, vPag: 10.00)],
        vTroco: 2.00,
      );
      expect(PagModel.fromXml(pag.writeXml()).vTroco, closeTo(2.0, 0.001));
    });
  });

  // ─── ICMSTotModel / TotalModel ─────────────────────────────────────────────

  group('TotalModel', () {
    ICMSTotModel icmsBase() => ICMSTotModel(
          vBC: 0, vICMS: 0, vICMSDeson: 0,
          vBCST: 0, vST: 0,
          vProd: 21.00, vFrete: 0, vSeg: 0, vDesc: 0,
          vPIS: 0, vCOFINS: 0, vOutro: 0, vNF: 21.00,
        );

    test('writeXml gera <total> com <ICMSTot>', () {
      final total = TotalModel(icmsTot: icmsBase());
      final builder = XmlBuilder();
      total.writeXml(builder);
      final xml = builder.buildDocument().toXmlString();
      expect(xml, contains('<total>'));
      expect(xml, contains('<ICMSTot>'));
      expect(xml, contains('<vNF>21.00</vNF>'));
    });

    test('writeXml inclui campos opcionais quando fornecidos', () {
      final icms = ICMSTotModel(
        vBC: 0, vICMS: 0, vICMSDeson: 0,
        vBCST: 0, vST: 0,
        vProd: 100, vFrete: 0, vSeg: 0, vDesc: 0,
        vPIS: 0.65, vCOFINS: 3.00, vOutro: 0, vNF: 100,
        vTotTrib: 5.50,
      );
      final total = TotalModel(icmsTot: icms);
      final builder = XmlBuilder();
      total.writeXml(builder);
      expect(builder.buildDocument().toXmlString(), contains('<vTotTrib>5.50</vTotTrib>'));
    });

    test('fromXml reconstrói TotalModel', () {
      final total = TotalModel(icmsTot: icmsBase());
      final builder = XmlBuilder();
      total.writeXml(builder);
      final el = builder.buildDocument().rootElement;
      final restored = TotalModel.fromXml(el);
      expect(restored.icmsTot.vNF, closeTo(21.0, 0.001));
      expect(restored.icmsTot.vProd, closeTo(21.0, 0.001));
    });
  });

  // ─── DetModel ─────────────────────────────────────────────────────────────

  group('DetModel', () {
    test('writeXml inclui atributo nItem', () {
      final det = DetModel(
        nItem: 3,
        prod: const ProdModel(
          cProd: 'P003', cEAN: 'SEM GTIN', xProd: 'Item 3', ncm: '22030000',
          cfop: '5102', uCom: 'UN', qCom: 1, vUnCom: 5, vProd: 5,
          cEANTrib: 'SEM GTIN', uTrib: 'UN', qTrib: 1, vUnTrib: 5, indTot: 1,
        ),
        imposto: ImpostoModel(
          icms: Icms40(orig: '0', cst: '40'),
          pis: PisNt(cst: '07'),
          cofins: const CofinsNt(cst: '07'),
        ),
      );
      final builder = XmlBuilder();
      det.writeXml(builder);
      final xml = builder.buildDocument().toXmlString();
      expect(xml, contains('nItem="3"'));
      expect(xml, contains('<xProd>Item 3</xProd>'));
    });

    test('fromXml lança ArgumentError quando <prod> ausente', () {
      final el = XmlDocument.parse('<det nItem="1"><imposto/></det>').rootElement;
      expect(() => DetModel.fromXml(el), throwsA(isA<ArgumentError>()));
    });

    test('fromXml lança ArgumentError quando <imposto> ausente', () {
      final el = XmlDocument.parse(
        '<det nItem="1"><prod><cProd>P</cProd></prod></det>',
      ).rootElement;
      expect(() => DetModel.fromXml(el), throwsA(isA<ArgumentError>()));
    });

    test('fromXml reconstrói infAdProd', () {
      final det = DetModel(
        nItem: 1,
        prod: const ProdModel(
          cProd: 'X', cEAN: 'SEM GTIN', xProd: 'X', ncm: '22030000',
          cfop: '5102', uCom: 'UN', qCom: 1, vUnCom: 1, vProd: 1,
          cEANTrib: 'SEM GTIN', uTrib: 'UN', qTrib: 1, vUnTrib: 1, indTot: 1,
        ),
        imposto: ImpostoModel(
          icms: Icms40(orig: '0', cst: '40'),
          pis: PisNt(cst: '07'),
          cofins: const CofinsNt(cst: '07'),
        ),
        infAdProd: 'Obs do produto',
      );
      final builder = XmlBuilder();
      det.writeXml(builder);
      final restored = DetModel.fromXml(builder.buildDocument().rootElement);
      expect(restored.infAdProd, equals('Obs do produto'));
    });
  });
}
