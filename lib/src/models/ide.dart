import 'package:dfe_dart/src/enum/_init.dart';
import 'package:dfe_dart/src/utils/extensions/date_time_extension.dart';
import 'package:xml/xml.dart';

class IdeModel {
  EEstado cUF;
  String? cNF;
  String? natOp;
  EIndicadorPagamento? indPag;
  EModeloDocumento? mod;
  int serie;
  int nNF;
  DateTime dEmi;
  DateTime dSaiEnt;
  DateTime dhEmi;
  DateTime? dhSaiEnt;
  ETipoNfe? tpNF;
  EDestinoOperacao? idDest;
  int cMunF;
  ETipoImpressao? tpImp;
  ETipoEmissao? tpEmis;
  int cDV;
  ETipoAmbiente tpAmb;
  EFinalidadeNFe? finNFe;
  EConsumidorFinal? indFinal;
  EPresencaComprador? indPres;
  EIndicadorIntermediador? indIntermed;
  ProcessoEmissao? procEmi;
  String? verProc;
  DateTime? dhCont;
  String? xJust;
  // Chaves de acesso de NF-e referenciadas (44 dígitos cada)
  List<String>? nFref;

  IdeModel({
    required this.cUF,
    this.cNF,
    this.natOp,
    this.indPag,
    this.mod,
    required this.serie,
    required this.nNF,
    required this.dEmi,
    required this.dSaiEnt,
    required this.dhEmi,
    this.dhSaiEnt,
    this.tpNF,
    this.idDest,
    required this.cMunF,
    this.tpImp,
    this.tpEmis,
    required this.cDV,
    required this.tpAmb,
    this.finNFe,
    this.indFinal,
    this.indPres,
    this.indIntermed,
    this.procEmi,
    this.verProc,
    this.dhCont,
    this.xJust,
    this.nFref,
  });

  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ide', nest: () {
      builder.element('cUF', nest: cUF.codigo);
      builder.element('cNF', nest: (cNF ?? '').padLeft(8, '0'));
      if (natOp != null) builder.element('natOp', nest: natOp!);
      if (mod != null) builder.element('mod', nest: mod!.xmlValue);
      builder.element('serie', nest: serie.toString().padLeft(3, '0'));
      builder.element('nNF', nest: nNF.toString().padLeft(9, '0'));
      builder.element('dhEmi', nest: dhEmi.paraDataStringNfe());
      if (dhSaiEnt != null) {
        builder.element('dhSaiEnt', nest: dhSaiEnt!.paraDataStringNfe());
      }
      if (tpNF != null) builder.element('tpNF', nest: tpNF!.xmlValue);
      if (idDest != null) builder.element('idDest', nest: idDest!.xmlValue);
      builder.element('cMunF', nest: cMunF.toString());
      if (tpImp != null) builder.element('tpImp', nest: tpImp!.xmlValue);
      if (tpEmis != null) builder.element('tpEmis', nest: tpEmis!.xmlValue);
      builder.element('cDV', nest: cDV.toString());
      builder.element('tpAmb', nest: tpAmb.xmlValue);
      if (finNFe != null) builder.element('finNFe', nest: finNFe!.xmlValue);
      if (indFinal != null) builder.element('indFinal', nest: indFinal!.xmlValue);
      if (indPres != null) builder.element('indPres', nest: indPres!.xmlValue);
      if (indIntermed != null) builder.element('indIntermed', nest: indIntermed!.xmlValue);
      if (procEmi != null) builder.element('procEmi', nest: procEmi!.xmlValue);
      if (verProc != null) builder.element('verProc', nest: verProc!);
      if (dhCont != null) builder.element('dhCont', nest: dhCont!.paraDataStringNfe());
      if (xJust != null) builder.element('xJust', nest: xJust!);
      if (nFref != null) {
        for (final chave in nFref!) {
          builder.element('NFref', nest: () {
            builder.element('refNFe', nest: chave);
          });
        }
      }
    });
    return builder.buildDocument().rootElement;
  }

  static IdeModel fromXml(XmlElement element) {
    String? text(String tag) {
      final els = element.findElements(tag);
      return els.isEmpty ? null : els.single.innerText;
    }

    String req(String tag) => element.findElements(tag).single.innerText;

    final nFrefEls = element.findAllElements('NFref').toList();
    final refs = nFrefEls.isEmpty
        ? null
        : nFrefEls
            .map((e) => e.findElements('refNFe').single.innerText)
            .toList();

    return IdeModel(
      cUF: EEstado.values.firstWhere((e) => e.codigo == req('cUF')),
      cNF: text('cNF'),
      natOp: text('natOp'),
      mod: () {
        final v = text('mod');
        return v == null ? null : EModeloDocumento.values.firstWhere((e) => e.xmlValue == v);
      }(),
      serie: int.parse(req('serie')),
      nNF: int.parse(req('nNF')),
      dEmi: DateTime.now(),
      dSaiEnt: DateTime.now(),
      dhEmi: DateTime.parse(req('dhEmi')),
      dhSaiEnt: () {
        final v = text('dhSaiEnt');
        return v == null ? null : DateTime.parse(v);
      }(),
      tpNF: () {
        final v = text('tpNF');
        return v == null ? null : ETipoNfe.values.firstWhere((e) => e.xmlValue == v);
      }(),
      idDest: () {
        final v = text('idDest');
        return v == null ? null : EDestinoOperacao.values.firstWhere((e) => e.xmlValue == v);
      }(),
      cMunF: int.parse(req('cMunF')),
      tpImp: () {
        final v = text('tpImp');
        return v == null ? null : ETipoImpressao.values.firstWhere((e) => e.xmlValue == v);
      }(),
      tpEmis: () {
        final v = text('tpEmis');
        return v == null ? null : ETipoEmissao.values.firstWhere((e) => e.xmlValue == v);
      }(),
      cDV: int.parse(req('cDV')),
      tpAmb: ETipoAmbiente.values.firstWhere((e) => e.xmlValue == req('tpAmb')),
      finNFe: () {
        final v = text('finNFe');
        return v == null ? null : EFinalidadeNFe.values.firstWhere((e) => e.xmlValue == v);
      }(),
      indFinal: () {
        final v = text('indFinal');
        return v == null ? null : EConsumidorFinal.values.firstWhere((e) => e.xmlValue == v);
      }(),
      indPres: () {
        final v = text('indPres');
        return v == null ? null : EPresencaComprador.values.firstWhere((e) => e.xmlValue == v);
      }(),
      indIntermed: () {
        final v = text('indIntermed');
        return v == null ? null : EIndicadorIntermediador.values.firstWhere((e) => e.xmlValue == v);
      }(),
      procEmi: () {
        final v = text('procEmi');
        return v == null ? null : ProcessoEmissao.values.firstWhere((e) => e.xmlValue == v);
      }(),
      verProc: text('verProc'),
      dhCont: () {
        final v = text('dhCont');
        return v == null ? null : DateTime.parse(v);
      }(),
      xJust: text('xJust'),
      nFref: refs,
    );
  }
}
