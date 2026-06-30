import 'package:dfe_dart/dfe_dart.dart';
import 'package:test/test.dart';

// ignore_for_file: lines_longer_than_80_chars

void main() {
  group('SoapBuilder', () {
    test('statusServico gera envelope SOAP válido', () {
      final soap = SoapBuilder.statusServico(cUF: '35', tpAmb: '2');

      expect(soap, contains('soap12:Envelope'));
      expect(soap, contains('consStatServ'));
      expect(soap, contains('<cUF>35</cUF>'));
      expect(soap, contains('<tpAmb>2</tpAmb>'));
      expect(soap, contains('<xServ>STATUS</xServ>'));
      expect(soap, contains('NFeStatusServico4'));
    });

    test('autorizacao inclui indSinc=1 obrigatório para NFC-e', () {
      final soap = SoapBuilder.autorizacao(
        xmlNfeAssinado: '<NFe><teste/></NFe>',
        cUF: '35',
        tpAmb: '2',
        idLote: '000000000000001',
      );

      expect(soap, contains('<indSinc>1</indSinc>'));
      expect(soap, contains('enviNFe'));
      expect(soap, contains('<NFe>'));
    });

    test('consultaProtocolo gera envelope correto', () {
      const chNFe = '35240112345678000195650010000000011000000011';
      final soap = SoapBuilder.consultaProtocolo(
        chNFe: chNFe,
        cUF: '35',
        tpAmb: '2',
      );

      expect(soap, contains('consSitNFe'));
      expect(soap, contains('<chNFe>$chNFe</chNFe>'));
      expect(soap, contains('<xServ>CONSULTAR</xServ>'));
    });

    test('recepcaoEvento encapsula o evento no envelope', () {
      const eventoXml = '<envEvento versao="1.00"><idLote>1</idLote></envEvento>';
      final soap = SoapBuilder.recepcaoEvento(
        xmlEventoAssinado: eventoXml,
        cUF: '35',
        tpAmb: '2',
      );

      expect(soap, contains('NFeRecepcaoEvento4'));
      expect(soap, contains('<envEvento'));
    });
  });

  // ─── EnderecoSefaz ──────────────────────────────────────────────────────

  group('EnderecoSefaz', () {
    test('retorna URL de homologação para SP - NfceAutorizacao', () {
      final url = EnderecoSefaz.obter(
        estado: EEstado.sp,
        ambiente: ETipoAmbiente.homologacao,
        servico: ETipoServicoSefaz.nfceAutorizacao,
      );

      expect(url, isNotEmpty);
      expect(url, startsWith('https://'));
      expect(url, contains('homolog'));
    });

    test('retorna URL de produção para SP - NfceAutorizacao', () {
      final url = EnderecoSefaz.obter(
        estado: EEstado.sp,
        ambiente: ETipoAmbiente.producao,
        servico: ETipoServicoSefaz.nfceAutorizacao,
      );

      expect(url, isNotEmpty);
      expect(url, startsWith('https://'));
      // Produção não deve conter "homolog"
      expect(url, isNot(contains('homolog')));
    });

    test('lança ArgumentError para estado/serviço sem endpoint cadastrado', () {
      // nfeInutilizacao para EEstado.an nunca é registrado
      expect(
        () => EnderecoSefaz.obter(
          estado: EEstado.an,
          ambiente: ETipoAmbiente.producao,
          servico: ETipoServicoSefaz.nfeInutilizacao,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('registrar permite adicionar endpoint customizado', () {
      EnderecoSefaz.registrar(
        estado: EEstado.an,
        ambiente: ETipoAmbiente.producao,
        servico: ETipoServicoSefaz.nfeInutilizacao,
        url: 'https://custom.endpoint.test/inut',
      );

      final url = EnderecoSefaz.obter(
        estado: EEstado.an,
        ambiente: ETipoAmbiente.producao,
        servico: ETipoServicoSefaz.nfeInutilizacao,
      );
      expect(url, equals('https://custom.endpoint.test/inut'));
    });
  });

  // ─── ETipoServicoSefaz ──────────────────────────────────────────────────

  group('ETipoServicoSefaz', () {
    test('namespace de nfceAutorizacao está correto', () {
      expect(
        ETipoServicoSefaz.nfceAutorizacao.namespace,
        equals('http://www.portalfiscal.inf.br/nfe/wsdl/NfceAutorizacao4'),
      );
    });
  });

  // ─── Parsers de Retorno ─────────────────────────────────────────────────

  group('RetornoStatus.fromSoapXml', () {
    const soapStatusOk = '''
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <nfeResultMsg>
      <retConsStatServ xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
        <tpAmb>2</tpAmb>
        <verAplic>SVRS202301101206</verAplic>
        <cStat>107</cStat>
        <xMotivo>Servico em Operacao</xMotivo>
        <cUF>35</cUF>
        <dhRecbto>2024-01-10T12:00:00-03:00</dhRecbto>
      </retConsStatServ>
    </nfeResultMsg>
  </soap:Body>
</soap:Envelope>''';

    test('parseia retorno com cStat 107 (em operação)', () {
      final ret = RetornoStatus.fromSoapXml(soapStatusOk);

      expect(ret.cStat, equals(107));
      expect(ret.xMotivo, equals('Servico em Operacao'));
      expect(ret.cUF, equals('35'));
      expect(ret.emOperacao, isTrue);
    });

    const soapStatusParado = '''
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <nfeResultMsg>
      <retConsStatServ xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
        <tpAmb>2</tpAmb>
        <verAplic>SVRS202301101206</verAplic>
        <cStat>108</cStat>
        <xMotivo>Servico Paralisado Momentaneamente</xMotivo>
        <cUF>35</cUF>
        <dhRecbto>2024-01-10T12:00:00-03:00</dhRecbto>
      </retConsStatServ>
    </nfeResultMsg>
  </soap:Body>
</soap:Envelope>''';

    test('emOperacao é false quando cStat != 107', () {
      final ret = RetornoStatus.fromSoapXml(soapStatusParado);
      expect(ret.cStat, equals(108));
      expect(ret.emOperacao, isFalse);
    });
  });

  group('RetornoAutorizacao.fromSoapXml', () {
    const soapAutorizado = '''
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <nfeResultMsg>
      <retEnviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
        <tpAmb>2</tpAmb>
        <verAplic>SVRS202301101206</verAplic>
        <cStat>104</cStat>
        <xMotivo>Lote processado</xMotivo>
        <cUF>35</cUF>
        <dhRecbto>2024-01-10T12:00:00-03:00</dhRecbto>
        <nRec>350000000001234</nRec>
        <protNFe versao="4.00">
          <infProt>
            <tpAmb>2</tpAmb>
            <verAplic>SVRS202301101206</verAplic>
            <chNFe>35240112345678000195650010000000011000000011</chNFe>
            <dhRecbto>2024-01-10T12:00:00-03:00</dhRecbto>
            <nProt>135240000001234</nProt>
            <digVal>abc123==</digVal>
            <cStat>100</cStat>
            <xMotivo>Autorizado o uso da NF-e</xMotivo>
          </infProt>
        </protNFe>
      </retEnviNFe>
    </nfeResultMsg>
  </soap:Body>
</soap:Envelope>''';

    test('parseia autorização com protocolo', () {
      final ret = RetornoAutorizacao.fromSoapXml(soapAutorizado);

      expect(ret.cStat, equals(104));
      expect(ret.processado, isTrue);
      expect(ret.nRec, equals('350000000001234'));
      expect(ret.protocolos, hasLength(1));

      final prot = ret.protocolo('35240112345678000195650010000000011000000011');
      expect(prot, isNotNull);
      expect(prot!.nProt, equals('135240000001234'));
      expect(prot.autorizado, isTrue);
    });

    test('protocolo retorna null para chave não encontrada', () {
      final ret = RetornoAutorizacao.fromSoapXml(soapAutorizado);
      expect(ret.protocolo('00000000000000000000000000000000000000000000'), isNull);
    });
  });

  group('RetornoEvento.fromSoapXml', () {
    const soapEvento = '''
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <nfeResultMsg>
      <retEnvEvento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">
        <idLote>1</idLote>
        <tpAmb>2</tpAmb>
        <verAplic>SVRS202301101206</verAplic>
        <cOrgao>35</cOrgao>
        <cStat>128</cStat>
        <xMotivo>Lote de Evento Processado</xMotivo>
        <cUF>35</cUF>
        <dhRecbto>2024-01-10T12:00:00-03:00</dhRecbto>
        <retEvento versao="1.00">
          <infEvento>
            <tpAmb>2</tpAmb>
            <verAplic>SVRS202301101206</verAplic>
            <cOrgao>35</cOrgao>
            <cStat>135</cStat>
            <xMotivo>Evento registrado e vinculado a NF-e</xMotivo>
            <chNFe>35240112345678000195650010000000011000000011</chNFe>
            <tpEvento>110111</tpEvento>
            <xEvento>Cancelamento</xEvento>
            <nSeqEvento>1</nSeqEvento>
            <dhRegEvento>2024-01-10T12:00:00-03:00</dhRegEvento>
            <nProt>135240000001234</nProt>
          </infEvento>
        </retEvento>
      </retEnvEvento>
    </nfeResultMsg>
  </soap:Body>
</soap:Envelope>''';

    test('parseia cancelamento registrado (cStat 135)', () {
      final ret = RetornoEvento.fromSoapXml(soapEvento);

      expect(ret.cStat, equals(128));
      expect(ret.eventos, hasLength(1));

      final evt = ret.eventos.first;
      expect(evt.cStat, equals(135));
      expect(evt.registrado, isTrue);
      expect(evt.tpEvento, equals('110111'));
      expect(evt.nProt, equals('135240000001234'));
    });
  });

  // ─── RetornoInutilizacao ────────────────────────────────────────────────

  group('RetornoInutilizacao.fromSoapXml', () {
    const soapInut = '''
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body>
    <nfeResultMsg>
      <retInutNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
        <infInut Id="ID35240112345678000195650010000000011000000009">
          <tpAmb>2</tpAmb>
          <verAplic>SVRS202301101206</verAplic>
          <cStat>102</cStat>
          <xMotivo>Inutilizacao de numero homologado</xMotivo>
          <cUF>35</cUF>
          <ano>24</ano>
          <CNPJ>12345678000195</CNPJ>
          <mod>65</mod>
          <serie>001</serie>
          <nNFIni>000000001</nNFIni>
          <nNFFin>000000009</nNFFin>
          <dhRecbto>2024-01-10T12:00:00-03:00</dhRecbto>
          <nProt>135240000001234</nProt>
        </infInut>
      </retInutNFe>
    </nfeResultMsg>
  </soap:Body>
</soap:Envelope>''';

    test('parseia inutilização com cStat 102', () {
      final ret = RetornoInutilizacao.fromSoapXml(soapInut);

      expect(ret.cStat, equals(102));
      expect(ret.inutilizado, isTrue);
      expect(ret.infInut, isNotNull);
      expect(ret.infInut!.cnpj, equals('12345678000195'));
      expect(ret.infInut!.serie, equals('001'));
      expect(ret.infInut!.nNFIni, equals('000000001'));
      expect(ret.infInut!.nNFFin, equals('000000009'));
      expect(ret.infInut!.nProt, equals('135240000001234'));
      expect(ret.infInut!.inutilizado, isTrue);
    });
  });

  // ─── EnderecoSefaz — estados adicionados ────────────────────────────────

  group('EnderecoSefaz — estados novos', () {
    final novosEstados = [
      EEstado.ms, EEstado.mt, EEstado.df, EEstado.es,
      EEstado.ba, EEstado.pe, EEstado.ce, EEstado.am,
      EEstado.pa, EEstado.ma, EEstado.pi, EEstado.rn,
      EEstado.pb, EEstado.al, EEstado.se, EEstado.to,
      EEstado.ro, EEstado.ac, EEstado.rr, EEstado.ap,
    ];

    for (final estado in novosEstados) {
      test('${estado.name.toUpperCase()} tem endpoint de homologação NfceAutorizacao', () {
        final url = EnderecoSefaz.obter(
          estado: estado,
          ambiente: ETipoAmbiente.homologacao,
          servico: ETipoServicoSefaz.nfceAutorizacao,
        );
        expect(url, startsWith('https://'));
      });

      test('${estado.name.toUpperCase()} tem endpoint de produção NfceAutorizacao', () {
        final url = EnderecoSefaz.obter(
          estado: estado,
          ambiente: ETipoAmbiente.producao,
          servico: ETipoServicoSefaz.nfceAutorizacao,
        );
        expect(url, startsWith('https://'));
      });
    }
  });

  // ─── RetornoSefazBase ───────────────────────────────────────────────────

  group('RetornoSefazBase', () {
    test('autorizado é true apenas com cStat 100', () {
      expect(RetornoStatus.fromSoapXml('''
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Body><nfeResultMsg>
    <retConsStatServ xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
      <cStat>100</cStat><xMotivo>Ok</xMotivo><cUF>35</cUF>
      <dhRecbto>2024-01-01T00:00:00</dhRecbto><verAplic>1</verAplic>
    </retConsStatServ>
  </nfeResultMsg></soap:Body>
</soap:Envelope>''').autorizado, isTrue);
    });
  });
}
