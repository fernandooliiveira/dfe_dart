import 'package:xml/xml.dart';
import 'package:xml_sign_dart/src/entidades/dest.dart';
import 'package:xml_sign_dart/src/entidades/det.dart';
import 'package:xml_sign_dart/src/entidades/emit.dart';
import 'package:xml_sign_dart/src/entidades/inf_adic.dart';
import 'package:xml_sign_dart/src/entidades/pag.dart';
import 'package:xml_sign_dart/src/entidades/signature.dart';
import 'package:xml_sign_dart/src/entidades/total.dart';
import 'package:xml_sign_dart/src/entidades/transp.dart';

/// Representa uma Nota Fiscal Eletrônica (NFe ou NFCe) completa
class NFe {
  final InfNFe infNFe;
  final Signature? signature;
  final InfNFeSupl? infNFeSupl;

  NFe({required this.infNFe, this.signature, this.infNFeSupl});

  /// Converte para XML
  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');

    builder.element(
      'NFe',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');

        // infNFe
        infNFe.buildXml(builder);

        // Signature (adicionada após assinatura)
        if (signature != null) {
          signature!.buildXml(builder);
        }

        // infNFeSupl (para NFC-e com QRCode)
        if (infNFeSupl != null) {
          infNFeSupl!.buildXml(builder);
        }
      },
    );

    return builder.buildDocument();
  }

  /// Parse de XML para objeto
  factory NFe.fromXml(XmlDocument doc) {
    final nfeElement = doc.findElements('NFe').first;

    return NFe(
      infNFe: InfNFe.fromXml(nfeElement.findElements('infNFe').first),
      signature: nfeElement.findElements('Signature').isNotEmpty
          ? Signature.fromXml(nfeElement.findElements('Signature').first)
          : null,
      infNFeSupl: nfeElement.findElements('infNFeSupl').isNotEmpty
          ? InfNFeSupl.fromXml(nfeElement.findElements('infNFeSupl').first)
          : null,
    );
  }

  @override
  String toString() => toXml().toXmlString(pretty: true);
}

/// Informações da NF-e
class InfNFe {
  final String id; // Ex: NFe35240712345678000195650010000000011234567890
  final String versao; // Ex: 4.00
  final Ide ide;
  final Emit emit;
  final Dest? dest;
  final List<Det> det;
  final Total total;
  final Transp transp;
  final Pag? pag;
  final InfAdic? infAdic;
  final InfRespTec? infRespTec;

  InfNFe({
    required this.id,
    this.versao = '4.00',
    required this.ide,
    required this.emit,
    this.dest,
    required this.det,
    required this.total,
    required this.transp,
    this.pag,
    this.infAdic,
    this.infRespTec,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'infNFe',
      nest: () {
        builder.attribute('Id', id);
        builder.attribute('versao', versao);

        ide.buildXml(builder);
        emit.buildXml(builder);
        if (dest != null) dest!.buildXml(builder);

        for (final item in det) {
          item.buildXml(builder);
        }

        total.buildXml(builder);
        transp.buildXml(builder);
        if (pag != null) pag!.buildXml(builder);
        if (infAdic != null) infAdic!.buildXml(builder);
        if (infRespTec != null) infRespTec!.buildXml(builder);
      },
    );
  }

  factory InfNFe.fromXml(XmlElement element) {
    return InfNFe(
      id: element.getAttribute('Id')!,
      versao: element.getAttribute('versao') ?? '4.00',
      ide: Ide.fromXml(element.findElements('ide').first),
      emit: Emit.fromXml(element.findElements('emit').first),
      dest: element.findElements('dest').isNotEmpty
          ? Dest.fromXml(element.findElements('dest').first)
          : null,
      det: element.findElements('det').map((e) => Det.fromXml(e)).toList(),
      total: Total.fromXml(element.findElements('total').first),
      transp: Transp.fromXml(element.findElements('transp').first),
      pag: element.findElements('pag').isNotEmpty
          ? Pag.fromXml(element.findElements('pag').first)
          : null,
      infAdic: element.findElements('infAdic').isNotEmpty
          ? InfAdic.fromXml(element.findElements('infAdic').first)
          : null,
      infRespTec: element.findElements('infRespTec').isNotEmpty
          ? InfRespTec.fromXml(element.findElements('infRespTec').first)
          : null,
    );
  }
}

