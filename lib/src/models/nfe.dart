import 'package:dfe_dart/src/models/ide.dart';
import 'package:dfe_dart/src/models/inf_nfce.dart';
import 'package:dfe_dart/src/models/inf_nfe_supl.dart';
import 'package:xml/xml.dart';

const _xmlns = 'http://www.portalfiscal.inf.br/nfe';

class Nfe {
  InfNfceModel infNfce;
  IdeModel? ide;
  InfNFeSupl? infNFeSupl;

  Nfe({required this.infNfce, this.ide, this.infNFeSupl});

  /// Monta o Id da NF-e no formato "NFecUFcNFcMunF..." (44 dígitos).
  /// Deve ser sobrescrito pelo Id real quando disponível (após cálculo do cDV).
  String get id {
    final ide = infNfce.ide;
    final cUF = ide.cUF.codigo.padLeft(2, '0');
    final aamm = '${ide.dhEmi.year}${ide.dhEmi.month.toString().padLeft(2, '0')}';
    final mod = (ide.mod?.xmlValue ?? '65').padLeft(2, '0');
    final serie = ide.serie.toString().padLeft(3, '0');
    final nNF = ide.nNF.toString().padLeft(9, '0');
    final tpEmis = ide.tpEmis?.xmlValue ?? '1';
    final cNF = (ide.cNF ?? '').padLeft(8, '0');
    final cDV = ide.cDV.toString();
    // CNPJ do emitente (placeholder: 14 zeros — substituir pelo CNPJ real)
    const cnpj = '00000000000000';
    return 'NFe$cUF$aamm$cnpj$mod$serie$nNF$tpEmis$cNF$cDV';
  }

  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element(
      'NFe',
      attributes: {'xmlns': _xmlns},
      nest: () {
        builder.xml(infNfce.writeXml(id: id).toXmlString());
        if (infNFeSupl != null) {
          builder.xml(infNFeSupl!.writeXml().toXmlString());
        }
      },
    );
    return builder.buildDocument().rootElement;
  }

  /// Serializa a NF-e como string XML completa.
  String toXmlString({bool pretty = false}) {
    final doc = writeXml().document!;
    return pretty ? doc.toXmlString(pretty: true, indent: '  ') : doc.toXmlString();
  }

  static Nfe fromXml(XmlElement element) {
    final infNfceEl = element.findElements('infNFe').single;
    final infNFeSuplEls = element.findElements('infNFeSupl');

    InfNFeSupl? supl;
    if (infNFeSuplEls.isNotEmpty) {
      supl = InfNFeSupl();
      supl.readXml(infNFeSuplEls.single);
    }

    return Nfe(
      infNfce: InfNfceModel.fromXml(infNfceEl),
      infNFeSupl: supl,
    );
  }

  /// Faz o parse de uma string XML e retorna a NF-e.
  static Nfe fromXmlString(String xml) {
    final doc = XmlDocument.parse(xml);
    return fromXml(doc.rootElement);
  }
}
