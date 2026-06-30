import 'package:dfe_dart/src/enum/versao_servico.dart';
import 'package:dfe_dart/src/models/ide.dart';
import 'package:dfe_dart/src/models/emit.dart';
import 'package:dfe_dart/src/models/dest.dart';
import 'package:dfe_dart/src/models/det.dart';
import 'package:dfe_dart/src/models/total.dart';
import 'package:dfe_dart/src/models/pag.dart';
import 'package:dfe_dart/src/models/transp.dart';
import 'package:xml/xml.dart';

class InfNfceModel {
  EVersaoServico versao;
  IdeModel ide;
  EmitModel emit;
  DestModel? dest;
  List<DetModel> det;
  TotalModel total;
  TranspModel? transp;
  PagModel pag;

  InfNfceModel({
    required this.versao,
    required this.ide,
    required this.emit,
    this.dest,
    required this.det,
    required this.total,
    this.transp,
    required this.pag,
  }) : assert(det.isNotEmpty, 'det must have at least one item');

  /// Gera o elemento <infNFe versao="..." Id="...">
  /// [id] é o atributo Id da NF-e (ex: "NFe35...")
  XmlElement writeXml({required String id}) {
    final builder = XmlBuilder();
    builder.element(
      'infNFe',
      attributes: {
        'versao': versao.xmlValue,
        'Id': id,
      },
      nest: () {
        builder.xml(ide.writeXml().toXmlString());
        builder.xml(emit.writeXml().toXmlString());
        if (dest != null) {
          builder.xml(dest!.writeXml().toXmlString());
        }
        for (final item in det) {
          item.writeXml(builder);
        }
        total.writeXml(builder);
        if (transp != null) {
          transp!.writeXml(builder);
        }
        builder.xml(pag.writeXml().toXmlString());
      },
    );
    return builder.buildDocument().rootElement;
  }

  static InfNfceModel fromXml(XmlElement element) {
    final versaoStr = element.getAttribute('versao') ?? '';
    final ideEl = element.findElements('ide').single;
    final emitEl = element.findElements('emit').single;
    final destEls = element.findElements('dest');
    final detEls = element.findElements('det').toList();
    final totalEl = element.findElements('total').single;
    final transpEls = element.findElements('transp');
    final pagEl = element.findElements('pag').single;

    return InfNfceModel(
      versao: EVersaoServico.values.firstWhere((e) => e.xmlValue == versaoStr),
      ide: IdeModel.fromXml(ideEl),
      emit: EmitModel.fromXml(emitEl),
      dest: destEls.isEmpty ? null : DestModel.fromXml(destEls.single),
      det: detEls.map((e) => DetModel.fromXml(e)).toList(),
      total: TotalModel.fromXml(totalEl),
      transp: transpEls.isEmpty ? null : TranspModel.fromXml(transpEls.single),
      pag: PagModel.fromXml(pagEl),
    );
  }
}
