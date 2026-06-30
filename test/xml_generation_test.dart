import 'package:dfe_dart/dfe_dart.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

// Helpers reutilizados nos testes
IdeModel _buildIde() => IdeModel(
      cUF: EEstado.sp,
      cNF: '00000001',
      natOp: 'VENDA AO CONSUMIDOR',
      mod: EModeloDocumento.nfCe,
      serie: 1,
      nNF: 1,
      dEmi: DateTime(2024, 1, 15),
      dSaiEnt: DateTime(2024, 1, 15),
      dhEmi: DateTime(2024, 1, 15, 10, 30, 0),
      tpNF: ETipoNfe.tnSaida,
      idDest: EDestinoOperacao.doInterna,
      cMunF: 3550308,
      tpImp: ETipoImpressao.tiNFCe,
      tpEmis: ETipoEmissao.teNormal,
      cDV: 0,
      tpAmb: ETipoAmbiente.homologacao,
      finNFe: EFinalidadeNFe.fnNormal,
      indFinal: EConsumidorFinal.cfConsumidorFinal,
      indPres: EPresencaComprador.pcPresencial,
      procEmi: ProcessoEmissao.peAplicativoContribuinte,
      verProc: '1.0.0',
    );

EmitModel _buildEmit() => EmitModel(
      cnpj: '12345678000195',
      xNome: 'EMPRESA TESTE LTDA',
      crt: ECrt.simplesNacional,
      enderEmit: EnderecoModel(
        xLgr: 'Rua das Flores',
        nro: '123',
        xBairro: 'Centro',
        cMun: 3550308,
        xMun: 'São Paulo',
        uf: EEstado.sp,
        cep: '01310100',
      ),
    );

DetModel _buildDet() => DetModel(
      nItem: 1,
      prod: ProdModel(
        cProd: '001',
        cEAN: 'SEM GTIN',
        xProd: 'PRODUTO TESTE',
        ncm: '84713012',
        cfop: '5102',
        uCom: 'UN',
        qCom: 1.0,
        vUnCom: 10.0,
        vProd: 10.0,
        cEANTrib: 'SEM GTIN',
        uTrib: 'UN',
        qTrib: 1.0,
        vUnTrib: 10.0,
        indTot: 1,
      ),
      imposto: ImpostoModel(
        icms: IcmsSn102(orig: '0', csosn: '400'),
        pis: PisSn(),
        cofins: CofinsSn(),
      ),
    );

TotalModel _buildTotal() => TotalModel(
      icmsTot: ICMSTotModel(
        vBC: 0,
        vICMS: 0,
        vICMSDeson: 0,
        vFCP: 0,
        vBCST: 0,
        vST: 0,
        vFCPST: 0,
        vFCPSTRet: 0,
        vProd: 10.0,
        vFrete: 0,
        vSeg: 0,
        vDesc: 0,
        vPIS: 0,
        vCOFINS: 0,
        vOutro: 0,
        vNF: 10.0,
      ),
    );

PagModel _buildPag() => PagModel(
      detPag: [DetPagModel(tPag: EFormaPagamento.dinheiro, vPag: 10.0)],
    );

Nfe _buildNfe() => Nfe(
      infNfce: InfNfceModel(
        versao: EVersaoServico.versao400,
        ide: _buildIde(),
        emit: _buildEmit(),
        det: [_buildDet()],
        total: _buildTotal(),
        pag: _buildPag(),
      ),
      infNFeSupl: InfNFeSupl()
        ..qrCode = 'https://www.nfce.fazenda.sp.gov.br/qrcode?chNFe=...'
        ..urlChave = 'https://www.nfce.fazenda.sp.gov.br/consulta',
    );

void main() {
  late Nfe nfe;

  setUp(() => nfe = _buildNfe());

  group('IdeModel', () {
    test('writeXml gera elemento <ide> com campos obrigatórios', () {
      final el = nfe.infNfce.ide.writeXml();
      expect(el.name.local, 'ide');
      expect(el.findElements('cUF').single.innerText, '35');
      expect(el.findElements('mod').single.innerText, '65');
      expect(el.findElements('tpAmb').single.innerText, '2');
      expect(el.findElements('tpNF').single.innerText, '1');
    });

    test('writeXml formata série e nNF com zeros à esquerda', () {
      final el = nfe.infNfce.ide.writeXml();
      expect(el.findElements('serie').single.innerText, '001');
      expect(el.findElements('nNF').single.innerText, '000000001');
    });

    test('fromXml reconstrói IdeModel a partir do XML gerado', () {
      final reconstructed = IdeModel.fromXml(nfe.infNfce.ide.writeXml());
      expect(reconstructed.cUF, EEstado.sp);
      expect(reconstructed.serie, 1);
      expect(reconstructed.nNF, 1);
      expect(reconstructed.tpAmb, ETipoAmbiente.homologacao);
      expect(reconstructed.mod, EModeloDocumento.nfCe);
    });
  });

  group('InfNfceModel', () {
    test('writeXml gera elemento <infNFe> com atributos versao e Id', () {
      final el = nfe.infNfce.writeXml(id: 'NFe35...');
      expect(el.name.local, 'infNFe');
      expect(el.getAttribute('versao'), '4.00');
      expect(el.getAttribute('Id'), 'NFe35...');
    });

    test('fromXml reconstrói InfNfceModel', () {
      final reconstructed = InfNfceModel.fromXml(nfe.infNfce.writeXml(id: 'NFe35...'));
      expect(reconstructed.versao, EVersaoServico.versao400);
      expect(reconstructed.ide.cUF, EEstado.sp);
      expect(reconstructed.emit.cnpj, '12345678000195');
    });
  });

  group('Nfe', () {
    test('writeXml gera elemento <NFe> com namespace correto', () {
      final el = nfe.writeXml();
      expect(el.name.local, 'NFe');
      expect(el.getAttribute('xmlns'), 'http://www.portalfiscal.inf.br/nfe');
    });

    test('toXmlString retorna XML válido que pode ser parseado', () {
      expect(() => XmlDocument.parse(nfe.toXmlString()), returnsNormally);
    });

    test('fromXmlString reconstrói Nfe com infNFeSupl', () {
      final reconstructed = Nfe.fromXmlString(nfe.toXmlString());
      expect(reconstructed.infNfce.versao, EVersaoServico.versao400);
      expect(reconstructed.infNFeSupl, isNotNull);
      expect(reconstructed.infNFeSupl!.qrCode, contains('qrcode'));
    });

    test('toXmlString(pretty: true) gera XML indentado', () {
      final xmlStr = nfe.toXmlString(pretty: true);
      expect(xmlStr, contains('\n'));
      expect(xmlStr, contains('  '));
    });
  });

  group('DateTimeExtension', () {
    test('paraDataStringNfe retorna formato ISO 8601 com offset', () {
      final str = DateTime(2024, 1, 15, 10, 30, 0).paraDataStringNfe();
      expect(str, matches(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[+-]\d{2}:\d{2}$'));
    });
  });
}
