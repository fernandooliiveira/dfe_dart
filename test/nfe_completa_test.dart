import 'package:dfe_dart/dfe_dart.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

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
    xProd: 'PRODUTO TESTE',
    ncm: '84713012',
    cfop: '5102',
    uCom: 'UN',
    qCom: 1.0,
    vUnCom: 10.00,
    vProd: 10.00,
    cEANTrib: 'SEM GTIN',
    uTrib: 'UN',
    qTrib: 1.0,
    vUnTrib: 10.00,
    indTot: 1,
  );

  final imposto = ImpostoModel(
    icms: IcmsSn102(orig: '0', csosn: '400'),
    pis: PisSn(),
    cofins: const CofinsSn(),
  );

  final det = DetModel(
    nItem: 1,
    prod: prod,
    imposto: imposto,
  );

  final icmsTot = ICMSTotModel(
    vBC: 0.00,
    vICMS: 0.00,
    vICMSDeson: 0.00,
    vBCST: 0.00,
    vST: 0.00,
    vProd: 10.00,
    vFrete: 0.00,
    vSeg: 0.00,
    vDesc: 0.00,
    vPIS: 0.00,
    vCOFINS: 0.00,
    vOutro: 0.00,
    vNF: 10.00,
  );

  final total = TotalModel(icmsTot: icmsTot);

  final pag = PagModel(
    detPag: [
      DetPagModel(
        tPag: EFormaPagamento.dinheiro,
        vPag: 10.00,
      ),
    ],
  );

  final now = DateTime(2024, 1, 15, 10, 30, 0);

  final ide = IdeModel(
    cUF: EEstado.sp,
    cNF: '00000001',
    natOp: 'VENDA',
    mod: EModeloDocumento.nfCe,
    serie: 1,
    nNF: 1,
    dEmi: now,
    dSaiEnt: now,
    dhEmi: now,
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

void main() {
  late Nfe nfe;

  setUp(() {
    nfe = _buildNfe();
  });

  test('NFCe completa gera XML sem erros', () {
    final xml = nfe.toXmlString();
    expect(xml, isNotEmpty);
    // Should parse back without throwing
    final doc = XmlDocument.parse(xml);
    expect(doc.rootElement.name.local, equals('NFe'));
  });

  test('XML contém elemento <emit>', () {
    final xml = nfe.toXmlString();
    expect(xml, contains('<emit>'));
    expect(xml, contains('EMPRESA TESTE LTDA'));
    expect(xml, contains('12345678000195'));
  });

  test('XML contém elemento <det>', () {
    final xml = nfe.toXmlString();
    expect(xml, contains('nItem="1"'));
    expect(xml, contains('<det '));
    expect(xml, contains('PRODUTO TESTE'));
  });

  test('XML contém elemento <total>', () {
    final xml = nfe.toXmlString();
    expect(xml, contains('<total>'));
    expect(xml, contains('<ICMSTot>'));
  });

  test('XML contém elemento <pag>', () {
    final xml = nfe.toXmlString();
    expect(xml, contains('<pag>'));
    expect(xml, contains('<detPag>'));
  });

  test('fromXmlString reconstrói a NFCe', () {
    final xml = nfe.toXmlString();
    final rebuilt = Nfe.fromXmlString(xml);

    expect(rebuilt.infNfce.emit.xNome, equals('EMPRESA TESTE LTDA'));
    expect(rebuilt.infNfce.emit.cnpj, equals('12345678000195'));
    expect(rebuilt.infNfce.det.length, equals(1));
    expect(rebuilt.infNfce.det.first.prod.xProd, equals('PRODUTO TESTE'));
    expect(rebuilt.infNfce.det.first.prod.vProd, equals(10.00));
    expect(rebuilt.infNfce.total.icmsTot.vNF, equals(10.00));
    expect(rebuilt.infNfce.pag.detPag.first.tPag, equals(EFormaPagamento.dinheiro));
    expect(rebuilt.infNfce.pag.detPag.first.vPag, equals(10.00));
  });
}