/// Identificação da NF-e
class Ide {
  final String cUF; // Código UF (2 dígitos)
  final String cNF; // Código numérico (8 dígitos)
  final String natOp; // Natureza da operação
  final String mod; // 55=NFe, 65=NFCe
  final String serie;
  final String nNF;
  final String dhEmi; // Data/hora emissão (formato: AAAA-MM-DDTHH:MM:SS-HH:MM)
  final String tpNF; // 0=Entrada, 1=Saída
  final String idDest; // 1=Operação interna, 2=Interestadual, 3=Exterior
  final String cMunFG; // Código município IBGE
  final String tpImp; // 1=DANFE Retrato, 4=DANFE NFCe
  final String tpEmis; // 1=Normal, 9=Contingência
  final String cDV; // Dígito verificador da chave
  final String tpAmb; // 1=Produção, 2=Homologação
  final String finNFe; // 1=Normal, 2=Complementar, 3=Ajuste, 4=Devolução
  final String indFinal; // 0=Normal, 1=Consumidor final
  final String indPres; // 1=Presencial, 2=Internet, 9=Outros
  final String procEmi; // 0=Aplicativo contribuinte
  final String verProc; // Versão do aplicativo

  Ide({
    required this.cUF,
    required this.cNF,
    required this.natOp,
    required this.mod,
    required this.serie,
    required this.nNF,
    required this.dhEmi,
    required this.tpNF,
    required this.idDest,
    required this.cMunFG,
    required this.tpImp,
    required this.tpEmis,
    required this.cDV,
    required this.tpAmb,
    required this.finNFe,
    required this.indFinal,
    required this.indPres,
    required this.procEmi,
    required this.verProc,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'ide',
      nest: () {
        builder.element('cUF', nest: cUF);
        builder.element('cNF', nest: cNF);
        builder.element('natOp', nest: natOp);
        builder.element('mod', nest: mod);
        builder.element('serie', nest: serie);
        builder.element('nNF', nest: nNF);
        builder.element('dhEmi', nest: dhEmi);
        builder.element('tpNF', nest: tpNF);
        builder.element('idDest', nest: idDest);
        builder.element('cMunFG', nest: cMunFG);
        builder.element('tpImp', nest: tpImp);
        builder.element('tpEmis', nest: tpEmis);
        builder.element('cDV', nest: cDV);
        builder.element('tpAmb', nest: tpAmb);
        builder.element('finNFe', nest: finNFe);
        builder.element('indFinal', nest: indFinal);
        builder.element('indPres', nest: indPres);
        builder.element('procEmi', nest: procEmi);
        builder.element('verProc', nest: verProc);
      },
    );
  }

  factory Ide.fromXml(XmlElement element) {
    return Ide(
      cUF: element.findElements('cUF').first.innerText,
      cNF: element.findElements('cNF').first.innerText,
      natOp: element.findElements('natOp').first.innerText,
      mod: element.findElements('mod').first.innerText,
      serie: element.findElements('serie').first.innerText,
      nNF: element.findElements('nNF').first.innerText,
      dhEmi: element.findElements('dhEmi').first.innerText,
      tpNF: element.findElements('tpNF').first.innerText,
      idDest: element.findElements('idDest').first.innerText,
      cMunFG: element.findElements('cMunFG').first.innerText,
      tpImp: element.findElements('tpImp').first.innerText,
      tpEmis: element.findElements('tpEmis').first.innerText,
      cDV: element.findElements('cDV').first.innerText,
      tpAmb: element.findElements('tpAmb').first.innerText,
      finNFe: element.findElements('finNFe').first.innerText,
      indFinal: element.findElements('indFinal').first.innerText,
      indPres: element.findElements('indPres').first.innerText,
      procEmi: element.findElements('procEmi').first.innerText,
      verProc: element.findElements('verProc').first.innerText,
    );
  }
}

/// Informacoes suplementares (QRCode para NFC-e)
class InfNFeSupl {
  final String qrCode;
  final String urlChave;

  InfNFeSupl({required this.qrCode, required this.urlChave});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'infNFeSupl',
      nest: () {
        builder.element(
          'qrCode',
          nest: () {
            builder.cdata(qrCode);
          },
        );
        builder.element('urlChave', nest: urlChave);
      },
    );
  }

  factory InfNFeSupl.fromXml(XmlElement element) {
    return InfNFeSupl(
      qrCode: element.findElements('qrCode').first.innerText,
      urlChave: element.findElements('urlChave').first.innerText,
    );
  }
}
