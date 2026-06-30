import 'package:dfe_dart/dfe_dart.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  // ─── Enums ────────────────────────────────────────────────────────────────

  group('ECrt', () {
    test('valores XML corretos', () {
      expect(ECrt.simplesNacional.xmlValue, equals('1'));
      expect(ECrt.simplesNacionalExcesso.xmlValue, equals('2'));
      expect(ECrt.regimeNormal.xmlValue, equals('3'));
      expect(ECrt.mei.xmlValue, equals('4'));
    });

    test('round-trip via firstWhere', () {
      for (final e in ECrt.values) {
        expect(ECrt.values.firstWhere((v) => v.xmlValue == e.xmlValue), equals(e));
      }
    });
  });

  group('EFormaPagamento', () {
    test('valores XML conhecidos', () {
      expect(EFormaPagamento.dinheiro.xmlValue, equals('01'));
      expect(EFormaPagamento.cartaoCredito.xmlValue, equals('03'));
      expect(EFormaPagamento.cartaoDebito.xmlValue, equals('04'));
      expect(EFormaPagamento.pix.xmlValue, equals('17'));
      expect(EFormaPagamento.semPagamento.xmlValue, equals('90'));
    });

    test('todos os valores têm xmlValue não-vazio', () {
      for (final e in EFormaPagamento.values) {
        expect(e.xmlValue, isNotEmpty, reason: '${e.name} sem xmlValue');
      }
    });
  });

  group('ETipoNfe', () {
    test('entrada e saída', () {
      expect(ETipoNfe.tnEntrada.xmlValue, equals('0'));
      expect(ETipoNfe.tnSaida.xmlValue, equals('1'));
    });
  });

  group('EFinalidadeNFe', () {
    test('normal e complementar', () {
      expect(EFinalidadeNFe.fnNormal.xmlValue, equals('1'));
      expect(EFinalidadeNFe.fnComplementar.xmlValue, equals('2'));
      expect(EFinalidadeNFe.fnDevolucao.xmlValue, equals('4'));
    });
  });

  group('ETipoEmissao', () {
    test('normal e contingências', () {
      expect(ETipoEmissao.teNormal.xmlValue, equals('1'));
      expect(ETipoEmissao.teOffLine.xmlValue, equals('9'));
      expect(ETipoEmissao.teSVCAN.xmlValue, equals('6'));
      expect(ETipoEmissao.teSVCRS.xmlValue, equals('7'));
    });
  });

  group('EConsumidorFinal', () {
    test('não e consumidor final', () {
      expect(EConsumidorFinal.cfNao.xmlValue, equals('0'));
      expect(EConsumidorFinal.cfConsumidorFinal.xmlValue, equals('1'));
    });
  });

  group('EPresencaComprador', () {
    test('valores principais', () {
      expect(EPresencaComprador.pcNao.xmlValue, equals('0'));
      expect(EPresencaComprador.pcPresencial.xmlValue, equals('1'));
      expect(EPresencaComprador.pcInternet.xmlValue, equals('2'));
      expect(EPresencaComprador.pcOutros.xmlValue, equals('9'));
    });
  });

  group('ETipoImpressao', () {
    test('sem danfe, retrato, NFC-e', () {
      expect(ETipoImpressao.tiSemGeracao.xmlValue, equals('0'));
      expect(ETipoImpressao.tiRetrato.xmlValue, equals('1'));
      expect(ETipoImpressao.tiNFCe.xmlValue, equals('4'));
    });
  });

  group('EIndicadorIEDest', () {
    test('contribuinte ICMS, isento, não contribuinte', () {
      expect(EIndicadorIEDest.contribuinteICMS.xmlValue, equals('1'));
      expect(EIndicadorIEDest.contribuinteIsento.xmlValue, equals('2'));
      expect(EIndicadorIEDest.naoContribuinte.xmlValue, equals('9'));
    });
  });

  group('EModalidadeFrete', () {
    test('por conta emitente e sem frete', () {
      expect(EModalidadeFrete.porContaEmitente.xmlValue, equals('0'));
      expect(EModalidadeFrete.semFrete.xmlValue, equals('9'));
    });
  });

  // ─── ICMS — variantes ─────────────────────────────────────────────────────

  group('Icms00', () {
    late Icms00 icms;
    setUp(() => icms = Icms00(
          orig: '0', cst: '00', modBC: '3',
          vBC: 100.00, pICMS: 12.0, vICMS: 12.00,
        ));

    test('writeXml gera <ICMS00> com valores corretos', () {
      final xml = icms.writeXml().toXmlString();
      expect(xml, contains('<ICMS00>'));
      expect(xml, contains('<orig>0</orig>'));
      expect(xml, contains('<CST>00</CST>'));
      expect(xml, contains('<vBC>100.00</vBC>'));
      expect(xml, contains('<pICMS>12.0000</pICMS>'));
      expect(xml, contains('<vICMS>12.00</vICMS>'));
    });

    test('fromXml reconstrói Icms00', () {
      final icmsEl = icms.writeXml().getElement('ICMS00')!;
      final restored = Icms00.fromXml(icmsEl);
      expect(restored.cst, equals('00'));
      expect(restored.vBC, closeTo(100.0, 0.001));
      expect(restored.vICMS, closeTo(12.0, 0.001));
    });

    test('Icms.fromXml despacha para Icms00', () {
      expect(Icms.fromXml(icms.writeXml()), isA<Icms00>());
    });
  });

  group('Icms40', () {
    test('writeXml gera <ICMS40> sem campos de valor', () {
      final xml = Icms40(orig: '0', cst: '41').writeXml().toXmlString();
      expect(xml, contains('<ICMS40>'));
      expect(xml, isNot(contains('<vBC>')));
    });

    test('Icms.fromXml despacha para Icms40', () {
      expect(Icms.fromXml(Icms40(orig: '0', cst: '40').writeXml()), isA<Icms40>());
    });
  });

  group('IcmsSn102', () {
    test('writeXml gera <ICMSSN102>', () {
      expect(IcmsSn102(orig: '0', csosn: '400').writeXml().toXmlString(),
          contains('<ICMSSN102>'));
    });

    test('Icms.fromXml despacha para IcmsSn102', () {
      expect(Icms.fromXml(IcmsSn102(orig: '0', csosn: '400').writeXml()),
          isA<IcmsSn102>());
    });
  });

  group('IcmsSn500', () {
    test('writeXml gera <ICMSSN500>', () {
      expect(IcmsSn500(orig: '0', csosn: '500').writeXml().toXmlString(),
          contains('<ICMSSN500>'));
    });
  });

  group('Icms — variante desconhecida', () {
    test('Icms.fromXml lança ArgumentError para tag desconhecida', () {
      final el = XmlDocument.parse(
        '<ICMS><ICMS99><orig>0</orig></ICMS99></ICMS>',
      ).rootElement;
      expect(() => Icms.fromXml(el), throwsA(isA<ArgumentError>()));
    });
  });

  // ─── PIS — variantes ──────────────────────────────────────────────────────

  group('PisAliq', () {
    late PisAliq pis;
    setUp(() => pis = PisAliq(cst: '01', vBC: 100.00, pPIS: 0.65, vPIS: 0.65));

    test('writeXml gera <PISAliq> com valores', () {
      final xml = pis.writeXml().toXmlString();
      expect(xml, contains('<PISAliq>'));
      expect(xml, contains('<vPIS>0.65</vPIS>'));
    });

    test('Pis.fromXml round-trip', () {
      final restored = Pis.fromXml(pis.writeXml());
      expect(restored, isA<PisAliq>());
      expect((restored as PisAliq).vPIS, closeTo(0.65, 0.001));
    });
  });

  group('PisNt', () {
    test('writeXml gera <PISNT>', () {
      expect(PisNt(cst: '07').writeXml().toXmlString(), contains('<PISNT>'));
    });

    test('Pis.fromXml despacha para PisNt', () {
      expect(Pis.fromXml(PisNt(cst: '07').writeXml()), isA<PisNt>());
    });
  });

  group('PisSn', () {
    test('writeXml gera <PISSN>', () {
      expect(PisSn().writeXml().toXmlString(), contains('<PISSN>'));
    });

    test('Pis.fromXml despacha para PisSn', () {
      expect(Pis.fromXml(PisSn().writeXml()), isA<PisSn>());
    });
  });

  // ─── COFINS — variantes ───────────────────────────────────────────────────

  group('CofinsAliq', () {
    test('writeXml gera <COFINSAliq> com valores', () {
      const cofins = CofinsAliq(cst: '01', vBc: 100.00, pCofins: 3.00, vCofins: 3.00);
      final xml = cofins.writeXml().toXmlString();
      expect(xml, contains('<COFINSAliq>'));
      expect(xml, contains('<vCOFINS>3.00</vCOFINS>'));
      expect(xml, contains('<pCOFINS>3.0000</pCOFINS>'));
    });
  });

  group('CofinsNt', () {
    test('writeXml gera <COFINSNT>', () {
      expect(const CofinsNt(cst: '07').writeXml().toXmlString(), contains('<COFINSNT>'));
    });
  });

  group('CofinsSn', () {
    test('writeXml gera elemento COFINSSN', () {
      expect(const CofinsSn().writeXml().toXmlString(), contains('COFINSSN'));
    });
  });

  // ─── ImpostoModel ─────────────────────────────────────────────────────────

  group('ImpostoModel', () {
    ImpostoModel buildImposto() => ImpostoModel(
          icms: IcmsSn102(orig: '0', csosn: '400'),
          pis: PisSn(),
          cofins: const CofinsSn(),
        );

    test('writeXml gera <imposto> com ICMS, PIS e COFINS', () {
      final builder = XmlBuilder();
      buildImposto().writeXml(builder);
      final xml = builder.buildDocument().toXmlString();
      expect(xml, contains('<imposto>'));
      expect(xml, contains('<ICMS>'));
      expect(xml, contains('<PIS>'));
      expect(xml, contains('COFINS'));
    });

    test('writeXml inclui vTotTrib quando fornecido', () {
      final imp = ImpostoModel(
        icms: Icms40(orig: '0', cst: '40'),
        pis: PisNt(cst: '07'),
        cofins: const CofinsNt(cst: '07'),
        vTotTrib: 4.35,
      );
      final builder = XmlBuilder();
      imp.writeXml(builder);
      expect(builder.buildDocument().toXmlString(), contains('<vTotTrib>4.35</vTotTrib>'));
    });

    test('writeXml omite vTotTrib quando null', () {
      final builder = XmlBuilder();
      buildImposto().writeXml(builder);
      expect(builder.buildDocument().toXmlString(), isNot(contains('vTotTrib')));
    });

    test('fromXml reconstrói ImpostoModel', () {
      final builder = XmlBuilder();
      buildImposto().writeXml(builder);
      final el = builder.buildDocument().rootElement;
      final restored = ImpostoModel.fromXml(el);
      expect(restored.icms, isA<IcmsSn102>());
      expect(restored.pis, isA<PisSn>());
      expect(restored.cofins, isA<CofinsSn>());
      expect(restored.vTotTrib, isNull);
    });

    test('fromXml lança ArgumentError quando ICMS ausente', () {
      final el = XmlDocument.parse(
        '<imposto><PIS><PISSN/></PIS><COFINS><COFINSSN/></COFINS></imposto>',
      ).rootElement;
      expect(() => ImpostoModel.fromXml(el), throwsA(isA<ArgumentError>()));
    });

    test('fromXml lança ArgumentError quando PIS ausente', () {
      final el = XmlDocument.parse(
        '<imposto><ICMS><ICMS40><orig>0</orig><CST>40</CST></ICMS40></ICMS>'
        '<COFINS><COFINSSN/></COFINS></imposto>',
      ).rootElement;
      expect(() => ImpostoModel.fromXml(el), throwsA(isA<ArgumentError>()));
    });
  });

  // ─── RetornoInutilizacao — cenários ───────────────────────────────────────

  group('RetornoInutilizacao — cenários', () {
    test('inutilizado retorna false quando cStat != 102', () {
      const soap = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retInutNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
      <infInut Id="X">
        <tpAmb>2</tpAmb><verAplic>1</verAplic>
        <cStat>220</cStat><xMotivo>Rejeicao</xMotivo>
        <cUF>35</cUF><ano>24</ano><CNPJ>12345678000195</CNPJ>
        <mod>65</mod><serie>001</serie>
        <nNFIni>000000001</nNFIni><nNFFin>000000009</nNFFin>
      </infInut>
    </retInutNFe>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''';
      final ret = RetornoInutilizacao.fromSoapXml(soap);
      expect(ret.inutilizado, isFalse);
      expect(ret.infInut!.inutilizado, isFalse);
    });

    test('nProt é null quando não presente', () {
      const soap = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retInutNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
      <infInut Id="X">
        <tpAmb>2</tpAmb><verAplic>1</verAplic>
        <cStat>102</cStat><xMotivo>Inutilizacao ok</xMotivo>
        <cUF>35</cUF><ano>24</ano><CNPJ>12345678000195</CNPJ>
        <mod>65</mod><serie>001</serie>
        <nNFIni>000000001</nNFIni><nNFFin>000000001</nNFFin>
      </infInut>
    </retInutNFe>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''';
      expect(RetornoInutilizacao.fromSoapXml(soap).infInut!.nProt, isNull);
    });
  });

  // ─── RetornoAutorizacao — cenários de negócio ─────────────────────────────

  group('RetornoAutorizacao — cenários', () {
    test('ProtNFe.denegado reconhece cStat 110', () {
      const soap = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retEnviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
      <tpAmb>2</tpAmb><verAplic>1</verAplic>
      <cStat>104</cStat><xMotivo>Lote processado</xMotivo>
      <cUF>35</cUF><dhRecbto>2024-01-10T12:00:00</dhRecbto>
      <protNFe versao="4.00"><infProt>
        <chNFe>35240112345678000195650010000000011000000011</chNFe>
        <dhRecbto>2024-01-10T12:00:00</dhRecbto>
        <nProt>135240000001234</nProt><digVal>x=</digVal>
        <cStat>110</cStat><xMotivo>Uso Denegado</xMotivo>
      </infProt></protNFe>
    </retEnviNFe>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''';
      final prot = RetornoAutorizacao.fromSoapXml(soap)
          .protocolo('35240112345678000195650010000000011000000011');
      expect(prot!.denegado, isTrue);
      expect(prot.autorizado, isFalse);
    });

    test('múltiplos protocolos no mesmo lote', () {
      const soap = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retEnviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
      <tpAmb>2</tpAmb><verAplic>1</verAplic>
      <cStat>104</cStat><xMotivo>Lote processado</xMotivo>
      <cUF>35</cUF><dhRecbto>2024-01-10T12:00:00</dhRecbto>
      <protNFe versao="4.00"><infProt>
        <chNFe>35240112345678000195650010000000011000000011</chNFe>
        <dhRecbto>2024-01-10T12:00:00</dhRecbto>
        <nProt>135240000001111</nProt><digVal>x=</digVal>
        <cStat>100</cStat><xMotivo>Autorizado</xMotivo>
      </infProt></protNFe>
      <protNFe versao="4.00"><infProt>
        <chNFe>35240112345678000195650010000000022000000022</chNFe>
        <dhRecbto>2024-01-10T12:00:00</dhRecbto>
        <nProt>135240000002222</nProt><digVal>y=</digVal>
        <cStat>100</cStat><xMotivo>Autorizado</xMotivo>
      </infProt></protNFe>
    </retEnviNFe>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''';
      final ret = RetornoAutorizacao.fromSoapXml(soap);
      expect(ret.protocolos, hasLength(2));
      expect(
        ret.protocolo('35240112345678000195650010000000011000000011')!.nProt,
        equals('135240000001111'),
      );
    });

    test('RetornoSefazBase.duplicata reconhece cStat 204', () {
      const soap = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retEnviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
      <tpAmb>2</tpAmb><verAplic>1</verAplic>
      <cStat>204</cStat><xMotivo>Duplicidade de NF-e</xMotivo>
      <cUF>35</cUF><dhRecbto>2024-01-10T12:00:00</dhRecbto>
    </retEnviNFe>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''';
      final ret = RetornoAutorizacao.fromSoapXml(soap);
      expect(ret.duplicata, isTrue);
      expect(ret.autorizado, isFalse);
      expect(ret.processado, isFalse);
    });
  });

  // ─── RetornoEvento — cenários ─────────────────────────────────────────────

  group('RetornoEvento — cenários', () {
    test('cStat 136 é registrado', () {
      const soap = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retEnvEvento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">
      <idLote>1</idLote><tpAmb>2</tpAmb><verAplic>1</verAplic>
      <cOrgao>35</cOrgao><cStat>128</cStat>
      <xMotivo>Lote Processado</xMotivo><cUF>35</cUF>
      <dhRecbto>2024-01-10T12:00:00</dhRecbto>
      <retEvento versao="1.00"><infEvento>
        <tpAmb>2</tpAmb><verAplic>1</verAplic><cOrgao>35</cOrgao>
        <cStat>136</cStat><xMotivo>Evento registrado</xMotivo>
        <chNFe>35240112345678000195650010000000011000000011</chNFe>
        <tpEvento>110111</tpEvento><xEvento>Cancelamento</xEvento>
        <nSeqEvento>1</nSeqEvento><dhRegEvento>2024-01-10T12:00:00</dhRegEvento>
        <nProt>135240000001234</nProt>
      </infEvento></retEvento>
    </retEnvEvento>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''';
      expect(RetornoEvento.fromSoapXml(soap).eventos.first.registrado, isTrue);
    });

    test('cStat diferente de 135/136 não é registrado', () {
      const soap = '''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retEnvEvento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">
      <idLote>1</idLote><tpAmb>2</tpAmb><verAplic>1</verAplic>
      <cOrgao>35</cOrgao><cStat>128</cStat>
      <xMotivo>Lote Processado</xMotivo><cUF>35</cUF>
      <dhRecbto>2024-01-10T12:00:00</dhRecbto>
      <retEvento versao="1.00"><infEvento>
        <tpAmb>2</tpAmb><verAplic>1</verAplic><cOrgao>35</cOrgao>
        <cStat>573</cStat><xMotivo>Rejeicao: Duplicidade</xMotivo>
        <chNFe>35240112345678000195650010000000011000000011</chNFe>
        <tpEvento>110111</tpEvento><xEvento>Cancelamento</xEvento>
        <nSeqEvento>1</nSeqEvento><dhRegEvento>2024-01-10T12:00:00</dhRegEvento>
      </infEvento></retEvento>
    </retEnvEvento>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''';
      final evt = RetornoEvento.fromSoapXml(soap).eventos.first;
      expect(evt.registrado, isFalse);
      expect(evt.nProt, isNull);
    });
  });

  // ─── SoapBuilder — inutilização ───────────────────────────────────────────

  group('SoapBuilder.inutilizacao', () {
    test('gera envelope com NFeInutilizacao4 namespace', () {
      const inutXml = '<inutNFe versao="4.00"><Signature/></inutNFe>';
      final soap = SoapBuilder.inutilizacao(
        xmlInutAssinado: inutXml,
        cUF: '35',
        tpAmb: '2',
      );
      expect(soap, contains('NFeInutilizacao4'));
      expect(soap, contains('<inutNFe'));
    });
  });
}
